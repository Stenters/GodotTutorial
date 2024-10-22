extends Node2D

enum GameState { Loading, Running, GameOver }
onready var State = GameState.Loading
onready var enemyObj = preload("res://Enemy.tscn")

var Player = null
var cam = null

# Called when the node enters the scene tree for the first time.
func _ready():
	var labelText = "Stage " + str(globals.currentStage)
	$Label.set_text(labelText)
	# $AnimationPlayer.play("Stage Display")
	startAnimationDone()

func _process(delta):
	$HUD/Kills.set_text("Kills:" + str(globals.kills))
	pass
	
func _input(event):
	if(State == GameState.GameOver):
		if(event.is_action("PLAYER_SHOOT")):
			get_tree().change_scene("TitleScene/TitleScene.tscn")

func startAnimationDone():
	$Label.visible = false
	Player = load("res://Player.tscn").instance()
	Player.position = Vector2(300,720/2)
	cam = Camera2D.new()
	cam.position.x = 360
	cam.make_current()
	Player.add_child(cam)
	add_child(Player)
	SpawnEnemies()
	State = GameState.Running
	
func _on_Area2D_area_entered(area):
	if(area.get_collision_layer_bit(4)):
		if(State == GameState.Running):
			Player.speed = 0
			globals.currentStage += 1
			get_tree().reload_current_scene()
			
func PlayerDied():
	for i in Player.get_children():
		i.queue_free()
	remove_child(Player)
	State = GameState.GameOver
	
	$Label.set_text("Game Over")
	$Label.visible = true
	$Label.set_position(Vector2(1280/2 - 200, 700/2))
	
func SpawnEnemy(x,y):
	var enemy = enemyObj.instance()
	enemy.set_position(Vector2(x,y))
	add_child(enemy)
	
func SpawnEnemies():
	randomize()
	for i in range(0,10+globals.currentStage):
		SpawnEnemy(700 + randi() % 5000, randi() % int(get_viewport_rect().size.y))
	
func SpawnBossWave():
	pass