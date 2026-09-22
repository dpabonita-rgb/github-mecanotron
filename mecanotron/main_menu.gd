extends Control

@export var game_scene_path : String = "res://level_one.tscn"

func _on_playbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://level_one.tscn")
