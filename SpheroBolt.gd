extends KinematicBody


# Declare member variables here. Examples:
export var max_speed  = 50

var velocity = Vector3.ZERO
var p_velocity = velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Add code to bind input file somehow
	
func _physics_process(delta):
	var direction = Vector3.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.z = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	p_velocity = velocity
	
	velocity.x = direction.x * max_speed
	velocity.z = direction.z * max_speed
	
	$Pivot.rotate_x(2 * velocity.z/360)
	$Pivot.rotate_z(- 2 * velocity.x/360)
	
	velocity = move_and_slide(velocity, Vector3.UP)
	
