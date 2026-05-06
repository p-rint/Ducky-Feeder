extends CanvasLayer

@onready var player: CharacterBody3D = $"../Player"

@onready var score: Label = $Score

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	score.text = "Score: " + str(player.score)
