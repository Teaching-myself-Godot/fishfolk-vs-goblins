class_name MagicalCrystal
extends BasicDrop

signal collect_magical_crystal(player_cid : InputUtil.ControllerID)

func _collect(player_cid : InputUtil.ControllerID):
	collect_magical_crystal.emit(player_cid)
