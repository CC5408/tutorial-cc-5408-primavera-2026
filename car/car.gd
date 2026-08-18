class_name Car
extends VehicleBody3D


@export var steer_acceleration: float = 3.0
@export var steer_max: float = 0.5
@export var engine_power: float = 600.0
@export var brake_force: float = 300.0
@onready var interact_area_3d: Area3D = $InteractArea3D
@onready var passenger_marker: Marker3D = $PassengerMarker
@onready var camera_3d: Camera3D = $Camera3D

var enabled: bool = false:
	set = set_enabled

var player_inside: Player

var _riding: bool = false

func _ready() -> void:
	interact_area_3d.body_entered.connect(_on_interact_entered)
	interact_area_3d.body_exited.connect(_on_interact_exited)


func _physics_process(delta: float) -> void:
	if not enabled:
		return
	var steer_input: float  = Input.get_axis("move_left", "move_right")
	var force_input: float = Input.get_axis("move_down", "move_up")
	
	engine_force = force_input * engine_power
	brake = brake_force if is_zero_approx(force_input) else 0.0
	steering = move_toward(steering, -steer_input * steer_max, steer_acceleration * delta)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_inside:
		_riding = true
		player_inside.enabled = false
		enabled = true
		player_inside.get_parent().remove_child(player_inside)
		add_child(player_inside)
		player_inside.global_transform = passenger_marker.global_transform


func set_enabled(value: bool) -> void:
	enabled = value
	camera_3d.current = enabled

func _on_interact_entered(body: Node3D) -> void:
	var player: Player = body as Player
	if player:
		player_inside = player


func _on_interact_exited(body: Node3D) -> void:
	if _riding:
		return
	var player: Player = body as Player
	if player:
		player_inside = null
