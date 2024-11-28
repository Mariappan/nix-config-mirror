local module = {}

local wezterm = require("wezterm")

function module.apply(config)
  local SSH_AUTH_SOCK = os.getenv 'SSH_AUTH_SOCK'
  if
    SSH_AUTH_SOCK == string.format('%s/keyring/ssh', os.getenv 'XDG_RUNTIME_DIR')
  then
    local onep_auth = string.format('%s/.1password/agent.sock', wezterm.home_dir)
    -- Glob is being used here as an indirect way to check to see if
    -- the socket exists or not. If it didn't, the length of the result
    -- would be 0
    if #wezterm.glob(onep_auth) == 1 then
      config.default_ssh_auth_sock = onep_auth
    end
  end

end

return module
