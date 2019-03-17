require("lib.debug")
require("lib.describe")

-- how does it work?
-- automatic trains are only loadable when stopped at a station
-- manual trains are loadable whenever they're not moving
-- when a train stops at a signal, set it to manual
-- every few ticks, set it back to automatic to check for a path forward

-- todo
-- make the behavior configurable or have its own special entity


local function onInit(event)
  global.StoppedTrains = global.StoppedTrains or { }
end

local function onTrainChangedState(event)
  local train = event and event.train
  if train
    and train.state == defines.train_state.wait_signal
    and not train.manual_mode
  then
    train.manual_mode = true
    table.insert(global.StoppedTrains, train)
    debug({ "set train to manual",
      trainId = train.id,
      oldState = describeTrainState(event.old_state),
      newState = describeTrainState(train.state),
    })
  end
end

local function resetAll()
  for key, train in pairs(global.StoppedTrains) do
    local oldState = train.state
    train.manual_mode = false
    if train.state == defines.train_state.arrive_signal then
      train.manual_mode = true -- still waiting
    else
      table.remove(global.StoppedTrains, key)
      debug({ "reset train to automatic",
        trainId = train.id,
        oldState = describeTrainState(oldState),
        newState = describeTrainState(train.state),
      })
    end
  end
end

script.on_init(onInit)
script.on_event(defines.events.on_train_changed_state, onTrainChangedState)
script.on_nth_tick(30, resetAll)
