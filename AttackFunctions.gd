extends Node

@onready var player: CharacterBody3D = $Player



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func attack1(enemy : CharacterBody3D):
	print(enemy.name)
	enemy.health -= 5
