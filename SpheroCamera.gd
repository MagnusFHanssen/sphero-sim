extends Camera

func _process(_delta):
	look_at($"../SpheroBolt".global_transform.origin, Vector3.UP)
