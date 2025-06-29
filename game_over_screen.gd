extends CanvasLayer

@onready var title = $PanelContainer/MarginContainer/Rows/Title


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func set_title(win:bool):
	if win:
		title.text = "You won!"
	else:
		title.text = "You lost."


func _on_restart_pressed() -> void:
	print("Restart pressed!")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
