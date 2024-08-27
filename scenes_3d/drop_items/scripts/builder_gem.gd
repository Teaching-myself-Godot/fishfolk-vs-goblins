class_name BuilderGem
extends BasicDrop

signal collect_builder_gem(player_cid : InputUtil.ControllerID)

func _collect(player_cid : InputUtil.ControllerID):
	collect_builder_gem.emit(player_cid)
