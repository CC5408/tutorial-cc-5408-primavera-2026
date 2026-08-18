class_name Player
extends CharacterBody3D

@export var move_speed: float = 5
@export var jump_speed: float = 7
@export var acceleration: float = 20

@export_range(0.01, 0.1) var mouse_sensitivity: float = 0.01
@export var camera_pitch_min: float = -40
@export var camera_pitch_max: float = 20

@export var bullet_scene: PackedScene

var enabled: bool = true:
	set = set_enabled

@onready var camera_3d: Camera3D = $SpringArm3D/Camera3D
@onready var spring_arm_3d: SpringArm3D = $SpringArm3D
@onready var model: Node3D = $Model
@onready var animation_player: AnimationPlayer = $Model/cat/AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var health_bar: ProgressBar = $CanvasLayer/MarginContainer/HealthBar
@onready var jump_player: AudioStreamPlayer3D = $JumpPlayer
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@onready var bullet_spawn_marker: Marker3D = $GunMarker/MeshInstance3D/BulletSpawnMarker
@onready var gun_marker: Marker3D = $GunMarker


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	health_bar.value = health_component.health
	health_bar.max_value = health_component.max_health
	health_component.health_changed.connect(func(value: float) -> void: health_bar.value = value)
	health_component.died.connect(_on_died)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("fire"):
		_fire()
	if event.is_action_pressed("flick"):
		animation_player.play("cat_animations/flick")

func _unhandled_input(event: InputEvent) -> void:
	var mouse_motion: InputEventMouseMotion = event as InputEventMouseMotion
	if mouse_motion:
		spring_arm_3d.rotation.y -= mouse_motion.relative.x * mouse_sensitivity
		var camera_pitch: float = camera_3d.rotation.x - mouse_motion.relative.y * mouse_sensitivity
		camera_3d.rotation.x = clamp(
			camera_pitch,
			deg_to_rad(camera_pitch_min),
			deg_to_rad(camera_pitch_max))


func _process(_delta: float) -> void:
	gun_marker.rotation.y = spring_arm_3d.rotation.y


func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
		jump_player.play()
		Debug.log("jump")
	
	var move_input: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	#var direction: Vector3 = transform.basis * Vector3(move_input.x, 0, move_input.y)
	#var target: Vector2 = Vector2(direction.x, direction.z) * move_speed

	var direction: Vector2 = move_input.rotated(-model.rotation.y)
	var target: Vector2 = direction * move_speed
	var current: Vector2 = Vector2(velocity.x, velocity.z)
	var result: Vector2 = current.move_toward(target, acceleration * delta)
	
	
	velocity.x = result.x
	velocity.z = result.y
	
	move_and_slide()
	
	model.rotation.y = lerp_angle(model.rotation.y, spring_arm_3d.rotation.y, 0.1)


func set_enabled(value: bool) -> void:
	enabled = value
	set_physics_process(enabled)
	set_process_unhandled_input(enabled)
	set_process_unhandled_key_input(enabled)
	camera_3d.current = enabled
	collision_shape_3d.set_deferred("disabled", true)
	model.transform = Transform3D.IDENTITY

func _on_died() -> void:
	queue_free()


func _fire() -> void:
	if not bullet_scene:
		return
	var bullet_inst: Node3D = bullet_scene.instantiate()
	get_parent().add_child(bullet_inst)
	bullet_inst.global_position = bullet_spawn_marker.global_position
	bullet_inst.global_rotation = bullet_spawn_marker.global_rotation
