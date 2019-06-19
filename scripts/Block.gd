extends KinematicBody2D

signal addScore(value)
signal spawnBonus(name, pos)

var isBlock = true
var blockIndex = 0

var blocks = {		#[lives, score]
	2: [1, 100, ""],
	3: [1, 120, ""],
	4: [1, 140, ""],
	5: [1, 160, ""],
	6: [1, 180, ""],
	7: [1, 200, ""],
	10: [1, 60, ""],
	11: [1, 80, ""],
	8: [3, 500, "white"],		#0,80
	9: [5, 1000, "gold"]		#0,88
}

var bonuses = ["expand", "laser", "slow", "catch", "player"]
#var bonuses = ["laser", "laser", "laser", "laser", "laser"]

var lives
var score
var animName = ""

var useAnimation = false
var animDuration = 0.04
var animElapsed = 0
var animFrame = 0

func _ready():
	randomize()

	
func _process(delta):
	
	if useAnimation :
	
		animElapsed += delta
		if animElapsed >= animDuration:
			animElapsed = 0
			animFrame += 1
		
		if animFrame == 6:
			animFrame = 0
			useAnimation = ""
		
		var offset = 0
		if animName == "gold" :
			offset = 8
		
		$Sprite.region_rect = Rect2(animFrame * 16, 80 + offset, 16, 8)
	
	
func setup(x, y, rect, index):
	position.x = 24 + x * 48
	position.y = 24 + y * 24
	$Sprite.region_rect = rect
	blockIndex = index
	lives = blocks[blockIndex][0]
	score = blocks[blockIndex][1]
	animName = blocks[blockIndex][2]
	
func emitRandomBonus():
	if rand_range(0, 1) < 0.08 :
		emit_signal("spawnBonus", bonuses[floor(rand_range(0, 5))], position)
	
func kick():
	lives -= 1
	if lives == 0 :
		emit_signal("addScore", score)
		emitRandomBonus()
		queue_free()
	else :
		useAnimation = true

	

# лазер попадает
func _on_Area2D_area_entered(area):
	area.queue_free()
	kick()
