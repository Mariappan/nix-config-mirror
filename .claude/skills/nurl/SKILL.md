---
name: nurl
description: Use this skill when fetching source hashes or generating Nix fetcher expressions for packages, overlays, and flake inputs. Triggers on phrases like "get the hash", "update the hash", "fetch sha256", "prefetch", "generate fetcher", "update package version", or when editing `fetchurl`/`fetchFromGitHub`/`fetchgit`/`fetchzip` calls in Nix files.
version: 1.0.0
---

# nurl — Nix fetcher hash helper

`nurl` generates Nix fetcher calls (and their hashes) from a URL. Prefer it over `nix-prefetch-url`, `nix-prefetch-git`, and ad-hoc `nix store prefetch-file` for this repo.

## When to use

- Bumping a package version in an overlay and needing a fresh `hash = "sha256-..."`.
- Adding a new `fetchFromGitHub` / `fetchFromGitLab` / `fetchgit` / `fetchurl` source.
- Updating a flake input pinned by revision.
- Verifying a hash before committing a change.

## Invocation

If `nurl` is on `$PATH`, call it directly. Otherwise:

```sh
nix run nixpkgs#nurl -- <args>
```

### Common forms

| Goal | Command |
| --- | --- |
| Generate a full fetcher block from a repo URL + rev | `nurl <url> <rev>` |
| Hash only (paste into an existing block) | `nurl -H <url> <rev>` |
| Plain file download (tarballs, release binaries) | `nurl -f fetchurl -H <url>` |
| Fetch a GitHub/GitLab tag/branch | `nurl https://github.com/owner/repo v1.2.3` |
| Include submodules | `nurl -S <url> <rev>` |
| JSON output (scripting) | `nurl -j <url> <rev>` |
| Parse URL without hitting the network | `nurl -p <url>` |

### Fetcher override

Without a hint, nurl infers the fetcher from the URL host. If the URL is a plain HTTPS file (Google Cloud Storage, release artifact, etc.), the default fallback is `fetchgit` and nurl will fail with *"fetchgit does not support fetching the latest revision"*. Fix: `-f fetchurl`.

Available `-f` values: `builtins.fetchGit`, `fetchCrate`, `fetchFromBitbucket`, `fetchFromGitHub`, `fetchFromGitLab`, `fetchFromGitea`, `fetchFromGitiles`, `fetchFromRepoOrCz`, `fetchFromSourcehut`, `fetchHex`, `fetchPypi`, `fetchgit`, `fetchhg`, `fetchpatch`, `fetchpatch2`, `fetchsvn`, `fetchurl`, `fetchzip`.

## Workflow: updating an overlay pin

1. Find the source block (e.g. `overlays/default.nix`) and note the URL template + new version.
2. Construct the concrete URL for the new version.
3. Run `nurl -f fetchurl -H <url>` (or omit `-f` for repo URLs).
4. Paste the returned `sha256-...` into the `hash = "..."` field.
5. Bump the `version` string alongside it.

## Example — this repo's `claude-code-bin` override

```sh
nurl -f fetchurl -H "https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases/2.1.116/linux-x64/claude"
# → sha256-DRrqXOBWpc5JHafpu+Y/mSWF5cJIUvAjoHyPGM8pLMU=
```

## Do not

- Do not use `nix-prefetch-url` — user has asked for nurl instead.
- Do not hand-edit a hash to `lib.fakeHash` and trigger a full `nixos-rebuild` just to read the mismatch error. That runs a build the user has asked not to run.
- Do not guess a hash or reuse an old one across versions.
