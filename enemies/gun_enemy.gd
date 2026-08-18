extends CharacterBody3D


@onready var health_component: HealthComponent = $HealthComponent

func _ready() -> void:
	health_component.died.connect(queue_free)
