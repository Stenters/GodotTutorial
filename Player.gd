extends Node2D

var speed = 159
var verticalMovement = 0
const MAX_VERTICAL_MOVEMENT = 200
var bulletObj = null
const RATE_OF_FIRE = 3.0
var dying = false

onready var shotCooldown = Timer.new()
onready var explode = preload("res://Explosion.tscn").instance()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(shotCooldown)
	bulletObj = load("res://Bullet.tscn")
	shotCooldown.one_shot = true
	shotCooldown.set_wait_time(1/RATE_OF_FIRE)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	move_local_x(speed*delta)
	if(self.position.y > 1 && self.position.y <= get_viewport_rect().size.y):
		move_local_y(verticalMovement*delta)
	else:
		if(self.position.y < 1):
			move_local_y(10)
			verticalMovement = 0
		if(self.position.y > get_viewport_rect().size.y):
			move_local_y(-10)
			verticalMovement = 0
		if(dying == true):
			if(shotCooldown.time_left == 0):
				get_node("/root/GameSceneRoot").PlayerDied()
				queue_free()
				print("Dead")

func stop():
	speed = 0
	
func explode():
	explode.set_position(self.get_position())
	get_parent().add_child(explode)
	shotCooldown.wait_time = 2.5
	shotCooldown.start()
	$PlayerSprite.visible = false
	dying = true

func _input(event):
	if(event.is_action("PLAYER_UP")):
		if(verticalMovement >= -MAX_VERTICAL_MOVEMENT):
			verticalMovement -= 10
	if(event.is_action("PLAYER_DOWN")):
		if(verticalMovement <= MAX_VERTICAL_MOVEMENT):
			verticalMovement += 10
	if(event.is_action("PLAYER_SHOOT")):
		if(shotCooldown.time_left == 0):
			var bullet = bulletObj.instance()
			bullet.position = self.get_position()
			bullet.position.y += 20
			get_node("/root/GameSceneRoot").add_child(bullet)
			shotCooldown.start()

func _on_Area2D_area_entered(area):
	if(area.get_collision_layer_bit(2)):
		explode()