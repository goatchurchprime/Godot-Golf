class_name Golfball extends RigidBody3D

# Sync puts with UI
signal putted

# Related to hitting
const MIN_STRENGTH = 0
const MAX_STRENGTH = -12
const STRENGTH = 0.1
const HIT_SENSITIVITY = 3

const MIN_VELOCITY = 0.5

const LERP_WEIGHT = 0.9

var move_allowed : bool
var aiming : bool
var hit_strength : float
var impulse : Vector3

@onready var move_allowed_timer = $"../MoveAllowedTimer"
@onready var spring_arm = $"../FollowNode/SpringArm3D"
@onready var onGroundRaycast = $"../OnGroundRaycast"
@onready var particle_emitter = $"../FollowNode/PuttingGPUParticle"


func _ready():
	hit_strength = MIN_STRENGTH


func _input(event):
	if move_allowed:
		if Input.is_action_just_pressed("left_mouse"):
			aiming = true
		elif Input.is_action_just_released("left_mouse"):
			putt()
		elif event is InputEventMouseMotion and aiming:
			add_hit_strength(event)


func _integrate_forces(state):
	if impulse:
		apply_impulse(impulse)
		impulse = Vector3.ZERO
	
	if abs(linear_velocity.length()) > MIN_VELOCITY:
		move_allowed = false
		move_allowed_timer.stop()
	else:
		if move_allowed_timer.is_stopped():
			move_allowed_timer.start()


func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false


func add_hit_strength(event):
	hit_strength += deg_to_rad(-event.relative.y)*HIT_SENSITIVITY
	hit_strength = clamp(hit_strength,MAX_STRENGTH,MIN_STRENGTH)


func putt():
	if abs(hit_strength) > 0:
		print("hit_strength: " + str(hit_strength))
		impulse = spring_arm.get_rotation_basis()
		impulse.y = 0
		impulse = impulse.normalized()
		impulse*= -abs(hit_strength*STRENGTH)
		hit_strength = MIN_STRENGTH
		emit_particles()
		emit_signal("putted")
	else:
		print("Hit cancelled!")
	aiming = false


func emit_particles():
	particle_emitter.rotation.x = spring_arm.get_rotation_basis().x
	particle_emitter.restart()


func _on_move_allowed_timer_timeout():
	linear_velocity = Vector3.ZERO
	move_allowed = true
