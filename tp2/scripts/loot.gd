extends Area2D
@onready var anim = $AnimatedSprite2D

func _on_body_entered(body):
	if "Player" in body.name: 
		body.use_power_up()
		queue_free()
