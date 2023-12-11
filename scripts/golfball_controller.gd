class_name Golfball extends Node3D

signal putted

const MIN_STRENGTH = 0
const MAX_STRENGTH = -12
const STRENGTH = 0.1
const HIT_SENSITIVITY = 3
const MIN_VELOCITY = 0.5

var putts
var last_pos : Vector3
var move_allowed : bool
var aiming : bool
var hit_strength : float
var impulse : Vector3

@onready var rigidbody = $Golfball
@onready var move_allowed_timer = $MoveAllowedTimer

@onready var camera = $CameraPosition/SpringArm3D/Camera3D
@onready var spring_arm = $CameraPosition/SpringArm3D

@onready var particle_emitter = $CameraPosition/PuttingGPUParticle
@onready var putt_audio_player = $CameraPosition/PuttingAudioPlayer

func _enter_tree():
	print("created")
	set_multiplayer_authority(str(name).to_int())

func _ready():
	rigidbody.freeze = true
	if is_multiplayer_authority():
		last_pos = Vector3.ZERO
		putts = 0
		camera.current = true
		hit_strength = MIN_STRENGTH

func _input(event):
	if is_multiplayer_authority():
		if move_allowed:
			if Input.is_action_just_pressed("left_mouse"):
				aiming = true
			elif Input.is_action_just_released("left_mouse"):
				putt()
			elif event is InputEventMouseMotion and aiming:
				add_hit_strength(event)

func _physics_process(delta):
	if is_multiplayer_authority():
		if impulse:
			rigidbody.apply_impulse(impulse)
			impulse = Vector3.ZERO
		
		if abs(rigidbody.linear_velocity.length()) > MIN_VELOCITY:
			move_allowed = false
			move_allowed_timer.stop()
		else:
			if move_allowed_timer.is_stopped():
				move_allowed_timer.start()

func add_hit_strength(event):
	hit_strength += deg_to_rad(-event.relative.y)*HIT_SENSITIVITY
	hit_strength = clamp(hit_strength,MAX_STRENGTH,MIN_STRENGTH)

func putt():
	last_pos = rigidbody.position
	if abs(hit_strength) > 0:
		print("hit_strength: " + str(hit_strength))
		impulse = spring_arm.get_rotation_basis()
		impulse.y = 0
		impulse = impulse.normalized()
		impulse*= -abs(hit_strength*STRENGTH)
		emit_particles()
		play_putt_sound()
		hit_strength = MIN_STRENGTH
		putts += 1
		emit_signal("putted")
	else:
		print("Hit cancelled!")
	aiming = false

func emit_particles():
	particle_emitter.rotation.x = spring_arm.get_rotation_basis().x
	particle_emitter.restart()

func play_putt_sound():
	putt_audio_player.volume_db = clamp(MAX_STRENGTH*4 - hit_strength*10, -30, 0)
	putt_audio_player.play()

func _on_move_allowed_timer_timeout():
	if is_multiplayer_authority():
		rigidbody.linear_velocity = Vector3.ZERO
		move_allowed = true

func move_back():
	rigidbody.linear_velocity = Vector3.ZERO
	rigidbody.angular_velocity = Vector3.ZERO
	rigidbody.position = last_pos

func disable():
	rigidbody.freeze = true
	_ready()
	move_back()
	rigidbody.visible = false

func enable():
	rigidbody.freeze = false
	rigidbody.visible = true
	activate_camera()

func activate_camera():
	camera.make_current()
