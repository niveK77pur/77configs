local submap_name = "layout"

hl.bind("@mainMod@ + W", hl.dsp.submap(submap_name))

hl.define_submap(submap_name, "reset", function()
	-- dwindle
	hl.bind("@mainMod@ + D", hl.dsp.layout("togglesplit"))
	hl.bind("@mainMod@ + S", hl.dsp.layout("swapsplit"))

	-- grouped/tabbed windows
	hl.bind("@mainMod@ + G", hl.dsp.group.toggle())
	hl.bind("@mainMod@ + L", hl.dsp.group.lock_active())

	-- swallow windows
	hl.bind("@mainMod@ + X", hl.dsp.window.toggle_swallow())
end)
