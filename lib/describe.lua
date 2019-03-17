
function describeTrainState(state)
  local states = { }
  states[defines.train_state.on_the_path] = "on_the_path"
  states[defines.train_state.path_lost] = "path_lost"
  states[defines.train_state.no_schedule] = "no_schedule"
  states[defines.train_state.no_path] = "no_path"
  states[defines.train_state.arrive_signal] = "arrive_signal"
  states[defines.train_state.wait_signal] = "wait_signal"
  states[defines.train_state.arrive_station] = "arrive_station"
  states[defines.train_state.wait_station] = "wait_station"
  states[defines.train_state.manual_control_stop] = "manual_control_stop"
  states[defines.train_state.manual_control] = "manual_control"
  return states[state] or "unknown: " .. tostring(state)
end
