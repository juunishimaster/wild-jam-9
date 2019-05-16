extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Movement variables
var speed = 256
var tile_size = 64

var last_pos = Vector2()
var target_pos = Vector2()
var move_dir = Vector2()

# Action variables
var action_array = ["idle", "idle"]
var input_counter = 0
var curr_action_idx = 0
var max_action_idx = 1 # Because player can only stack 2 actions on their turn

var min_atk_distance = 32 # Change this accordingly

var curr_health
var max_health = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	# Movement preparation
	position = position.snapped(Vector2(tile_size, tile_size))
	last_pos = position
	target_pos = position
	
	# Action preparation
	curr_health = max_health
	for btn in get_tree().get_nodes_in_group("player_actions"):
		btn.connect("action_signal", self, "_on_ActionButton_action_signal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Movement
	position += speed * move_dir * delta
	
	if position.distance_to(last_pos) >= tile_size:
		position = target_pos
		
	# Idle
	if position == target_pos:
		get_movedir()
		last_pos = position
		target_pos += move_dir * tile_size
	
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

# Show the action panel at the beginning of player's turn
func show_action_panel():
	$ActionPanel.show()

# Hide the action panel at the end of player's turn
func hide_action_panel():
	$ActionPanel.hide()

func stack_action():
	pass

func action_heal(i):
	curr_health += i
	
	if curr_health > max_health:
		curr_health = max_health

func action_attack():
	# Assuming the attack goes AoE but close ranged
	var enemy_list = get_tree().get_nodes_in_group("enemies")
	for en in enemy_list:
		if en.global_position.distance_to(self.global_position) <= min_atk_distance:
			print("Damage the enemy")
			# damage function in the enemy nodes' script
	pass

func action_ranged_attack():
	
	pass

func do_action():
	#walking
	
	#attack
	
	#healing
	pass

# Goes to this function after each finished action
# Done move 1 grid, goes here; done attack, goes here
func on_action_end():
	if curr_action_idx < max_action_idx:
		curr_action_idx += 1
		#execute next action
	else:
		print("End of player's turn")
		curr_action_idx = 0
		input_counter = 0
		#end player turn here
		
	

# Function that handle the signal emitted from Action Buttons
# Add the action condition accordingly
func _on_ActionButton_action_signal(action):
	# Assuming all action receive are valid string
	action_array[input_counter] = action
	
	print("Action inputted: " + action)
	
	input_counter += 1
	
	# Check input counter
	if input_counter > max_action_idx:
		hide_action_panel()
		
		# Start executing the action(s)
		# walk() etc etc etc
		
	
