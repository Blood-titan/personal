-- Limit maximum volume to 100% (1.0). Adjust as needed, e.g., 0.8 for 80%
local MAX_VOLUME = 1.0

local function clamp_volume(volume)
  if volume > MAX_VOLUME then
    return MAX_VOLUME
  end
  return volume
end

-- Hook into volume changes
rule = {
  matches = {
    { { "node.name", "matches", ".*" } },
  },
  apply_properties = function(properties)
    if properties["volume"] then
      properties["volume"] = clamp_volume(properties["volume"])
    end
  end,
}

table.insert(alsa_monitor.rules, rule)
