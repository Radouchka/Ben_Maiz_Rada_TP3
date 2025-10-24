extends Node2D

@export var damage = 1
const SPEED = 800

func _physics_process(delta):
	global_position.x += SPEED * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area: Area2D):
	if area is Zombie:
		area.take_damage(damage)
		queue_free()
