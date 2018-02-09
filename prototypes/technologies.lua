--[[data:extend({
  {
      type = "technology",
      name = "switchbutton",
      icon = "__Switch_Button__/graphics/Switch_ButtonICO.png",
      icon_size = 40,
      effects = {{
            type = "unlock-recipe",
            recipe = "switchbutton"
        }},


  }
})
]]
local tech = data.raw.technology["circuit-network"].effects
local newUnlock = {
  type = "unlock-recipe",
  recipe = "switchbutton"
}
table.insert(tech, newUnlock)