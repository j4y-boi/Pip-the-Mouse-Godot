extends Node2D
@onready var food_copy: Sprite2D = $foodCopy
@onready var panel: Sprite2D = $"../Control/Panel"

signal newFood

var amountSpawned = 0
var spawnLimit = 10
var foods = {}

var foodTextures = [
	"res://assets/food/apple_slice.bmp",
	"res://assets/food/cheese.bmp",
	"res://assets/food/peanut.bmp",
	"res://assets/food/sunflowerseed.png",
	"res://assets/food/blueberry.png",
]

func _input(event):
	if event.is_action_pressed("left") and (not panel.goDown or panel.topguislide == -3):
		if not amountSpawned >= spawnLimit:
			amountSpawned += 1
			var buffer = food_copy.duplicate() #WHAT THE HELL IS THIS FOR THEN IF I NEED TO ADD IT ANYWAY
			buffer.position.x = randi_range(65, 447)
			buffer.position.y = randi_range(342, 446) #note to self: do NOT ever change this outside of pip's range, he'll fuckin' die and keep walking 
			buffer.set_script(load("res://scripts/foodZ.gd")) #see? im nice with resources, i only add the script after its cloned :)
			buffer.visible = true
			buffer.name = "food"+str(amountSpawned)
			
			var texture = load(foodTextures[randi_range(0,len(foodTextures)-1)])
			buffer.texture = texture
			
			add_child(buffer) #<-- THIS, THIS, I HATE THIS. WHY IS THIS.
			
			foods[buffer.name] = buffer.position
			emit_signal("newFood")
			
func _on_mouse_ate_food(food: String) -> void:
	if foods.has(food):
		foods.erase(food)
		amountSpawned -= 1
		var actualfood = get_node_or_null(food) #like the node ig
		if actualfood: #if the son of a ditch exists
			actualfood.queue_free() # actually remove it from the scene instead of just out of the dict like before
