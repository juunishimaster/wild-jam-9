extends Node2D

export (PackedScene) var Enemy

var curr_turn = 0 # 0 is player's turn; 1 is enemies' turn

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(10):
		add_child(Enemy.instance())
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_turn_processor():
	pass
	
func enemy_turn_processor():
	pass