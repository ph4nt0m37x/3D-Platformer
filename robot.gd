extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#connect("body_entered", self, "_on_body_entered") # Replace with function body.
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func _on_body_entered(body: Node3D) -> void:
		body.call("collect_robots")
		call_deferred("queue_free")
