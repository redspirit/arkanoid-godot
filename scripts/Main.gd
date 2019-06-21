extends Node2D

var isPreparedBall = true
var Bonus = preload("res://scenes/Bonus.tscn")
var Block = preload("res://scenes/Block.tscn")
var Bullet = preload("res://scenes/Bullet.tscn")

var lives = 3
var score = 0
var isStick = false
var isGameOver = false
var isWaiting = false

var levelsCount = 19
var currentLevel = 1

var ball
var player

func _ready():
	
	ball = $Body/PlayField/Ball
	player = $Body/PlayField/Player
	
	loadLevel(currentLevel)
	
	isPreparedBall = true
	$GUI/scoreCurrent.text = str(score)
	setLifeBar(lives)
	$Sounds/Gamestart.play()
	
	var data = Scores.getData()
	$GUI/highscoreValue.text = str(data.score)
	

func loadLevel(num):
	var EditorMap = $Body/PlayField/blocks.get_node("map_" + str(num))
	$GUI/roundValue.text = str(num)

	for node in $Body/PlayField/blocks.get_children():
		if node.get("isBlock"):
			node.queue_free()
	
	for point in EditorMap.get_used_cells():
		var block = Block.instance()
		var id = EditorMap.get_cell(point.x, point.y)
		block.setup(point.x, point.y, EditorMap.tile_set.tile_get_region(id), id)
		block.connect("addScore", self, "_on_addScore")
		block.connect("spawnBonus", self, "_on_spawnBonus")
		block.connect("levelClear", self, "_on_LevelClear")
		$Body/PlayField/blocks.add_child(block)
		
	changeBackground()

func _physics_process(delta):
	
	if isPreparedBall:
		var pos = player.position
		ball.grab(Vector2(pos.x, pos.y - 24))
	
	if Input.is_action_just_pressed("ui_accept") && !isGameOver && !isWaiting:
		
		if isPreparedBall:
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

func gameOver():
	isGameOver = true
	$Body/GameoverLabel.visible = true
	$Sounds/Gameover.play()
	$GameoverTimer.start()
			
func nextLevel():
	currentLevel += 1
	if currentLevel > levelsCount:
		currentLevel = levelsCount
		print("END")
		return
		
	player.position.x = 270
	isPreparedBall = true
	isWaiting = false
	$Sounds/Gamestart.play()
	loadLevel(currentLevel)


func changeBackground():
	var backMap = $Body/BackTiles
	var backId = currentLevel % 5
	for point in backMap.get_used_cells():
		backMap.set_cell(point.x, point.y, backId)


# шар улетает вниз
func _on_OutFieldArea_body_entered(body):
	lives -= 1
	setLifeBar(lives)
	
	$LifeTimer.start(3)
	player.explode()
	ball.visible = false
	
	if lives > 0:
		isPreparedBall = true
		isWaiting = true
	else :
		gameOver()
	
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
	player.reset()
	$Sounds/Gamestart.play()
	ball.visible = true
	isWaiting = false

# шар удаляется об палку
func _on_Ball_CollideBall():
	if isStick:
		isPreparedBall = true

func _on_StickTimer_timeout():
	isStick = false


func _on_Player_fire(pos1, pos2):
	var bull1 = Bullet.instance()
	bull1.position = pos1
	$Body/PlayField.add_child(bull1)
	var bull2 = Bullet.instance()
	bull2.position = pos2
	$Body/PlayField.add_child(bull2)
	

func _on_GameoverTimer_timeout():
	if Scores.isRecord(score):
		Scores.saveData(score, "")
		get_tree().change_scene("res://scenes/SaveResult.tscn")
	else :
		get_tree().change_scene("res://scenes/Menu.tscn")	
	

func _on_Button_pressed():
	nextLevel()

func _on_LevelClear():
	isWaiting = true
	isPreparedBall = true
	$NextlevelTimer.start()


func _on_SafeArea_Ball_entered(body):
	isPreparedBall = true


func _on_NextlevelTimer_timeout():
	nextLevel()
