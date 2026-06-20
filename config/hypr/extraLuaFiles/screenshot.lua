local submap_name = "screenshot"

hl.bind("@mainMod@ + X", hl.dsp.submap(submap_name))

hl.define_submap(submap_name, "reset", function()
	hl.bind("@mainMod@ + S", hl.dsp.exec_cmd("hyprshot --freeze -m region --clipboard-only"))
	hl.bind("@mainMod@ + W", hl.dsp.exec_cmd("hyprshot --freeze -m window --clipboard-only"))
	hl.bind("@mainMod@ + F", hl.dsp.exec_cmd("hyprshot --freeze -m output --clipboard-only"))
	hl.bind("@mainMod@ + R", hl.dsp.exec_cmd("hyprshot --freeze -m region --raw | @magick@ - -resize 400x - | wl-copy"))
	hl.bind(
		"@mainMod@ + E",
		hl.dsp.exec_cmd("hyprshot --freeze -m region --raw | @satty@ --filename -", { float = true })
	)
	hl.bind("@mainMod@ + T", hl.dsp.exec_cmd("@hyprshot-tesseract@"))
end)
