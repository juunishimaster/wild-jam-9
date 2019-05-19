extends KinematicBody2D

# Types of enemy 
const type = [4, 8, 12, 16, 18, 20, 21, 23]

# 3 state of enemy
# When enemy is not aware of player it moves randomly
# When player is inside a silgth range of enemy, enemy follows player.
# When it got player into attack range, enemy attacks it. 
enum {IDLE,WALK,FOLLOW,ATTACK,DEATH}
var state

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
var is_enemy_turn = false

# enemy slight range
var eye_range = 10*32;
var attack_range = 2*32;
 
# player node
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("enemies")
	
	player = get_tree().get_nodes_in_group('player')[0];
	
	state = WALK
	
	position = Vector2(int(position.x/32)*32 + 16, int(position.y/32)*32 + 16)
	last_pos = position
	target_pos = position
	
	randomize()
	$Sprite.frame = type[int(rand_range(0,type.size()))]

func  _physics_process(delta):
	# Raycast to 4 direction to see if there's an obstacle or not
	# if there's an obstacle, do not walk there
	var space_state = get_world_2d().direct_space_state
	
	
	
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
		if is_enemy_turn:
			emit_signal("end_enemy_turn")
			is_enemy_turn = false
		if(state == WALK and position.distance_to(player.position) < eye_range):
			state = FOLLOW
			print('Enemy is following')
		elif(state == FOLLOW and position.distance_to(player.position) < attack_range):
			state = ATTACK
			print('Enemy is attacking');
	else:
		var raycast = space_state.intersect_ray(position, target_pos)
		if raycast:
			print("There's obstacle, stop move")
			position = target_pos
			emit_signal("end_enemy_turn")
			is_enemy_turn = false
	pass

func move_me():
	if(state == WALK):
		move_dir = get_random_direction()
	if(state == FOLLOW):
		move_dir = follow(player.position);
	if(state == ATTACK):
		move_dir = follow(player.position);
		print('Enemy is ATTACKING')
		player.hurt()
	
	last_pos = position
	target_pos += move_dir* tile_size
	

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