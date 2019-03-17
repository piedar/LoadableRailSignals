require("lib.debug")

-- how does it work?
-- automated trains are only loadable when stopped at a station
-- manual trains are loadable whenever they're not moving
-- when a train stops at a signal, switch it to manual mode
-- every few ticks, switch it back to automatic mode to check for a path forward

-- todo
-- find a way to check wait signal in manual mode, to cut down on global state changes
-- make the behavior configurable or have its own special entity

local function describeTrainState(state)
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

local function onInit(event)
  global.ModifiedTrains = global.ModifiedTrains or { }
end

local function onTrainChangedState(event)
  local train = event and event.train
  if train
    and train.state == defines.train_state.wait_signal
    and not train.manual_mode
  then
    train.manual_mode = true
    table.insert(global.ModifiedTrains, train)
    debug({ "set train to manual",
      trainId = train.id,
      oldState = describeTrainState(event.old_state),
      newState = describeTrainState(train.state),
    })
  end
end

local function resetAll()
  for key, train in pairs(global.ModifiedTrains) do
    local oldState = train.state
    table.remove(global.ModifiedTrains, key)
    train.manual_mode = false
    debug({ "reset train to automatic",
      trainId = train.id,
      oldState = describeTrainState(oldState),
      newState = describeTrainState(train.state),
    })
  end
end

script.on_init(onInit)
script.on_event(defines.events.on_train_changed_state, onTrainChangedState)
script.on_nth_tick(60, resetAll)
