extends Node2D

const GrassEffectScene = preload("res://Effects/GrassEffect.tscn")

func _ready():
	pass # Replace with function body.

func create_grass_effect():
	#var GrassEffectScene = load("res://Effects/GrassEffect.tscn") # preloaded!
	var grassEffect = GrassEffectScene.instance()
	grassEffect.global_position = global_position
	#var world = get_tree().current_scene
	#world.add_child(grassEffect)
	get_parent().add_child(grassEffect)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	if Input.is_action_just_pressed("attack"):
#		var GrassEffectScene = load("res://Effects/GrassEffect.tscn")
#		var grassEffect = GrassEffectScene.instance()
#		grassEffect.global_position = global_position
#		var world = get_tree().current_scene
#		world.add_child(grassEffect)
#		queue_free()
	pass


#func _on_Hitbox_area_entered(area):
#	queue_free()


func _on_Hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
