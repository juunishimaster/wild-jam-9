extends KinematicBody2D

# State variables
enum {IDEL, WALK, ATTACK, DEAD}
var state = null

# Movement variables
var speed = 256
var tile_size = 32

var last_pos = Vector2()
var target_pos = Vector2()
var move_dir = Vector2()

# Action variables
var area_atk_distance = 1 # Change this accordingly; meaning: area_atk_distance * tile_size
var ranged_atk_distance = 3 # Meaning: ranged_atk_distance * tile_size

# health
signal health_changed
signal dead 
var max_health = 3
var curr_health = max_health

var lock_control = false

# Turn based things
signal end_player_turn
var is_player_turn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Movement preparation
	position = Vector2(int(position.x/32)*32 + 16, int(position.y/32)*32 + 16)
	last_pos = position
	target_pos = position
	
	state = IDEL
	
	emit_signal('health_changed', curr_health)
	
	# Action preparation
	curr_health = max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
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
		if !lock_control:
			get_movedir()
			last_pos = position
			target_pos += move_dir * tile_size
			
			get_action()
		else:
			if is_player_turn:
				emit_signal("end_player_turn")
				is_player_turn = false
		
	
	pass

# Get direction the player wants to move
func get_movedir():
	var LEFT = Input.is_action_just_pressed("ui_left")
	var RIGHT = Input.is_action_just_pressed("ui_right")
	var UP = Input.is_action_just_pressed("ui_up")
	var DOWN = Input.is_action_just_pressed("ui_down")
	
	move_dir.x = -int(LEFT) + int(RIGHT)
	move_dir.y = -int(UP) + int(DOWN)
	
	if move_dir.x != 0 && move_dir.y != 0:
		move_dir = Vector2.ZERO
	
	#Lock the keyboard after input
	if LEFT || RIGHT || UP || DOWN:
		toggle_control()

func get_action():
	var X = Input.is_action_just_pressed("ui_area_atk")
	var Z = Input.is_action_just_released("ui_ranged_atk")
	
	if X:
		action_attack()
	elif Z:
		action_ranged_attack()
	
	
	pass

func update_health(h):
	curr_health += h
	
	if curr_health == 0:
		self.queue_free()
		print("Game Over")
	elif curr_health > max_health:
		curr_health = max_health
	
	pass

func action_attack():
	# Assuming the attack goes AoE but close ranged
	var enemy_list = get_tree().get_nodes_in_group("enemies")
	for en in enemy_list:
		if en.global_position.distance_to(self.global_position) <= area_atk_distance * tile_size:
			print("Damage the enemy")
			en.update_health(-1)
			# damage function in the enemy nodes' script
	pass

func action_ranged_attack():
	var enemy_list = get_tree().get_nodes_in_group("enemies")
	for en in enemy_list:
		if en.global_position.distance_to(self.global_position) <= ranged_atk_distance * tile_size:
			print("Damage the enemy")
			en.update_health(-1)
			# damage function in the enemy nodes' script
	pass

func end_player_turn():
	pass

# This function is for toggling control
func toggle_control():
	lock_control = !lock_control
	pass

func hurt():
	curr_health -= 1
	emit_signal("health_changed",curr_health)
	if(curr_health == 0):
		emit_signal("dead")

func _on_Z_pressed():
	# do Z attack here
	pass # Replace with function body.


func _on_X_pressed():
	# do X attack here
	pass # Replace with function body.
