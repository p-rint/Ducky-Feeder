extends CharacterBody3D

var direction : Vector3
var input_dir : Vector2
var SPEED = 7.0
const JUMP_VELOCITY = 5

@onready var camPiv = $CamPivot
@onready var model = $Character
@onready var mesh: MeshInstance3D = $Character/Duck

@onready var player: CharacterBody3D = $"../../Player"

@onready var stunTimer: Timer = $Timers/Stun


var dt : float
var targetRot = 0
@onready var maxHealth = randi_range(4,20)
@onready var health = maxHealth

enum STATES {IDLE, MOVE, JUMP, FALL, STUNNED}

var state = STATES.IDLE


func flatten(vector: Vector3) -> Vector3:
	return Vector3( vector.x, 0, vector.z)

func move() -> void:
	var toPlr := (player.position - position)
	direction = flatten(toPlr).normalized()
	model.rotation.y = lerp_angle(model.rotation.y, targetRot, dt * 12)
	
	if direction and state != STATES.STUNNED:
		velocity.x = lerp(velocity.x, direction.x * SPEED, dt * 8)
		velocity.z = lerp(velocity.z, direction.z * SPEED, dt * 8)
		targetRot = atan2(-direction.x, -direction.z)
	else:
		if is_on_floor():
			velocity = lerp(velocity, Vector3.ZERO + Vector3(0,velocity.y,0), 8 * dt)
	

func _physics_process(delta: float) -> void:
	dt = delta
	addGravity()
	checkStates()
	move_and_slide()
	checkLife()
	
	
	
	
func addGravity() -> void:
	if not is_on_floor():
		velocity += get_gravity() * dt
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY


func checkLife() -> void:
	if position.y < -15:
		queue_free()
	if health <= 0:
		player.score += 1
		queue_free()

func dealDamage(dmg : int) -> void:
	health -= dmg

func damage(dmg : int, stunTime : float) -> void:
	health -= dmg
	state = STATES.STUNNED
	stunTimer.start(stunTime)
	
	var size = .2 + (maxHealth - health)/5.0
	print(size)
	mesh.scale = Vector3(size,size,size)
	$Character/Hurtbox.scale = scale
	


func checkStates() -> void:
	
	match state:
		
		STATES.IDLE:
			if flatten(velocity).length() > 1:
				state = STATES.MOVE
			if not is_on_floor():
				state = STATES.FALL

		STATES.MOVE:
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
		
		STATES.STUNNED:
			if stunTimer.time_left == 0:
				if is_on_floor():
					state = STATES.MOVE
				else: state = STATES.FALL

		
	move()
	#print(state)
