extends Button

var goblinsonfield = []
@export var connectedfields:Array
@export var fieldID:int
@onready var parentnode = get_parent().get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_pressed():
	var activeplayernode = parentnode.get_active_player()
	if !(parentnode.playerturn) or connectedfields.find(activeplayernode.onfield) == -1:
		return
	activeplayernode.onfield = fieldID
	activeplayernode.set_position(self.get_position())
	parentnode.dienumber -= 1
	parentnode.update_label()
	
