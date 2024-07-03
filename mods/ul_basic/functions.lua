function ul_basic.node_sound_defaults(tbl)
	tbl = tbl or {}
	tbl.footstep = tbl.footstep or
			{name = "ul_basic_footstep", gain = 0.2}
	tbl.dug = tbl.dug or
			{name = "ul_basic_dug_node", gain = 0.25}
	tbl.place = tbl.place or
			{name = "ul_basic_place_node", gain = 1.0}
	return tbl
end