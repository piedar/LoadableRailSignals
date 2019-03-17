
local shouldDebug = true
function debug(...)
  if not shouldDebug then return end
  local length = select("#", ...)
  local messages = length == 1 and select(1, ...) or { ... }
  print(serpent.block(messages))
end
