class_name Zombie extends Area2D

signal killed(points)
signal hit

@export var hp = 1
@export var speed = -150
@export var points = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position.x += speed * delta

func die():
	queue_free()


func _on_body_entered(body:CharacterBody2D):	
	if body is Player:
		body.die()
		die()
		
func take_damage(amount):
	hp -= amount
	if hp <= 0:
		killed.emit(points)
		die()
	else:
		hit.emit()
	
