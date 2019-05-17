extends KinematicBody2D

# Types of enemy 
const type = [4, 8, 12, 16, 18, 20, 21, 23]

# 3 state of enemy
# When enemy is not aware of player it moves randomly
# When player is inside a silgth range of enemy, enemy follows player.
# When it got player into attack range, enemy attacks it. 

# Movement variables
var speed = 256
var tile_size = 32

var last_pos = Vector2()
var target_pos = Vector2()
var move_dir = Vector2()

# helth
onready var curr_health = 3
var max_health = 3

# Turn based things
signal end_enemy_turn

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(176, 176)
	last_pos = position
	target_pos = position
	randomize()
	$Sprite.frame = type[int(rand_range(0,type.size()))]
	pass # Replace with function body.

func  _physics_process(delta):
	# Movement
	
	var vel = move_and_slide(speed * move_dir)
	
	if(vel.length() == 0):
		if(position.distance_to(last_pos) > position.distance_to(target_pos)):
			position = target_pos
		else:
			position = last_pos
			target_pos = last_pos
	
	if position.distance_to(last_pos) >= tile_size:
		position = target_pos
	
	# Idle
	if position == target_pos:
		move_dir = get_random_direction()
		last_pos = position
		target_pos += move_dir* tile_size
	
	pass

func get_random_direction():
	# select axis to move
	if(randf() > 0.5):
		# move in X direction 
		return Vector2(int(rand_range(-2,2)),0)
	else:
		# move in y direction
		return Vector2(0,int(rand_range(-2,2)))

func follow(target):
	var direction = target - position
	direction = direction.normalized()
	
	# check which component of vector has more length
	if(abs(direction.x) > abs(direction.y)):
		direction = Vector2(sign(direction.x),0)
	else:
		direction = Vector2(0, sign(direction.y))
	
	return direction



# connect this function to player move signal
# so that player done action all enemy do action
func do_action():
	pass

func _attack():
	pass

func update_health(h):
	curr_health += h
	
	if curr_health == 0:
		print("Die")
		self.queue_free()
	elif curr_health > max_health:
		curr_health = max_health
	pass