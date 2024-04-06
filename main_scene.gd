extends Node2D
@export var board_scene:PackedScene
var PlayerAmount = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	var board = board_scene.instantiate()
	add_child(board)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
