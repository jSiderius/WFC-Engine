extends VBoxContainer

var tile_menu_item_loader : Resource = preload("res://wfc editor/scenes/tile_menu_item.tscn")

func _on_add_button_pressed() -> void:
	var item = tile_menu_item_loader.instantiate()
	add_child(item)
