extends HBoxContainer

@onready var tile_splicer : PackedScene = preload("res://wfc editor/scenes/sprite_splitter.tscn")
func _on_delete_button_pressed() -> void:
	queue_free()

func _on_menu_button_pressed() -> void:
	pass # Replace with function body.

func _on_tile_sprite_pressed() -> void:
	var new_splicer = tile_splicer.instantiate()
	get_tree().root.get_child(0).add_child(new_splicer)
