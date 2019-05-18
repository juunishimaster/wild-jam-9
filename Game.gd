extends Node2D

export (PackedScene) var Enemy

var curr_turn = 0 # 0 is player's turn; 1 is enemies' turn
var enemy_count = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	
	for i in range(10):
		add_child(Enemy.instance())
	
	# Connect enemies signal with function
	for en in get_tree().get_nodes_in_group("enemies"):
		en.connect("end_enemy_turn", self, "enemy_turn_processor")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func player_turn_processor():
	print("End of player turn")
	curr_turn = 1
	
	var enemy_group = get_tree().get_nodes_in_group("enemies")
	for en in enemy_group:
		en.is_enemy_turn = true
		en.move_me()
	pass
	
func enemy_turn_processor():
	enemy_count += 1
	
	print("Enemy count: " + String(enemy_count))
	
	var enemy_group = get_tree().get_nodes_in_group("enemies")
	
	if enemy_count == enemy_group.size():
		print("End of enemy turn")
		curr_turn = 0
		$Player.toggle_control()
		$Player.is_player_turn = true
		
		#Restart enemy counter
		enemy_count = 0
	pass