extends KinematicBody2D

export var FRICTION = 200
export var ACCELERATION = 300
export var MAX_SPEED = 50

const EnemyDeathEffectScene = preload("res://Effects/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}

var state = CHASE

var velocity = Vector2.ZERO
var knockback = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(stats.max_health)
	#print(stats.health)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _physics_process(delta):
	knockback = knockback.move_toward(
		Vector2.ZERO, 
		FRICTION * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
			seek_player()
		WANDER:
			pass
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				#var direction = (player.global_position - global_position).normalized()
				var direction = global_position.direction_to(player.global_position)
				velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * ACCELERATION			
	velocity = move_and_slide(velocity)

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage # this calls stats.set_health(value)
	#print(stats.health)
	knockback = area.knockback_vector * 120
	hurtbox.create_hit_effect()

func create_death_effect():
	var deathEffect = EnemyDeathEffectScene.instance()
	deathEffect.global_position = global_position
	#var world = get_tree().current_scene
	#world.add_child(deathEffect)
	get_parent().add_child(deathEffect)

func _on_Stats_no_health():
	create_death_effect()
	queue_free()
