extends Sprite

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var action_array = ["idle", "idle"]
var input_counter = 0
var curr_action_idx = 0
var max_action_idx = 1 # Because player can only stack 2 actions on their turn

# Called when the node enters the scene tree for the first time.
func _ready():
	for btn in get_tree().get_nodes_in_group("player_actions"):
		btn.connect("action_signal", self, "_on_ActionButton_action_signal")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Show the action panel at the beginning of player's turn
func show_action_panel():
	$ActionPanel.show()

# Hide the action panel at the end of player's turn
func hide_action_panel():
	$ActionPanel.hide()

func stack_action():
	pass

func do_action():
	#walking
	
	#attack
	pass

# Goes to this function after each finished action
# Done move 1 grid, goes here; done attack, goes here
func on_action_end():
	if curr_action_idx < max_action_idx:
		curr_action_idx += 1
		#execute next action
	else:
		print("End of player's turn")
		#end player turn here
	

# Function that handle the signal emitted from Action Buttons
# Add the action condition accordingly
func _on_ActionButton_action_signal(action):
	# Assuming all action receive are valid string
	action_array[input_counter] = action
	
	# Check action
	# These current action are placeholders
	if action == "walk-up":
		print("Tested Walk up")
	elif action == "walk-down":
		print("Walk down")
	elif action == "attack-a":
		print("Punch")
	else:
		print("Godot cannot understand")
	
	input_counter += 1
	
	# Check input counter
	if input_counter > max_action_idx:
		hide_action_panel()
		# Start executing the action(s)
		
	
