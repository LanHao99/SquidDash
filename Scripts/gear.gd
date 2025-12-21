extends Area2D
@onready var GearAnimation = $GearAnimation

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"Player"):
		if body.has_method("die"):
			body.die()
