extends RigidBody3D


@export var mouse_sensitivity = 0.003
@export var joystick_sensitivity = 0.025
@export var rolling_force = 50
@export var jump_force = 20
@export_enum("small","big") var ball_size :int

@onready var camera: Node3D = $CameraRig

@onready var floor_cast: RayCast3D = $FloorCast
@onready var ball_mesh: MeshInstance3D = $MeshInstance3D
@onready var ball_collision: CollisionShape3D = $CollisionShape3D
@onready var ball_col_area: CollisionShape3D = $Area3D/CollisionShape3D

var move_direction: Vector3 = Vector3.ZERO

var coins
var lives

var roll_force
var jump_impulse

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	coins = 0
	lives = 3
	
func _physics_process(delta: float) -> void:
	scale_ball()
	camera_follow()
	player_movements(delta)
	camera_movements()

	
func player_movements(tick) -> void:
	var is_on_floor = floor_cast.is_colliding()
	move_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move_direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")
	move_direction = move_direction.rotated(Vector3.UP, camera.rotation.y).normalized()
	
	angular_velocity.x += move_direction.x * roll_force * tick
	angular_velocity.z += move_direction.z * roll_force * tick
	
	if Input.is_action_pressed("brake") and is_on_floor:
		angular_velocity = Vector3.ZERO
	if Input.is_action_just_pressed("jump") and is_on_floor:
		apply_central_impulse(Vector3.UP * jump_impulse)
		
	if Input.is_action_just_pressed("grow"):
		if ball_size ==0:
			ball_size = 1
	if Input.is_action_just_pressed("shrink"):
		if ball_size ==1:
			ball_size = 0
	
func camera_movements():
	if Input.is_action_pressed("camera_up"):
		camera.rotate(Vector3.BACK, Input.get_action_strength("camera_up")*joystick_sensitivity)
	if Input.is_action_pressed("camera_down"):
		camera.rotate(Vector3.FORWARD, Input.get_action_strength("camera_down")*joystick_sensitivity)
	if Input.is_action_pressed("camera_left"):
		camera.rotate(Vector3.UP, Input.get_action_strength("camera_left")*joystick_sensitivity)
	if Input.is_action_pressed("camera_right"):
		camera.rotate(Vector3.DOWN, Input.get_action_strength("camera_right")*joystick_sensitivity)
	if Input.is_action_pressed("camera_reset"):
		camera.rotation = lerp(camera.rotation, Vector3.ZERO, 0.2)
	camera.rotation.x = 0

func camera_follow():
	var old_cam_pos = camera.global_position
	var ball_pos = self.global_position
	var new_cam_pos = lerp(old_cam_pos, ball_pos, 0.2)
	camera.global_position = new_cam_pos
	floor_cast.global_position = self.global_position
	
func  scale_ball():
	if ball_size == 0:
		ball_mesh.scale = Vector3(1,1,1)
		ball_collision.scale = Vector3(1,1,1)
		floor_cast.scale = Vector3(1,1,1)
		ball_col_area.scale = Vector3(1,1,1)
		roll_force = rolling_force
		physics_material_override.bounce = 0.5
		jump_impulse = jump_force
	
	if ball_size == 1:
		ball_mesh.scale = Vector3(2,2,2)
		ball_collision.scale = Vector3(2,2,2)
		floor_cast.scale = Vector3(2,2,2)
		ball_col_area.scale = Vector3(2,2,2)
		roll_force = rolling_force/2
		physics_material_override.bounce = 0.8
		jump_impulse = jump_force*2
	
func _input(event) -> void:
	if event is InputEventMouseMotion:
#		print(event)
		camera.rotate_y(-event.relative.x * mouse_sensitivity)
		camera.rotate_z(-event.relative.y * mouse_sensitivity)
	camera.rotation.z = clamp(camera.rotation.z, -PI/3.5, PI/4.5)

