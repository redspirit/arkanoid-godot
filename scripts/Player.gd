extends KinematicBody2D

signal getBonus(name)
signal fire(pos1, pos2)

var direction = 0
var speed = 380
var playerSize = Vector2()
var leftBorder = 0
var rightBorder = 0
var playerX = 0
var explodeFrame = 0
var isFreeze = false
var isExpand = false
var isLaser = false
var bulletsLeft = 5

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

func toLeft(state):
	if state:
		direction -= 1
	else :
		direction += 1

func toRight(state):
	if state:
		direction += 1
	else :
		direction -= 1

func fire():
	
	if isFreeze:
		return
	
	if isLaser && bulletsLeft > 0:
		bulletsLeft -= 1
		var offset = 32
		if isExpand:
			offset = 56
		var pos1 = position - Vector2(-offset, 24)
		var pos2 = position - Vector2(offset, 24)
		$Laser.play()
		emit_signal("fire", pos1, pos2)
		if bulletsLeft == 0:
			removeLaser()


func _physics_process(delta):
	
	if isFreeze:
		return
	
	move_and_slide(Vector2(direction * speed, 0))
	
func reset():
	$Sprite.region_rect = normalWidth
	$collision.shape.extents = Vector2(48,12)
	$collision.disabled = false
	isFreeze = false
	visible = true
	isExpand = false
	isLaser = false

	#setLaser()

func expand() :
	isExpand = true
	$collision.shape.extents = Vector2(72,12)
	if isLaser:
		$Sprite.region_rect = extendLaser
	else :
		$Sprite.region_rect = extendWidth
		
	$ExtendSound.play()
	
func setLaser():
	isLaser = true
	bulletsLeft = 5
	if isExpand:
		$Sprite.region_rect = extendLaser
	else :
		$Sprite.region_rect = normalLaser

func removeLaser():
	isLaser = false
	if isExpand:
		$Sprite.region_rect = extendWidth
	else :
		$Sprite.region_rect = normalWidth
	
# уничтожаем палку
func explode():
	$collision.disabled = true
	$ExplodeTimer.start()
	isFreeze = true
	
func stopBullet() :
	pass
	
	
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





