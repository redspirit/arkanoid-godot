extends KinematicBody2D

var isBlock = true
var blockIndex = 0

func _ready():
	pass

	
func setup(x, y, rect, index):
	position.x = 24 + x * 24
	position.y = 24 + y * 24
	$Sprite.region_rect = rect
	blockIndex = index
	
func kick():
	queue_free()