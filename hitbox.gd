extends Area3D

var foundAreas = []

@onready var player : CharacterBody3D = $"../Player"
var attackFunction : Callable = print

var speed = -40
var rotSpeed = -20
var direction = Vector3(0,0,0)


@onready var food: Node3D = $Food
@onready var bread: MeshInstance3D = $Food/Bread


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_entered)
	$Lifetime.timeout.connect(queue_free)
	
	#food.get_children()[randi_range(0,2)].visible = true #the amt of food
		
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position += direction * speed * delta
	bread.rotation.y += delta * rotSpeed

func _on_area_entered(area: Area3D) -> void: #You can make it so if the name starts with P, it's a player and E if enemy. Alsoa substring that takes out the 1st letter returns just "Hurtbox"
	#print(area.name == "Hurtbox")
	var sameParent = get_parent() == player
	if area.name == "Hurtbox" and not sameParent:
		#print("A")
		for i : int in foundAreas.size():
			
			if area == foundAreas[i]:
				return
		
		#if not hit already:
		print("Found " + area.get_parent().get_parent().name)
		
		var enemy = area.get_parent().get_parent()
		attackFunction.call(player, enemy)
		if area.has_method("damage"):
			#Damage
			
			foundAreas.append(area)
