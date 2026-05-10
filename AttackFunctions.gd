extends Node

@onready var player: CharacterBody3D = %Player

func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func attack1(player : CharacterBody3D, enemy : CharacterBody3D):
	print(enemy.name)
	enemy.velocity = flatten( enemy.position - player.position ).normalized() * 10
	enemy.damage(2,.5)
