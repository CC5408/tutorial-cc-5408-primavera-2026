extends Control
@onready var start: Button = %Start
@onready var settings: Button = %Settings
@onready var credits: Button = %Credits
@onready var quit: Button = %Quit


const CLICK = preload("uid://6dxaqlup8h3c")



func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	credits.pressed.connect(_on_credits_pressed)
	quit.pressed.connect(func() -> void: get_tree().quit())


func _on_start_pressed() -> void:
	LevelManager.start_game()
	AudioManager.play_sfx(CLICK)

func _on_credits_pressed() -> void:
	LevelManager.go_to_credits()
	AudioManager.play_sfx(CLICK)
