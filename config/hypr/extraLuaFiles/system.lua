local submap_name = "system"
local trigger = "@mainMod@ + S"

hl.bind(trigger, hl.dsp.submap(submap_name))

hl.define_submap(submap_name, function()
	for i = 0, 9 do
		local value = (i + 1) * 10
		local dispatch_screen = hl.dsp.exec_cmd("@lightctl@ set " .. value)
		local dispatch_volume = hl.dsp.exec_cmd("@volumectl@ set " .. value)

		-- number row
		hl.bind("code:" .. (i + 10), dispatch_screen)
		hl.bind("@mainMod@ + code:" .. (i + 10), dispatch_screen)

		-- row below number row
		hl.bind("code:" .. (i + 24), dispatch_volume)
		hl.bind("@mainMod@ + code:" .. (i + 24), dispatch_volume)
	end

	hl.bind(trigger, hl.dsp.submap("reset"))
	hl.bind("escape", hl.dsp.submap("reset"))
end)
