extends KinematicBody2D

signal getBonus(name)

var direction = 0
var speed = 350
var playerSize = Vector2()
var leftBorder = 0
var rightBorder = 0
var playerX = 0
var explodeFrame = 0
var isFreeze = false
var isExpand = false
var isLaser = false
var bulletsLeft = 3

var normalWidth = Rect2(0,0,32,8)
var extendWidth = Rect2(0,8,48,8)
var normalLaser = Rect2(0,16,32,8)
var extendLaser = Rect2(0,24,48,8)

var bulletMotion = Vector2()

var explodeRects = [
	Rect2(0,40,32,8),
	Rect2(40,32,48,24),
	Rect2(88,32,48,25)
]


func _ready():
	reset()

func _physics_process(delta):
	
	if isFreeze:
		return
	
	if Input.is_action_pressed("ui_left"):
		direction = -1
	elif Input.is_action_pressed("ui_right"):
		direction = 1
	else :
		direction = 0
	
	if Input.is_action_just_pressed("ui_accept") && isLaser && bulletsLeft > 0:
		bulletMotion = Vector2(0, -1)
	

	$bullets/bulletsBody.move_and_slide(bulletMotion * 500)
	move_and_slide(Vector2(direction * speed, 0))
	
func reset():
	$Sprite.region_rect = normalWidth
	$collision.shape.extents = Vector2(48,12)
	$collision.disabled = false
	$bullets.visible = false
	isFreeze = false
	visible = true
	isExpand = false
	isLaser = false


func expand() :
	isExpand = true
	$collision.shape.extents = Vector2(72,12)
	if isLaser:
		$Sprite.region_rect = extendLaser
	else :
		$Sprite.region_rect = extendWidth
	
	
func setLaser():
	isLaser = true
	#$bullets.visible = true
	bulletsLeft = 3
	if isExpand:
		$Sprite.region_rect = extendLaser
	else :
		$Sprite.region_rect = normalLaser

	
# уничтожаем палку
func explode():
	$collision.disabled = true
	$ExplodeTimer.start()
	isFreeze = true
	
func stopBullet() :
	$bullets.position.y = -22
	bulletMotion = Vector2()
	$bullets.visible = false
	
# ловим бонус
func _on_Area2D_area_entered(area):
	var bonus = area.get_parent();
	emit_signal("getBonus", bonus.bonusName)
	
	if bonus.bonusName == "expand":
		expand()

	if bonus.bonusName == "laser":
		setLaser()
		
	bonus.queue_free()


func _on_ExplodeTimer_timeout():
	$Sprite.region_rect = explodeRects[explodeFrame]
	explodeFrame += 1
	if explodeFrame == 3:
		explodeFrame = 0
		$ExplodeTimer.stop()
		visible = false
		position.x = 270
		playerX = position.x





