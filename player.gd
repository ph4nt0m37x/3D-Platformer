extends CharacterBody3D

@export var speed = 5.0
@export var acceleration = 4.0
@export var jump_speed = 20.0
@export var rotation_speed = 12.0
@export var mouse_sensitivity = 0.005


#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = 30.0
var jumping = false

var rescued := 0
const TOTAL_ROBOTS := 10

@onready var timer = $Timer
@onready var timer_label = $TimerLabel
var time_left := 30

@onready var saved_label = $SavedLabel

@onready var spring_arm = $SpringArm3D
@onready var model = $player
@onready var animation_tree = $player/AnimationTree
@onready var animation_state = $player/AnimationTree.get("parameters/playback")
@onready var game_over = $"../GameOverScreen"
@onready var game_won = $"../GameWon"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	timer_label.text = "%d s left  " % time_left
	saved_label.text = "  %d/10 rescued" % rescued
	timer.start()
	game_over.hide()
	game_won.hide()
	

func _physics_process(delta):
	if not is_on_floor():
		velocity.y = -gravity * delta * 0.5
	else:
		velocity.y = -gravity *delta * 2.0 
	
	#velocity.y = -gravity * delta
	
	get_movement_input(delta)

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_speed
		animation_tree.set("parameters/StateMachine/current", "jump")
		
	move_and_slide()
	
	if velocity.length() > 1.0:
		model.rotation.y = lerp_angle(model.rotation.y, spring_arm.rotation.y, rotation_speed * delta)
	
func get_movement_input(delta):
	var v = velocity.y
	velocity.y = 0
	var input = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity = lerp(velocity, direction * speed, acceleration * delta)
	var vl = velocity * model.transform.basis
	animation_tree.set("parameters/IW/blend_position", Vector2(vl.x, -vl.z) / speed)
	velocity.y = v
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sensitivity
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -40, 60.0)
		spring_arm.rotation.y -= event.relative.x * mouse_sensitivity
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func collect_robots():
	rescued += 1
	saved_label.text = "  %d/10 rescued" % rescued
	if (rescued == TOTAL_ROBOTS):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
		get_tree().change_scene_to_file("res://game_won.tscn")
		


func _on_timer_timeout() -> void:
	time_left -= 1
	timer_label.text = "%d s left  " % time_left
	
	if time_left <= 0:
		if rescued < TOTAL_ROBOTS:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to_file("res://game_over_screen.tscn")
