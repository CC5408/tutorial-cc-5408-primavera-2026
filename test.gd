extends Node3D

@onready var button: DoorButton = $DoorButton
@onready var door: Door = $Door
@onready var floor: StaticBody3D = $Floor
@onready var mesh_instance_3d: MeshInstance3D = $Floor/MeshInstance3D

var opened: bool = false

func _ready() -> void:
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if opened:
		door.close()
	else:
		door.open()
	opened = not opened
	mesh_instance_3d.material_override.albedo_color = Color(randf(), randf(), randf(), 1.0)
