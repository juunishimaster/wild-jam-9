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
var action_array = ["idle", "idle"]
var input_counter = 0
var curr_action_idx = 0
var max_action_idx = 1 # Because player can only stack 2 actions on their turn

var min_atk_distance = 32 # Change this accordingly

# health
 
signal health_changed
signal dead 
var max_health = 3
var curr_health = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	# Movement preparation
	position = Vector2(176, 176)
	last_pos = position
	target_pos = position
	
	state = IDEL
	
	emit_signal('health_changed', curr_health)
	
	# Action preparation
	curr_health = max_health
	for btn in get_tree().get_nodes_in_group("player_actions"):
		btn.connect("action_signal", self, "_on_ActionButton_action_signal")

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
			en.health -= 1
	pass

func action_ranged_attack():
	
	pass

func do_action():
	
	if(state != IDEL):
		return
	
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

func hurt():
	curr_health -= 1
	emit_signal("health_changed",curr_health)
	if(curr_health == 0):
		emit_signal("dead")
