class_name DoorButton
extends Node3D

signal pressed()


@onready var area_3d: Area3D = $Area3D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	area_3d.body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node3D) -> void:
	var rigid_body: RigidBody3D = body as RigidBody3D
	if rigid_body:
		animation_player.play("push")
		pressed.emit()
