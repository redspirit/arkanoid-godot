extends Node2D

var baseUrl = "http://localhost:5500/api"

func _ready():
	
	Scores.httpGetLeaders()
	
	#$HTTPRequest.request(baseUrl + "/leaders")
	
	

func _process(delta):
	
	if Input.is_action_just_pressed("ui_accept") :
		get_tree().change_scene("res://scenes/Menu.tscn")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	print("CODE ", response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
