extends KinematicBody

signal hull_formed

export var directory = "many_walls"

var velocity = Vector3.ZERO
var p_velocity = velocity

var loc_parser = SpheroParser.new()

var curr_time = 0.0
var point_time = 0.0
export var point_pos = Vector3.ZERO

var loop = true

var scanner = GrahamScanner.new()
var show_convex = true

export var convex_hull = []

func getPath(name: String) -> String:
	var path = ""
	if OS.has_feature("editor"):
		path = ProjectSettings.globalize_path("res://" + name)
	else:
		path = OS.get_executable_path().get_base_dir().plus_file(name)
	return path

# Called when the node enters the scene tree for the first time.
func _ready():
	loc_parser.open_file(getPath(directory + "/Location.csv"))
	
func _physics_process(delta):
	loop = loc_parser.is_open()
	while (curr_time + delta > point_time) and loop:
		loc_parser.read_line()
		point_time = loc_parser.yield_time()
		point_pos = loc_parser.yield_vector()/5
		point_pos.z = point_pos.y
		point_pos.y = 0;
		scanner.insert_point(point_pos.x, point_pos.z)
		loop = loc_parser.is_open()
		
	if loop:
		velocity = (point_pos - global_transform.origin)/(point_time - curr_time)
		
		velocity.y = 0.0
		curr_time += delta
		
		$Pivot.rotate_x(2 * velocity.z/360)
		$Pivot.rotate_z(- 2 * velocity.x/360)
		
		
		velocity = move_and_slide(velocity, Vector3.UP)
	else:
		if show_convex:
			convex_hull = scanner.calculate_hull()
			emit_signal("hull_formed")
			show_convex = false
