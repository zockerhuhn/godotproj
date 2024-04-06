extends Node2D
var onfield:int
var choosenclass:int = 1
var Inventory = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if len(Inventory) >= 10:
		Inventory.pop_back()
