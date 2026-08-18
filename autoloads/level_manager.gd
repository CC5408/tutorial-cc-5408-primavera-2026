extends Node


@export var levels: Array[PackedScene]
@export var main_menu: PackedScene
@export var credits: PackedScene

var current_level: int = 0


func start_game() -> void:
	if levels.is_empty():
		return
	get_tree().change_scene_to_packed(levels[0])


func next_level() -> void:
	current_level += 1
	if current_level < levels.size():
		get_tree().change_scene_to_packed(levels[current_level])
	else:
		Debug.log("TODO tp to credits here")


func go_to_main_menu() -> void:
	if not main_menu:
		return
	get_tree().change_scene_to_packed(main_menu)


func go_to_credits() -> void:
	if not credits:
		return
	get_tree().change_scene_to_packed(credits)
