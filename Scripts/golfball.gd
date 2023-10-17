extends RigidBody3D


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
	if Input.is_action_just_pressed("left_mouse"):
		print("Shoot!")
		impulse = -springArm.transform.basis.y
		impulse.y = 0
		impulse = impulse.normalized()
		impulse*= tmpStrength

func _integrate_forces(state):
	if impulse:
		apply_impulse(impulse)
		impulse = Vector3(0,0,0)
	if
	
	lastLinearVelocity = linear_velocity
	
	
		#if abs(linear_velocity) < MIN_VELOCITY && abs(linear_velocity) < abs(lastLinearVelocity):
		#	print("its ok you can shoot now")
		#	linear_velocity = lerp(linear_velocity,Vector3(0,0,0),LERP_WEIGHT)
		#	if linear_velocity < MIN_VELOCITY/2:
		#		allowedToMove = true
	
	#Stop the rotation, does not affect simulation, fixes camera
	#rotation.x = 0
	#rotation.z = 0
	#rotation.y = 0

func isOnTheGround():
	if onGroundRaycast.get_collider() is StaticBody3D:
		return true
	return false
