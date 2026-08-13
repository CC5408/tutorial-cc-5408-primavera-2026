extends Control
@onready var start: Button = %Start
@onready var settings: Button = %Settings
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(func() -> void: get_tree().quit())


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://test.tscn")
