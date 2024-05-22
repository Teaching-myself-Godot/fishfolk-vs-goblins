class_name BuilderGem
extends BasicDrop

signal collect_builder_gem()

func _collect():
	collect_builder_gem.emit()
