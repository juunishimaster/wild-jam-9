extends HBoxContainer

onready var health_counter = [$H1,$H2,$H3]

func _ready():
	pass # Replace with function body.

func _on_Player_health_changed(value):
	print(value)
	for index in range(3):
		print(index)
		health_counter[index].visible = value > index
	pass # Replace with function body.
