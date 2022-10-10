extends Camera


func _process(_delta):
	var direction = Vector3.ZERO
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.z += 1
	if Input.is_action_pressed("move_up"):
		direction.z -= 1
	
	global_transform.origin += direction
	look_at($"../SpheroBolt".global_transform.origin, Vector3.UP)
