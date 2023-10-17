extends RigidBody3D

const MIN_VELOCITY = Vector3(0.05,0.05,0.05)
const LERP_WEIGHT = 0.7

var shoot : bool
var allowedToMove : bool
var tmpStrength = -0.25

var impulse : Vector3

@onready var springArm = $SpringArm3D
@onready var onGroundRaycast = $OnGroundRaycast

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass # Replace with function body.

func _input(event):
	if Input.is_action_just_pressed("left_mouse") and allowedToMove:
		impulse = -springArm.transform.basis.y
		impulse.y = 0
		impulse = impulse.normalized()
		shoot = true

func _integrate_forces(state):
	if isOnTheGround() and !allowedToMove:
		if abs(linear_velocity) < MIN_VELOCITY:
			print("its ok you can shoot now")
			#linear_velocity = Vector3(0,0,0)
			#linear_velocity = lerp(linear_velocity,Vector3(0,0,0),LERP_WEIGHT)
			allowedToMove = true
	
	if shoot:
		apply_impulse(impulse * tmpStrength)
		shoot = false
		allowedToMove = false
	
	#Stop the rotation, does not affect simulation, fixes camera
	rotation.x = 0
	rotation.z = 0
	rotation.y = 0

func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false
