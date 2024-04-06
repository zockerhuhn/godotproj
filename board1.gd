extends Node2D
@export var player_scene:PackedScene
@export var goblin_scene:PackedScene
var Player_scenes = []
var Player_nodes = []
var activeplayer = 0
var playerturn = false
var dienumber:int

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(get_parent().PlayerAmount):
		var player_Node:Node = player_scene.instantiate()
		Player_scenes.append(player_scene)
		Player_nodes.append(player_Node)
		add_child(player_Node)
		player_Node.onfield = 1
		player_Node.set_position(get_button(1).get_position())
		if player_Node.choosenclass == 1:
			player_Node.Inventory.append(create_dagger())
			player_Node.Inventory.append(create_bomb())
			player_Node.Inventory.append(create_potionb())
	activeplayer = 1
	summon_goblins()
	startturn()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_active_player():
	return Player_nodes[activeplayer-1]

func startturn():
	playerturn = true
	dienumber = (randi() % 5) +1
	update_label()

func update_label():
	$Sprite2D/Label.set_text("Spieler %s ist am Zug mit %s Feldern" % [activeplayer, dienumber])
	if get_button(Player_nodes[activeplayer-1].onfield).goblinsonfield != null:
		for i in get_button(Player_nodes[activeplayer-1].onfield).goblinsonfield:
			start_combat(Player_nodes[activeplayer-1], i)
	if dienumber <= 0:
		playerturn = false
		summon_goblins()
		if activeplayer >= get_parent().PlayerAmount:
			activeplayer = 1
		else:
			activeplayer += 1
		startturn()

func get_button(id:int):
	return get_node("Sprite2D/Button%s" % id)

func start_combat(fightingplayer:Node, fightingenemy:Node):
	for i in get_children():
		if i == $TimerBattleStart:
			continue
		i.set_visible(false)
	$Sprite2D2.set_visible(true)
	fightingenemy.set_visible(true)
	var origpos = fightingplayer.get_position()
	fightingenemy.set_position(Vector2(500, 0))
	fightingplayer.set_visible(true)
	fightingplayer.set_position(Vector2(-500, 0))
	$TimerBattleStart.start()
	await $TimerBattleStart.timeout
	var PlayerCard = fightingplayer.Inventory.pick_random()
	var EnemyCard = fightingenemy.Inventory.pick_random()
	if PlayerCard.Value == 0:
		triggercardeffect(PlayerCard.type, PlayerCard, fightingplayer.Inventory)
		print("skipped")
		end_combat(origpos, fightingenemy)
	if PlayerCard.Value > EnemyCard.Value:
		triggercardeffect(PlayerCard.type, PlayerCard, fightingplayer.Inventory)
		print("Player wins with card %s against %s" % [PlayerCard.cardname, EnemyCard.cardname])
		fightingenemy.queue_free()
		get_button(Player_nodes[activeplayer-1].onfield).goblinsonfield.erase(fightingenemy)
		end_combat(origpos)
	if PlayerCard.Value >= EnemyCard.Value:
		triggercardeffect(PlayerCard.type, PlayerCard, fightingplayer.Inventory)
		print("Player wins with card %s against %s" % [PlayerCard.cardname, EnemyCard.cardname])
	if PlayerCard.Value <= EnemyCard.Value:
		triggercardeffect(EnemyCard.type, EnemyCard, fightingplayer.Inventory)
		print("Enemy wins with card %s against %s" % [PlayerCard.cardname, EnemyCard.cardname])
	end_combat(origpos, fightingenemy)

func end_combat(OrigPos:Vector2, enemy:Node = null):
	for i in get_children():
		if i == $TimerBattleStart:
			continue
		i.set_visible(true)
	$Sprite2D2.set_visible(false)
	Player_nodes[activeplayer-1].set_position(OrigPos)
	if enemy != null:
		enemy.set_position(OrigPos)

func summon_goblins():
	var amountofgoblins = randi() % 3
	if amountofgoblins >= 1:
		for i in range(amountofgoblins):
			var fieldnr = (randi() % 11)+2
			var goblin = goblin_scene.instantiate()
			add_child(goblin)
			var field = get_button(fieldnr)
			field.goblinsonfield.append(goblin)
			goblin.set_position(field.get_position())
			goblin.Inventory.append(create_goopbow())
			goblin.Inventory.append(create_goopspear())

func triggercardeffect(cardtype:int, card:cards, fightingplayerinv:Array):
	if cardtype == 1:
		card.Value += 1
	if cardtype == 2 or cardtype == 6:
		fightingplayerinv.erase(card)
		card.queue_free()
	if cardtype == 3:
		pass
	if cardtype == 4 or cardtype == 5:
		fightingplayerinv.append(create_goop())
	if cardtype == 5:
		fightingplayerinv.append(create_goop())

func create_dagger():
	var card = cards.new()
	card.Value = 1
	card.cardname = "Dagger"
	card.type = 1
	card.effectdescript = "this card gains +1"
	return card

func create_bomb():
	var card = cards.new()
	card.Value = 9
	card.cardname = "Bomb"
	card.type = 2
	card.effectdescript = "this card destroys itself"
	return card

func create_potionb():
	var card = cards.new()
	card.Value= 0
	card.cardname = "Potion B"
	card.type = 3
	card.effectdescript = "this fight will be skipped"
	return card

func create_goopbow():
	var card = cards.new()
	card.Value = 1
	card.cardname = "Goop Bow"
	card.type = 4
	card.effectdescript = "adds one Goop into your Inventory"
	return card

func create_goopspear():
	var card = cards.new()
	card.Value = 5
	card.cardname = "Goop Spear"
	card.type = 5
	card.effectdescript = "adds two Goop into your Inventory"
	return card

func create_goop():
	var card = cards.new()
	card.Value= 1
	card.cardname = "Goop"
	card.type = 6
	card.effectdescript = "this card destroys itself"
	return card
