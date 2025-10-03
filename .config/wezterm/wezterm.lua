-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

-- When the BEL ascii sequence is sent to a pane, the bell is "rung" in that pane.
config.audible_bell = "Disabled"
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}

-- For example, changing the color scheme:
config.color_scheme = 'dayfox'

-- Choose your favourite font, make sure it's installed on your machine
-- config.font = wezterm.font({ family = 'JetBrains Mono' })
config.font = wezterm.font({ family = 'Maple Mono' })

-- Disable ligatures in most fonts
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }

-- Controls the alignment of the terminal cells inside the window.
config.window_content_alignment = {
  horizontal = 'Center',
  vertical = 'Center',
}

-- Controls the amount of padding between the window border and the terminal cells.
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- The tab bar is hidden from the display when there is only a single tab
config.hide_tab_bar_if_only_one_tab = true

-- Show the tab bar by default
config.enable_tab_bar = true

-- Transitioning to full screen will use the macOS native full screen mode
config.native_macos_fullscreen_mode = true

-- Whether to display a confirmation prompt when the window is closed by the
-- windowing environment
config.window_close_confirmation = 'NeverPrompt'

-- Config overrides
wezterm.on( 'toggle-tab-bar', function( window, pane )
  local config = window:effective_config()
  local overrides = window:get_config_overrides() or {}
  if config.enable_tab_bar then
    overrides.enable_tab_bar = false
  else
    overrides.enable_tab_bar = true
  end
  window:set_config_overrides(overrides)
end)

-- Extend Hyperlink rules
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- Matches: 8 digit changelist numbers
table.insert( config.hyperlink_rules, {
  regex = [[\d{8}]],
  format = 'http://cl/$0',
} )
  -- Matches: 5-7 digit bug numbers
table.insert( config.hyperlink_rules, {
  regex = [[\d{5,7}]],
  format = 'http://bb/$0',
} )

-- Bind keys
config.leader = { key = 'b', mods = 'CTRL' }
config.keys = {
  -- CMD-` will switch back to the last active tab
  {
    key = '`',
    mods = 'CMD',
    action = wezterm.action.ActivateLastTab,
  },
  -- Change CTRL-PageUp/PageDown to CMD-PageUp/PageDown for tab activation
  {
    key = 'PageUp',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'PageDown',
    mods = 'CTRL',
    action = wezterm.action.DisableDefaultAssignment,
  },
  {
    key = 'PageUp',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(-1),
  },
  {
    key = 'PageDown',
    mods = 'CMD',
    action = wezterm.action.ActivateTabRelative(1),
  },
  -- LEADER-n will show tab navigator
  {
    key = 'n',
    mods = 'LEADER',
    action = wezterm.action.ShowTabNavigator,
  },
  -- LEADER-t will toggle the tab bar
  {
    key = 't',
    mods = 'LEADER',
    action = wezterm.action.EmitEvent 'toggle-tab-bar',
  },
  -- -- LEADER-d will synchronize Arista containers to domains
  -- {
  --   key = 'd',
  --   mods = 'LEADER',
  --   action = wezterm.action_callback( function( window, pane )
  --       -- Get current containers from the home bus
  --       -- TODO: Try wezterm.run_child_process here
  --       local command = 'ssh -A bus-home "a4c ps -u jeff --json"'
  --       local handle = assert(io.popen( command, 'r' ) )
  --       local result = handle:read( '*a' )
  --       handle:close()
  --       local containers = wezterm.serde.json_decode( result )
  --
  --       -- Create a new list of SSH domains by adding the discovered
  --       -- containers
  --       local sshDomains = { wezterm.GLOBAL.homeDomain, }
  --       for _, container in ipairs( containers ) do
  --         -- Create a new domain based on the home domain
  --         domain = {}
  --         for k, v in pairs( wezterm.GLOBAL.homeDomain ) do
  --           domain[ k ] = v
  --         end
  --         domain.name = container.nickname
  --         domain.remote_address = container.ctnrHostname
  --
  --         -- Add the domain to the new domains
  --         table.insert( sshDomains, domain )
  --       end
  --
  --       -- Update the configured SSH domains
  --       wezterm.GLOBAL.sshDomains = sshDomains
  --
  --       -- Reload configuration
  --       wezterm.reload_configuration()
  --     end ),
  -- },
}

-- -- SSH domains
-- wezterm.GLOBAL.homeDomain = {
--    -- The name of this specific domain.  Must be unique amongst
--    -- all types of domain in the configuration file.
--    name = 'bus-home',
--
--    -- identifies the host:port pair of the remote server
--    -- Can be a DNS name or an IP address with an optional
--    -- ":port" on the end.
--    remote_address = 'jeff-home',
--
--    -- Whether agent auth should be disabled.
--    -- Set to true to disable it.
--    no_agent_auth = true,
--
--    -- The username to use for authenticating with the remote host
--    username = 'jeff',
--
--    multiplexing = 'WezTerm',
--    overlay_lag_indicator = true,
--    remote_wezterm_path = '/home/jeff/bin/nix-enter wezterm'
-- }
--
-- -- Set the configured SSH domains
-- config.ssh_domains = wezterm.GLOBAL.sshDomains or {}
-- wezterm.log_info( 'ssh_domains', config.ssh_domains )

-- and finally, return the configuration to wezterm
return config
