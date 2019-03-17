require("lib.debug")

-- how does it work?
-- automated trains are only loadable when stopped at a station
-- manual trains are loadable whenever they're not moving
-- when a train stops at a signal, switch it to manual mode
-- every few ticks, switch it back to automatic mode to check for a path forward

-- todo
-- find a way to check wait signal in manual mode, to cut down on global state changes
-- make the behavior configurable or have its own special entity

local function onInit(event)
  global.ModifiedTrains = global.ModifiedTrains or { }
end

local function onTrainChangedState(event)
  local train = event and event.train
  if train
    and train.state == defines.train_state.wait_signal
    and not train.manual_mode
  then
    debug({ "setting train to manual", id = train.id })
    train.manual_mode = true
    table.insert(global.ModifiedTrains, train)
  end
end

local function resetAll()
  for key, train in pairs(global.ModifiedTrains) do
    debug({ "resetting train to automatic", id = train.id })
    table.remove(global.ModifiedTrains, key)
    train.manual_mode = false
  end
end

script.on_init(onInit)
script.on_event(defines.events.on_train_changed_state, onTrainChangedState)
script.on_nth_tick(60, resetAll)
