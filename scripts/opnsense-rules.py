#!/usr/bin/env python3
"""Dump OPNsense firewall rules (Filter [new]) as a table.

Reads OPNSENSE_URL, OPNSENSE_API_KEY, OPNSENSE_API_SECRET from environment
or from a .env file in the current/parent directories.
"""

import json
import os
import sys
import urllib.request
import urllib.error
import ssl
import base64
from pathlib import Path


def load_env():
    env_paths = [
        Path.cwd() / ".env",
        Path(__file__).resolve().parent.parent / ".env",
        Path.home() / "nix-config" / ".env",
    ]
    for p in env_paths:
        if p.is_file():
            for line in p.read_text().splitlines():
                line = line.strip()
                if not line or line.startswith("#"):
                    continue
                if line.startswith("export "):
                    line = line[len("export "):]
                if "=" not in line:
                    continue
                k, v = line.split("=", 1)
                v = v.strip().strip('"').strip("'")
                os.environ.setdefault(k.strip(), v)
            break


def api_post(url, key, secret, path, body=None):
    full = f"{url}{path}"
    auth = base64.b64encode(f"{key}:{secret}".encode()).decode()
    headers = {
        "Authorization": f"Basic {auth}",
        "Content-Type": "application/json",
    }
    data = json.dumps(body).encode() if body is not None else b""
    req = urllib.request.Request(full, data=data, headers=headers, method="POST")
    ctx = ssl.create_default_context()
    ctx.check_hostname = False
    ctx.verify_mode = ssl.CERT_NONE
    with urllib.request.urlopen(req, context=ctx, timeout=10) as resp:
        return json.loads(resp.read())


def fetch_rules(url, key, secret):
    body = {"current": 1, "rowCount": 1000}
    return api_post(url, key, secret, "/api/firewall/filter/searchRule", body)


def fetch_aliases(url, key, secret):
    body = {"current": 1, "rowCount": 1000}
    return api_post(url, key, secret, "/api/firewall/alias/searchItem", body)


def truncate(s, n):
    return s if len(s) <= n else s[: n - 1] + "…"


ANSI_RESET = "\x1b[0m"
ANSI_DIM = "\x1b[2m"
ANSI_GREEN = "\x1b[32m"
ANSI_RED = "\x1b[31m"


def color_for(rule, use_color):
    if not use_color:
        return ""
    if rule["enabled"] != "1":
        return ANSI_DIM
    act = rule["action"]
    if act == "pass":
        return ANSI_GREEN
    if act in ("block", "reject"):
        return ANSI_RED
    return ""


def render_aliases(aliases, force_color=False):
    use_color = force_color or (sys.stdout.isatty() and os.environ.get("NO_COLOR") is None)
    aliases = sorted(aliases, key=lambda a: (a.get("type", ""), a.get("name", "")))
    cols = [
        ("name", 25, lambda a: a.get("name", "")),
        ("en", 2, lambda a: "E" if a.get("enabled") == "1" else "D"),
        ("type", 14, lambda a: a.get("type", "")),
        ("count", 6, lambda a: a.get("current_items", "")),
        ("content", 50, lambda a: (a.get("content", "") or "").replace("\n", ",")),
        ("description", 40, lambda a: a.get("description", "")),
    ]
    header = "  ".join(f"{n:<{w}}" for n, w, _ in cols)
    sep = "  ".join("-" * w for _, w, _ in cols)
    print(header)
    print(sep)
    for a in aliases:
        row = "  ".join(f"{truncate(str(g(a)), w):<{w}}" for _, w, g in cols)
        c = ANSI_DIM if (use_color and a.get("enabled") != "1") else ""
        print(f"{c}{row}{ANSI_RESET if c else ''}")


def render_table(rules, force_color=False):
    use_color = force_color or (sys.stdout.isatty() and os.environ.get("NO_COLOR") is None)
    rules = sorted(rules, key=lambda r: int(r["sequence"]))

    cols = [
        ("seq", 5, lambda r: r["sequence"]),
        ("en", 2, lambda r: "E" if r["enabled"] == "1" else "D"),
        ("log", 3, lambda r: "L" if r.get("log") == "1" else ""),
        ("act", 5, lambda r: r["action"]),
        ("iface", 8, lambda r: r["interface"]),
        ("dir", 4, lambda r: r.get("direction", "")),
        ("ipv", 7, lambda r: r["ipprotocol"]),
        ("proto", 8, lambda r: r["protocol"]),
        ("src", 18, lambda r: f"{r['source_net']}:{r['source_port']}".rstrip(":")),
        ("dst", 22, lambda r: f"{r['destination_net']}:{r['destination_port']}".rstrip(":")),
        ("description", 50, lambda r: r["description"]),
    ]

    header = "  ".join(f"{n:<{w}}" for n, w, _ in cols)
    sep = "  ".join("-" * w for _, w, _ in cols)
    print(header)
    print(sep)
    for r in rules:
        row = "  ".join(f"{truncate(str(g(r)), w):<{w}}" for _, w, g in cols)
        c = color_for(r, use_color)
        print(f"{c}{row}{ANSI_RESET if c else ''}")


def main():
    load_env()
    url = os.environ.get("OPNSENSE_URL")
    key = os.environ.get("OPNSENSE_API_KEY")
    secret = os.environ.get("OPNSENSE_API_SECRET")
    if not (url and key and secret):
        print("missing OPNSENSE_URL / OPNSENSE_API_KEY / OPNSENSE_API_SECRET", file=sys.stderr)
        sys.exit(1)

    force_color = "--color" in sys.argv
    show_rules = "--aliases-only" not in sys.argv
    show_aliases = "--rules-only" not in sys.argv

    try:
        if show_rules:
            data = fetch_rules(url, key, secret)
            rules = data.get("rows", [])
            print(f"# rules: {data.get('total', len(rules))}\n")
            render_table(rules, force_color=force_color)
        if show_rules and show_aliases:
            print()
        if show_aliases:
            adata = fetch_aliases(url, key, secret)
            aliases = adata.get("rows", [])
            print(f"# aliases: {adata.get('total', len(aliases))}\n")
            render_aliases(aliases, force_color=force_color)
    except urllib.error.HTTPError as e:
        print(f"HTTP {e.code}: {e.read().decode()}", file=sys.stderr)
        sys.exit(1)
    except urllib.error.URLError as e:
        print(f"connection error: {e.reason}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
