extends Area2D

# export(bool) var show_hit = true

const HitEffectScene = preload ("res://Effects/HitEffect.tscn")
onready var timer = $Timer

var invincible = false setget set_invincible

signal invincibility_started
signal invincibility_ended


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_hit_effect():
	var hitEffect = HitEffectScene.instance()
	hitEffect.global_position = global_position
	var rootScene = get_tree().current_scene
	rootScene.add_child(hitEffect)


func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")
		

#func _on_Hurtbox_area_entered(area):
#	if show_hit:
#		var hitEffect = HitEffectScene.instance()
#		hitEffect.global_position = global_position
#		var rootScene = get_tree().current_scene
#		rootScene.add_child(hitEffect)

func start_invincibility(duration):
	self.invincible = true
	timer.start(duration)

func _on_Timer_timeout():
	self.invincible = false # the self needed here for triggering the setget


func _on_Hurtbox_invincibility_ended():
	set_deferred("monitorable",true)


func _on_Hurtbox_invincibility_started():
	set_deferred("monitorable",false)
