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
onready var wanderController = $WanderController

# Called when the node enters the scene tree for the first time.
func _ready():
	#print(stats.max_health)
	#print(stats.health)
	state = pick_random_state([IDLE, WANDER])


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
			if wanderController.get_time_left() == 0:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1, 3))
				change_state()
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1, 3))
				change_state()
			#var direction = global_position.direction_to(wanderController.target_position)
			#velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
			#sprite.flip_h = velocity.x < 0
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				#state = pick_random_state([IDLE, WANDER])
				#wanderController.start_wander_timer(rand_range(1,3))
				change_state()
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				#var direction = (player.global_position - global_position).normalized()
				#var direction = global_position.direction_to(player.global_position)
				#velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
				#sprite.flip_h = velocity.x < 0
				accelerate_towards_point(player.global_position, delta)
			else:
				state = IDLE
	
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * ACCELERATION			
	velocity = move_and_slide(velocity)

func accelerate_towards_point(point, delta):
	var direction = global_position.direction_to(point)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func change_state():
	state = pick_random_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func pick_random_state(state_list): # state_list should be an array
	state_list.shuffle() # randomizes the array
	return state_list.pop_front() # return the first state

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
