extends Node3D

@export var scene: PackedScene
# spawns per second
@export var scene_radius: float = 2.0
@export var rate: float = 1
@export var radius: float = 5

@onready var timer: Timer = $Timer

func _ready() -> void:
	if rate == 0:
		return
	var spawn_time: float = 1 / rate
	timer.start(randf_range(spawn_time, spawn_time * 4))
	timer.timeout.connect(_spawn)


func _spawn() -> void:
	var spawn_time: float = 1 / rate
	timer.start(randf_range(spawn_time, spawn_time * 4))
	
	if not scene:
		return
		
	var spawn_position: Vector3 = global_position + \
	Vector3(randf_range(0, radius), 0, 0).rotated(Vector3.UP, randf() * TAU)
	
	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	
	var sphere_rid: RID = PhysicsServer3D.sphere_shape_create()
	PhysicsServer3D.shape_set_data(sphere_rid, scene_radius)
	
	var params: PhysicsShapeQueryParameters3D = PhysicsShapeQueryParameters3D.new()
	params.shape_rid = sphere_rid
	params.transform.origin = spawn_position
	params.collision_mask = 2 + 4
	
	var results: Array[Dictionary] = space_state.intersect_shape(params)
	
	PhysicsServer3D.free_rid(sphere_rid)
	
	if not results.is_empty():
		return

	var inst: Node3D = scene.instantiate()
	add_child(inst)
	inst.global_position = spawn_position
