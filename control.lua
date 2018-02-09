--[[
@ Keybindused is used to control the script (on_gui_opened), so it only work when his value is 0,
  and prevent to close the gui when the keybin key is presed to open the entity gui
@ RIE store the value of the settings mod, if its TRUE, switchbutton work like a normal constant combinators,
  if the value is FALSE, the switchbutton work in the oposite way, changing his state when player right-mouse it
  and open his gui inventory when the keybin is pressed
]]
local keybindused = 0

local function onKey(event)
  local RIE = settings.startup["ReverseOpenInventory"].value
  local player = game.players[event.player_index]
  local entity = player.selected
  keybindused = 1
  if entity and entity.valid then
--# the player should stand near the entity, if not near, entity cant be open
    local distance = math.abs(player.position.x-entity.position.x)+math.abs(player.position.y-entity.position.y)
--# If character is in range or god mode is enabled
    if distance < 15 or player.character == nil then
      local control = entity.get_or_create_control_behavior()
      if entity.name == "switchbutton" and RIE == true then
--# The inventory entity is opened if keybind is pressed
        --game.print(RIE) --just for debug test
--# If setting value is TRUE, gui is open only on keybind event
        player.opened = entity
      elseif entity.name == "switchbutton" and RIE == false then
--# If setting value is FALSE, works like a normal constant combinator
        control.enabled = not control.enabled
      end
    end
  end
end

local function onBuilt(event)
  local switchbutton = event.created_entity
  if switchbutton.name == "switchbutton" then
    local control = switchbutton.get_or_create_control_behavior()
    control.enabled=false
  end
end

local function onPaste(event)
  local switchbutton = event.destination
  if switchbutton.name == "switchbutton" then
    local control = switchbutton.get_or_create_control_behavior()
    control.enabled=false
  end
end
--# When any gui is closed, this reset the value of keybindused to allow switchbutton mod work in reversemode
script.on_event(defines.events.on_gui_closed, function(event)
keybindused = 0
end)

script.on_event(defines.events.on_gui_opened, function(event)
  local RIE = settings.startup["ReverseOpenInventory"].value
  local player = game.players[event.player_index]
  local entity = player.selected
--# If the entity.name is one switchbutton entity and control keybindused is 0, get the info of the entity gui is open
  if entity ~= nil and entity.name == "switchbutton" and keybindused == 0 then
    local control = entity.get_or_create_control_behavior()
--# If the value stored in settings mod is TRUE, this will change the state of switchbutton and *trick* force the entity gui dont open
    if RIE == true then
      control.enabled = not control.enabled
      player.opened = nil
    end
  end
end)

script.on_event("switchbutton-keybind", onKey)
script.on_event(defines.events.on_built_entity, onBuilt)
script.on_event(defines.events.on_robot_built_entity, onBuilt)
script.on_event(defines.events.on_entity_settings_pasted,onPaste)
