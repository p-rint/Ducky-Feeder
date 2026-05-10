extends Node3D

@onready var spawnTimer = $Spawn

const ENEMY = preload("uid://dcd0l6ushq3lr")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	
	spawnTimer.timeout.connect(spawnEnemy)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print
	

func spawnEnemy():
	print("A")
	if get_children().size() < 5:
		var new : CharacterBody3D = ENEMY.instantiate()
		add_child(new)
		new.position = Vector3(randi_range(-40,40), 2, randi_range(-40,40))
