--[[
  "Keybindused" is only to control the script (on_gui_opened), so it only work when his value is 0,
  and prevent to close the gui when the keybin key is presed to open the entity gui
]]
local keybindused = 0

---------------------[BUILD ENTITY FUNCTION]---------------------
local function onBuilt(event)
  local switchbutton = event.created_entity
  if switchbutton.name == 'switchbutton' then
    local control = switchbutton.get_or_create_control_behavior()
    control.enabled=false

  end
end
-------------------[COPY/PASTE ENTITY FUNCTION]------------------
local function onPaste(event)
  local switchbutton = event.destination
  if switchbutton.name == 'switchbutton' then
    local control = switchbutton.get_or_create_control_behavior()
    control.enabled=false
  end
end
---------------------[CUSTOM INPUT FUNCTION]---------------------
local function onKey(event)
  local player = game.players[event.player_index]
  local entity = player.selected

  keybindused = 1
  if entity and entity.valid then
    if entity.name == 'switchbutton' then
      local distance = math.abs(player.position.x-entity.position.x)+math.abs(player.position.y-entity.position.y)
      if distance < 15 or player.character.can_reach_entity('switchbutton') then
        local control = entity.get_or_create_control_behavior()
        if settings.startup['ReverseOpenInventory'].value then
          player.opened = entity
          keybindused = 0
        elseif not settings.startup['ReverseOpenInventory'].value then
          control.enabled = not control.enabled
        end
      end
    end
  end
end
------------------------[OPEN ENTITY GUI]------------------------
script.on_event(defines.events.on_gui_opened, function(event)
  local player = game.players[event.player_index]
  local entity = player.selected
  if entity ~= nil and entity.name == 'switchbutton' and keybindused == 0 then
    local control = entity.get_or_create_control_behavior()
    if settings.startup['ReverseOpenInventory'].value then
      player.opened = nil
      control.enabled = not control.enabled
    end
  end
end)
---------------------------[SCRIPTS]---------------------------
script.on_event('switchbutton-keybind', onKey)
script.on_event(defines.events.on_built_entity, onBuilt)
script.on_event(defines.events.on_robot_built_entity, onBuilt)
script.on_event(defines.events.on_entity_settings_pasted,onPaste)
