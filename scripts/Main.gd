extends Node2D

var isPreparedBall = true
var Bonus = preload("res://scenes/Bonus.tscn")
var Block = preload("res://scenes/Block.tscn")

var lives = 3
var score = 0
var isStick = false

var ball

func _ready():
	
	ball = $Body/PlayField/Ball
	
	var EditorMap = $Body/PlayField/blocks/EditorBlocks
	EditorMap.visible = false
	
	for point in EditorMap.get_used_cells():
		var block = Block.instance()
		var id = EditorMap.get_cell(point.x, point.y)
		block.setup(point.x, point.y, EditorMap.tile_set.tile_get_region(id), id)
		block.connect("addScore", self, "_on_addScore")
		block.connect("spawnBonus", self, "_on_spawnBonus")
		$Body/PlayField/blocks.add_child(block)

	isPreparedBall = true
	$GUI/scoreCurrent.text = str(score)
	setLifeBar(lives)
	$Sounds/Gamestart.play()


func _physics_process(delta):
	
	if isPreparedBall:
		var pos = $Body/PlayField/Player.position
		ball.grab(Vector2(pos.x, pos.y - 24))
	
	if Input.is_action_just_pressed("ui_accept") && isPreparedBall:
		ball.release()
		isPreparedBall = false
	
	
func setLifeBar(num) :
	for child in $GUI/LifeBar.get_children():
		child.queue_free()
	var texture = preload("res://sprites/life.png")
	for i in range(num):
		var sprite = Sprite.new()
		sprite.texture = texture
		sprite.position.x = (i % 3) * 16
		sprite.position.y = floor(i / 3) * 8
		$GUI/LifeBar.add_child(sprite)


# шар улетает вниз
func _on_OutFieldArea_body_entered(body):
	lives -= 1
	setLifeBar(lives)
	
	$LifeTimer.start(3)
	$Body/PlayField/Player.explode()
	ball.visible = false
	
	if lives > 0:
		isPreparedBall = true
	else :
		# GAME OVER
		$Body/GameoverLabel.visible = true
		$Sounds/Gameover.play()
	
func _on_addScore(value):
	score += value
	$GUI/scoreCurrent.text = str(score)
	
func _on_spawnBonus(name, pos):
	var bonus = Bonus.instance()
	bonus.spawn(name, pos)
	$Body/PlayField.add_child(bonus)

func _on_Player_getBonus(name):
	if name == "player" && lives < 6:
		lives += 1
		setLifeBar(lives)
	elif name == "slow":
		ball.doSlow() 
	elif name == "catch":
		isStick = true
		$StickTimer.start()


func _on_LifeTimer_timeout():
	if lives == 0 :
		return
	$Body/PlayField/Player.reset()
	$Sounds/Gamestart.play()
	ball.visible = true

# шар удаляется об палку
func _on_Ball_CollideBall():
	if isStick:
		isPreparedBall = true

func _on_StickTimer_timeout():
	isStick = false
