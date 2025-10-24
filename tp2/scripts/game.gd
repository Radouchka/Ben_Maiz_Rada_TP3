extends Node2D

@export var  enemy_scenes: Array[PackedScene] = []
@onready var bullet_container = $BulletContainer
@onready var player = $Player
@onready var timer = $EnemySpawnTimer
@onready var zombie_container = $ZombieContainer
@onready var hud = $UILayer/HUD
@onready var gos = $UILayer/GameOverScreen
@onready var bullet_sound = $SFX/BulletSound
@onready var hit_sound = $SFX/HitSound
@onready var zombie_die = $SFX/ZombieDeathSound


var score := 0:
	set(value):
		score = value
		hud.score = score
var high_score

# Called when the node enters the scene tree for the first time.
func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file!= null:
		high_score = save_file.get_32()
	else :
		high_score = 0
		save_game()
	
	score = 0
	player.bullet_shot.connect(_on_player_bullet_shot)
	player.killed.connect(_on_player_killed)

func save_game():
	var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
	save_file.store_32(high_score)
	
func _on_player_bullet_shot(bullet_scene, location):
	var bullet = bullet_scene.instantiate()
	bullet.global_position = location
	bullet_container.add_child(bullet)
	bullet_sound.play()


func _on_enemy_spawn_timer_timeout() -> void:
	var e = enemy_scenes.pick_random().instantiate()
	e.killed.connect(_on_enemy_killed)
	e.hit.connect(_on_enemy_hit)
	zombie_container.add_child(e)
	
func _on_enemy_hit():
	zombie_die.play()

func _on_enemy_killed(points):
	score += points
	if score > high_score:
		high_score = score
	
func _on_player_killed():
	hit_sound.play()
	gos.set_score(score)
	gos.set_high_score(high_score)
	save_game()
	await get_tree().create_timer(0.5).timeout
	gos.visible = true
