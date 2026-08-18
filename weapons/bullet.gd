extends HitboxComponent


@export var move_speed: float = 10

func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _physics_process(delta: float) -> void:
	var direction: Vector3 = -basis.z
	var velocity: Vector3 = direction * move_speed
	position += velocity * delta


func _on_body_entered(_body: Node3D) -> void:
	queue_free()
