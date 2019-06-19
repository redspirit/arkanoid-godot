extends Node2D

var cursorIndex = 0

func _ready():
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("ui_down"):
		cursorIndex += 1
		if cursorIndex >= 2:
			cursorIndex = 2
		#$SelectSound.play()
	
	if Input.is_action_just_pressed("ui_up"):
		cursorIndex -= 1
		if cursorIndex <= 0:
			cursorIndex = 0
	
	if Input.is_action_just_pressed("ui_accept") :
		selecItem()
		
	$Options/Sprite.position.y = cursorIndex * 48
	
func selecItem():
	if cursorIndex == 0 :
		get_tree().change_scene("res://scenes/Main.tscn")
	elif cursorIndex == 1:
		get_tree().change_scene("res://scenes/Leaders.tscn")
	elif cursorIndex == 2 :
		get_tree().quit()
		
		