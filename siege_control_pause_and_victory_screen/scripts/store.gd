extends Control

@onready var castle: Castle = $"../../../Castle"
@onready var player: CharacterBody2D = $"../../../player"
@onready var game_manager: Node = %GameManager

# Starting prices
var castle_health_cost := 3
var regen_cost := 3
var dmg_cost := 3

# Labels showing prices (set these paths to your actual labels)
@onready var price_1: Label = $"HBoxContainer/Price Container/Price1"
@onready var price_2: Label = $"HBoxContainer/Price Container/Price2"
@onready var price_3: Label = $"HBoxContainer/Price Container/Price3"


func _try_buy(cost: int) -> bool:
	if game_manager.score < cost:
		print("Not enough coins")
		return false
	game_manager.score -= cost
	print("Purchase successful")
	return true


func _on_store_button_pressed() -> void:
	var shop_node = get_parent().get_node("Store")
	
	shop_node.visible = true
	# Pause the entire game world
	get_tree().paused = true

func _on_close_button_pressed() -> void:
	var shop_node = get_parent().get_node("Store")
	
	shop_node.visible = false
	# Resume the entire game world
	get_tree().paused = false


func _ready() -> void:
	# Set the Shop node to ignore the pause state in Godot 4.x
	self.process_mode = Node.ProcessMode.PROCESS_MODE_ALWAYS
	
	_update_price_labels()

# ... (rest of the functions)
func _update_price_labels() -> void:
	price_1.text = str(castle_health_cost) + " Coins\n\n"
	price_2.text = str(regen_cost) + " Coins\n\n"
	price_3.text = str(dmg_cost) + " Coins"
	
func _on_buy_button_1_pressed() -> void:
	if _try_buy(castle_health_cost):
		castle.increase_max_health(20)
		castle_health_cost += 1
		_update_price_labels()

func _on_buy_button_2_pressed() -> void:
	if _try_buy(regen_cost):
		castle.increase_regen_by(0.5)
		regen_cost += 1
		_update_price_labels()

func _on_buy_button_3_pressed() -> void:
	if _try_buy(dmg_cost):
		player.increase_damage(5)
		dmg_cost += 1
		_update_price_labels()
