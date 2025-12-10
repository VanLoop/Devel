extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ScoreManager.connect("win", Callable(self, "_on_win"))

func _on_win():
	get_tree().paused = true
	$ui/win_label.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
