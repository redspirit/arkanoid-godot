extends Node2D

var cursorIndex = 0

func _ready():
	#return Scores.saveData(100, "A")
	var data = Scores.getData()
	$highscoreValue.text = str(data.score)
	$Music.play()


func _on_TouchScreenButton_pressed():
	get_tree().change_scene("res://scenes/Main.tscn")

func _on_TouchLeaders_pressed():
	get_tree().change_scene("res://scenes/Leaders.tscn")

func _on_TouchExit_pressed():
	get_tree().quit()
