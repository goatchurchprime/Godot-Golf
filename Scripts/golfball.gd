extends RigidBody3D

#Related to hitting
const MIN_STRENGTH = 0.1
const MAX_STRENGTH = -10
const STRENGTH = 0.1
const HIT_SENSITIVITY = 3

#Calculating when moves are allowed
const MIN_VELOCITY = 0.5
const LERP_WEIGHT = 0.9
const TIMER_END = 250

var timer : int
var moveTimer : bool

var moveAllowed : bool
var aiming : bool

var impulse : Vector3
var mouseMove : float

@onready var springArm = $"../FollowNode/SpringArm3D"
@onready var onGroundRaycast = $"../OnGroundRaycast"

# Called when the node enters the scene tree for the first time.
func _ready():
	timer = 0
	mouseMove = MIN_STRENGTH

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _input(event):
	if moveAllowed:
		if Input.is_action_just_pressed("left_mouse"):
			aiming = true
			print("click")
		elif Input.is_action_just_released("left_mouse"):
			print(mouseMove)
			aiming = false
			impulse = -springArm.transform.basis.y
			impulse.y = 0
			impulse = impulse.normalized()
			impulse*= -abs(mouseMove*STRENGTH)
			mouseMove = MIN_STRENGTH
		elif event is InputEventMouseMotion and aiming:
			mouseMove += deg_to_rad(-event.relative.y)*HIT_SENSITIVITY
			mouseMove = clamp(mouseMove,MAX_STRENGTH,MIN_STRENGTH)


func _integrate_forces(state):
	if impulse:
		apply_impulse(impulse)
		impulse = Vector3.ZERO
	
	if moveTimer:
		timer+=1
		if timer == TIMER_END:
			linear_velocity = Vector3.ZERO
			moveAllowed = true
			resetTimer()
	
	if abs(linear_velocity.length()) > MIN_VELOCITY:
		moveAllowed = false
		resetTimer()
	else:
		moveTimer = true

func resetTimer():
	moveTimer = false
	timer = 0

func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false
