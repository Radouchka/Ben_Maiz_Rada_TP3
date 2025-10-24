class_name Player extends CharacterBody2D

signal bullet_shot(bullet_scene, location)
signal killed
@onready var muzzle = $Muzzle
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var bullet_scene = preload("res://scenes/bullet.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	#Gets Input direction : 1,0,-1
	var direction := Input.get_axis("move_left", "move_right")
	
	#Flip the Sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	#Play Animations
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else :
			animated_sprite.play("run")
	else :
		animated_sprite.play("jump")
		
	if Input.is_action_pressed("shoot"):
		animated_sprite.play("Shoot")
		
	#Apply mouvement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func shoot():
	bullet_shot.emit(bullet_scene, muzzle.global_position)
	
func die():
	killed.emit()
	queue_free()
