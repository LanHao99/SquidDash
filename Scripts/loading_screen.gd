extends Control

var next_scene: String = "res://Scenes/main.tscn"
@onready var progress_bar = $ProgressBar

func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene)
	pass

func _process(delta: float) -> void:
	var progress = []
	var loaded_status = ResourceLoader.load_threaded_get_status(next_scene,progress)
	var new_progress = progress[0] * 100

	#插值
	progress_bar.value = lerp(progress_bar.value, new_progress, delta * 5)

	if loaded_status == ResourceLoader.THREAD_LOAD_LOADED:
		progress_bar.value = 100.0
		var packed_next_scene = ResourceLoader.load_threaded_get(next_scene)
		#负优化0.1s，后面场景大了可以删掉
		await get_tree().create_timer(0.1).timeout

		get_tree().change_scene_to_packed(packed_next_scene)
	pass