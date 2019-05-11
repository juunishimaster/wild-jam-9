extends Node2D

var middel_tile
var top_tile
var buttom_tile
var left_tile
var right_tile

const TILE_WIDTH = 320

var single_door_maps = ['res://object/Tiles/E00000001.tscn',
			'res://object/Tiles/E00000010.tscn',
			'res://object/Tiles/E00000100.tscn',
			'res://object/Tiles/E00001000.tscn',
			'res://object/Tiles/E00010000.tscn',
			'res://object/Tiles/E00100000.tscn',
			'res://object/Tiles/E01000000.tscn',
			'res://object/Tiles/E10000000.tscn',
			]

var muilti_door_maps = ['res://object/Tiles/E01010010.tscn',
			'res://object/Tiles/E01010101.tscn',
			'res://object/Tiles/E10101010.tscn',
			]

var tile_width;

func _ready():
	randomize()
	var middel_tile_index = int(rand_range(0,3))
	print(middel_tile_index)
	
	middel_tile = load(muilti_door_maps[middel_tile_index]).instance();
	
	if(middel_tile_index == 0):
		top_tile = load(single_door_maps[1]).instance();
		left_tile = load(single_door_maps[2]).instance();
		buttom_tile = load(single_door_maps[4]).instance();
		right_tile = load(single_door_maps[3]).instance();
		pass
	elif(middel_tile_index == 1):
		top_tile = load(single_door_maps[1]).instance();
		left_tile = load(single_door_maps[7]).instance();
		buttom_tile = load(single_door_maps[5]).instance();
		right_tile = load(single_door_maps[3]).instance();
		pass
	else:
		top_tile = load(single_door_maps[0]).instance();
		left_tile = load(single_door_maps[6]).instance();
		buttom_tile = load(single_door_maps[4]).instance();
		right_tile = load(single_door_maps[2]).instance();
		pass
	
	add_child(middel_tile)
	add_child(top_tile)
	add_child(buttom_tile)
	add_child(left_tile)
	add_child(right_tile)
	middel_tile.position = Vector2(TILE_WIDTH,TILE_WIDTH);
	top_tile.position = Vector2(TILE_WIDTH,0);
	buttom_tile.position = Vector2(TILE_WIDTH,2*TILE_WIDTH);
	right_tile.position = Vector2(0,TILE_WIDTH);
	left_tile.position = Vector2(2*TILE_WIDTH,TILE_WIDTH);
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
