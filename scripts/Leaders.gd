extends Node2D


func _ready():
	$HTTPRequest.getLeaders()
	

func _process(delta):
	if Input.is_action_just_pressed("ui_accept") :
		get_tree().change_scene("res://scenes/Menu.tscn")


func _on_HTTPRequest_onLeaders(items):
	for item in items:
		print("ITEM ", item)
		
