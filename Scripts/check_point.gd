extends Area2D
@onready var CheckPointAnimation = $CheckPointAnimation

signal checkpoint_activated
var is_activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"Player") and not is_activated:
		CheckPointAnimation.play("start")
		checkpoint_activated.emit()
		is_activated = true

func _on_checkpoint_activated() -> void:
	if CheckPointAnimation.is_playing():
		await CheckPointAnimation.animation_finished
		CheckPointAnimation.play("activated")
