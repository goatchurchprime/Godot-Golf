extends RigidBody3D

const MIN_VELOCITY = 0.5
const LERP_WEIGHT = 0.9
const TIMER_END = 250

var timer = 0
var moveTimer : bool

var moveAllowed : bool

var tmpStrength = -0.4
var impulse : Vector3
var lastLinearVelocity : Vector3

@onready var springArm = $"../FollowNode/SpringArm3D"
@onready var onGroundRaycast = $"../OnGroundRaycast"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("left_mouse") and moveAllowed:
		print("Shoot!")
		impulse = -springArm.transform.basis.y
		impulse.y = 0
		impulse = impulse.normalized()
		impulse*= tmpStrength

func _integrate_forces(state):
	if impulse:
		apply_impulse(impulse)
		impulse = Vector3(0,0,0)
	
	if moveTimer:
		timer+=1
		if timer == TIMER_END:
			linear_velocity = Vector3(0,0,0)
			moveAllowed = true
			resetTimer()
	
	if abs(linear_velocity.length()) > MIN_VELOCITY:
		moveAllowed = false
		resetTimer()
	else:
		moveTimer = true
	
	lastLinearVelocity = linear_velocity

func resetTimer():
	moveTimer = false
	timer = 0

func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false
