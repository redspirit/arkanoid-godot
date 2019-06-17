extends KinematicBody2D

var direction = 0
var speed = 300
var playerSize = Vector2()
var leftBorder = 0
var rightBorder = 0
var playerX = 0

func _ready():
	playerSize = $Sprite.region_rect.size
	leftBorder = 32 + (playerSize.x / 2)
	rightBorder = 442 + (playerSize.x / 2)


func _physics_process(delta):
	
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	else :
		direction = 0
	
	playerX += direction * speed * delta
	
	if playerX >= leftBorder && playerX <= rightBorder :
		position.x = playerX
	else :
		playerX = position.x
	