local submap_name = "wayscribe"
local trigger = "@mainMod@ + A"

hl.bind(trigger, hl.dsp.submap(submap_name))

hl.define_submap(submap_name, function()
	hl.bind("@mainMod@ + D", hl.dsp.exec_cmd("@wayscriber@ --daemon-toggle"))
	hl.bind("@mainMod@ + SHIFT + D", hl.dsp.exec_cmd("@wayscriber@ --daemon-toggle --freeze"))
	hl.bind("@mainMod@ + S", hl.dsp.exec_cmd("@wayscriber@ --light-toggle"))
	hl.bind("@mainMod@ + X", hl.dsp.exec_cmd("@wayscriber@ --light-draw-toggle"))
	hl.bind("@mainMod@ + F", hl.dsp.exec_cmd("@wayscriber@ --light-draw-on"))
	hl.bind("@mainMod@ + F", hl.dsp.exec_cmd("@wayscriber@ --light-draw-off"), { release = true })

	hl.bind(trigger, hl.dsp.submap("reset"))
	hl.bind("escape", hl.dsp.submap("reset"))
end)
