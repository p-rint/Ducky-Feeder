extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
var SPEED = 11.0
const JUMP_VELOCITY = 5

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var mesh: MeshInstance3D = $Character/MeshInstance3D

var dt : float
var targetRot = 0
var camForw : Vector3
@onready var score := 0 
@onready var animPlr: AnimationPlayer = $AnimationPlayer
@onready var animTree: AnimationTree = $AnimationTree
@onready var animState = animTree["parameters/playback"]


enum STATES {IDLE, MOVE, JUMP, FALL, ATTACK}

var state = STATES.IDLE

func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	direction = flatten($CamPivot.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, dt * 8)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, dt * 8)
		velocity.z = lerp(velocity.z, direction.z * SPEED, dt * 8)
		targetRot = atan2(-direction.x, -direction.z)
	else:
		if is_on_floor():
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)
	

func _physics_process(delta: float) -> void:
	dt = delta
	camForw = flatten($CamPivot.basis.z).normalized()
	addGravity()
	runInputs()
	checkStates()
	move_and_slide()
	checkLife()


func addGravity() -> void:
	if not is_on_floor():
		velocity += get_gravity() * dt
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY
	state = STATES.JUMP



func runInputs() -> void:
	
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		jump()

	if Input.is_action_just_pressed("Attack") and is_on_floor():
		$Timers/AttackWindup.start(0.05)
		animPlr.play("Attack1")
		#state = STATES.ATTACK
		animState.travel("Attack1")
		#velocity = -camForw * 10
		targetRot = atan2(camForw.x, camForw.z)
		model.rotation.y = atan2(camForw.x, camForw.z)
		
		await $Timers/AttackWindup.timeout
		spawnHitbox(AttackFunctions.attack1)
	
	input_dir = Input.get_vector("Left", "Right", "Up", "Down")
	



func checkLife() -> void:
	if position.y < -15:
		get_tree().change_scene_to_file("res://main.tscn")


const HITBOX = preload("uid://lfhfv0i8voap")

func spawnHitbox(atkFunc : Callable):
	var new : Area3D = HITBOX.instantiate()
	new.attackFunction = atkFunc
	new.global_position = model.global_position
	new.direction = camForw
	$"..".add_child(new)

func checkStates() -> void:
	
	match state:
		
		STATES.IDLE:
			animTree.set("parameters/Walk/blend_position", flatten(velocity).length()/SPEED)
			if flatten(velocity).length() > 1:
				state = STATES.MOVE
			if not is_on_floor():
				state = STATES.FALL

		STATES.MOVE:
			animTree.set("parameters/Walk/blend_position", flatten(velocity).length()/SPEED)
			if flatten(velocity).length() < 2:
				state = STATES.IDLE
				
			if not is_on_floor():
				state = STATES.FALL
		
		STATES.JUMP:
			if velocity.y <= 0:
				state = STATES.FALL

		STATES.FALL:
			if is_on_floor():
				state = STATES.MOVE
		
		
		
	move()
	#print(state)
		
