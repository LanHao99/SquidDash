extends Node2D
@onready var CheckPointController = $CheckPointController
@onready var DeathCountNumber = %DeathCountNumber
const PLAYER_SCENE = preload("res://Scenes/Player.tscn")
var player : Player
var check_points = []
var current_checkpoint = 0


func spawn_player() -> void:
	player = PLAYER_SCENE.instantiate()
	add_child(player)
	player.position = check_points[current_checkpoint].position + Vector2(0, -20)
	player.set_physics_process(false)
	player.PlayerSprite2D.play("spawn")
	await player.PlayerSprite2D.animation_finished
	player.set_physics_process(true)
	player.dead.connect(
		func() -> void:
			for i in range(len(check_points)):
				if check_points[len(check_points)-i-1].is_activated == true:
					current_checkpoint = max(current_checkpoint, len(check_points)-i-1)
					break
			GameManager.death_count += 1
			update_death_count()
			player.queue_free()
			spawn_player()
	)

func update_death_count() -> void:
	DeathCountNumber.text = str(GameManager.death_count)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	check_points = CheckPointController.get_children()
	spawn_player()


func _on_boundary_body_entered(body: Node2D) -> void:
	if body.is_in_group(&"Player"):
		if body.has_method("die"):
			body.die()
