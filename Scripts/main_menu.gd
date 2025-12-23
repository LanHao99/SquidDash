extends Control

const LOADING_SCREEN = preload("res://Scenes/loading_screen.tscn")

func _on_load_game_pressed() -> void:
	var loading_screen = LOADING_SCREEN.instantiate()
	loading_screen.next_scene = "res://Scenes/main.tscn"
	add_child(loading_screen)
	pass
