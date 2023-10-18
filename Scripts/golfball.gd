extends RigidBody3D

#Related to hitting
const MIN_STRENGTH = 0
const MAX_STRENGTH = -10
const STRENGTH = 0.1
const HIT_SENSITIVITY = 3

#Calculating when moves are allowed
const MIN_VELOCITY = 0.5
const LERP_WEIGHT = 0.9
const TIMER_END = 250

var timer : int
var move_timer : bool

var move_allowed : bool

var impulse : Vector3

@onready var head = $".."
@onready var onGroundRaycast = $"../OnGroundRaycast"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0
	head.hit_strength = MIN_STRENGTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _input(event):
	if move_allowed:
		if Input.is_action_just_pressed("left_mouse"):
			head.aiming = true
		elif Input.is_action_just_released("left_mouse"):
			#Gives possibility to cancel hit
			if abs(head.hit_strength) > 0:
				print("hit_strength: " + str(head.hit_strength))
				impulse = head.spring_arm_rotation
				impulse.y = 0
				impulse = impulse.normalized()
				impulse*= -abs(head.hit_strength*STRENGTH)
				print(head.hit_strength)
				head.hit_strength = MIN_STRENGTH
			else:
				print("Hit cancelled!")
			head.aiming = false
		elif event is InputEventMouseMotion and head.aiming:
			head.hit_strength += deg_to_rad(-event.relative.y)*HIT_SENSITIVITY
			head.hit_strength = clamp(head.hit_strength,MAX_STRENGTH,MIN_STRENGTH)


func _integrate_forces(state):
	if impulse:
		apply_impulse(impulse)
		impulse = Vector3.ZERO
	
	if move_timer:
		timer+=1
		if timer == TIMER_END:
			linear_velocity = Vector3.ZERO
			move_allowed = true
			resetTimer()
	
	if abs(linear_velocity.length()) > MIN_VELOCITY:
		move_allowed = false
		resetTimer()
	else:
		move_timer = true
	
	head.ball_position = position

func resetTimer():
	move_timer = false
	timer = 0

func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false
