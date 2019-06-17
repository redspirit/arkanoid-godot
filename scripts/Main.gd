extends Node2D

var isPreparedBall = true

var lives = 3

func _ready():
	
	var Block = preload("res://scenes/Block.tscn")
	
	var EditorMap = $Body/PlayField/blocks/EditorBlocks
	EditorMap.visible = false
	
	for point in EditorMap.get_used_cells():
		var block = Block.instance()
		var id = EditorMap.get_cell(point.x, point.y)
		block.setup(point.x, point.y, EditorMap.tile_set.tile_get_region(id), id)
		$Body/PlayField/blocks.add_child(block)

	isPreparedBall = true
	$GUI/LivesLabel.text = str(lives)


func _physics_process(delta):
	
	if isPreparedBall:
		var pos = $Body/PlayField/Player.position
		$Body/PlayField/Ball.grab(Vector2(pos.x, pos.y - 24))
	
	if Input.is_action_just_pressed("ui_accept") && isPreparedBall:
		$Body/PlayField/Ball.release(300)
		isPreparedBall = false
	
	

# шар улетает вниз
func _on_OutFieldArea_body_entered(body):
	lives -= 1
	$GUI/LivesLabel.text = str(lives)
	if lives > 0:
		isPreparedBall = true
	else :
		print("GAME OVER")
	