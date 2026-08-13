extends CanvasLayer


@onready var resume: Button = %Resume
@onready var retry: Button = %Retry
@onready var main_menu: Button = %MainMenu


func _ready() -> void:
	hide()
	resume.pressed.connect(_on_resume)
	retry.pressed.connect(_on_retry)
	main_menu.pressed.connect(_on_main_menu)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		get_tree().paused = not get_tree().paused
		visible = get_tree().paused
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if get_tree().paused else Input.MOUSE_MODE_CAPTURED

func _on_resume() -> void:
	get_tree().paused = false
	hide()

func _on_retry() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")
