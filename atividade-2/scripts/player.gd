extends CharacterBody2D

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

enum PlayerState{
	walk,
	idle,
	jump,
	duck
}

var status : PlayerState;
var direction = 0;
var max_jump_count = 2;
var jump_count = 0;

func exit_from_duck_state()->void:
	collision_shape.shape.radius = 7
	collision_shape.shape.height = 16
	collision_shape.position.y = 0

func move()->void:
	update_direction()
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func update_direction()->void:
	if direction > 0:
		anim.flip_h = false
	elif direction < 0:
		anim.flip_h = true
	


const SPEED = 140.0
const JUMP_VELOCITY = -300.0

func idle_state() -> void:
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	if Input.is_action_just_pressed("duck"):
		go_to_duck_state()
		return 
		
func duck_state()-> void:
	update_direction()
	if Input.is_action_just_released("duck"):
		go_to_idle_state()
		exit_from_duck_state()
		return
func walk_state() -> void:
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
func jump_state() -> void:
	move()
	if is_on_floor():
		jump_count = 0
		if velocity.x != 0:
			go_to_walk_state()
		else: go_to_idle_state()
		return
	
	if Input.is_action_just_pressed("jump") and jump_count < max_jump_count:
		go_to_jump_state()
		return
func go_to_idle_state() -> void:
	status = PlayerState.idle
	anim.play("idle")
func go_to_walk_state() -> void:
	status = PlayerState.walk
	anim.play("walk") 
func go_to_jump_state() -> void:
	jump_count += 1
	status = PlayerState.jump
	anim.play("jump")
	velocity.y = JUMP_VELOCITY
func go_to_duck_state() -> void:
	status = PlayerState.duck
	anim.play("duck")
	collision_shape.shape.radius = 5
	collision_shape.shape.height = 10
	collision_shape.position.y = 2

func _ready() -> void:
	go_to_idle_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	direction = Input.get_axis("ui_left", "ui_right")
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.jump:
			jump_state() 
		PlayerState.walk:
			walk_state() 
		PlayerState.duck:
			duck_state() 

		
	
	move_and_slide()
	


#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
		#
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
	#
	#if is_on_floor():
		#if direction > 0:
			#anim.flip_h = false
			#anim.play("walk")
		#elif direction < 0:
			#anim.flip_h = true
			#anim.play("walk")
		#else:
			#anim.play("idle")
	#else:
		#anim.play("jump")
		#if direction > 0:
			#anim.flip_h = false
		#elif direction < 0:
			#anim.flip_h = true
			#
			#
	#move_and_slide()
