extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Set this action_type variable with appropriate action
# such as walk-direction, punch, roundhouse-kick, etc
export var action_type = "walk-left"
signal action_signal(action)

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("player_actions")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Emit the signal on mouse click
func _on_ActionButton_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.pressed:
			emit_signal("action_signal", action_type)
			
	
