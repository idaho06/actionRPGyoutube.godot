extends Area2D

func is_colliding():
	return get_overlapping_areas().size() > 0
	
func get_push_vector():
	var push_vector = Vector2.ZERO
	if is_colliding():
		push_vector = get_overlapping_areas()[0].global_position.direction_to(global_position).normalized()
	return push_vector
	
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
