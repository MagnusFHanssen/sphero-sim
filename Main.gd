extends Node

var time = 0.0

var parser = SpheroParser.new()

var count = 0

func _ready():
	var path = ""
	if OS.has_feature("editor"):
		path = ProjectSettings.globalize_path("res://sensor_data/Accelerometer.csv")
	else:
		path = OS.get_executable_path().get_base_dir().plus_file("sensor_data/Accelerometer.csv")
	parser.open_file(path)

func _process(_delta):
	print("Read line: %s" % parser.read_line())
	count += 1
