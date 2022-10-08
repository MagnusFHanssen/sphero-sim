extends Node

export (PackedScene) var flag_scene
export (PackedScene) var hull_scene

var collide = true

var current_vec = Vector3.ZERO
var last_vec = current_vec

var time = 0.0
var point_time = 0.0

var parser = SpheroParser.new()


func getPath(name: String) -> String:
	var path = ""
	if OS.has_feature("editor"):
		path = ProjectSettings.globalize_path("res://" + name)
	else:
		path = OS.get_executable_path().get_base_dir().plus_file(name)
	return path
	
func _ready():
	var name = $SpheroBolt.directory
	parser.open_file(getPath(name + "/Velocity.csv"))

func _process(delta):
	while (time + delta > point_time) and parser.is_open():
		parser.read_line()
		
		if collide:
			var flag = flag_scene.instance()
			flag.translate($SpheroBolt.point_pos)
			add_child(flag)
			collide = false
		
		last_vec = current_vec
		current_vec = parser.yield_vector()
		point_time = parser.yield_time()
		
		collide = current_vec.z - last_vec.z < -60.0

	time += delta


func _on_SpheroBolt_hull_formed():
	$DrawHull.begin(Mesh.PRIMITIVE_LINE_STRIP)
	$DrawHull.set_color(Color.darkgreen)
	for vec in $SpheroBolt.convex_hull:
		var flag = hull_scene.instance()
		flag.translate(vec)
		add_child(flag)
		$DrawHull.add_vertex(Vector3(vec.x, vec.y + 1.0, vec.z))
	$DrawHull.end()
	print("Hull drawn")
	print($SpheroBolt.convex_hull.size())
