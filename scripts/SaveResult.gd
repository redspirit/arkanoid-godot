extends Node2D

var cursorIndex = 0
var set = "_ABCDEFGHIJKLMNOPQRSTUVWXYZ"
var result = [0, 0, 0, 0, 0, 0]
var score = 0
var url = "http://redspirit.ru:5500/api/save"
var doReturn = false

func _ready():
	var data = Scores.getData()
	score = data.score
	$ScoresValue.text = str(data.score)
	$NotifLabel.visible = false
	
	var i = 0
	for ch in data.name:
		i += 1
		var num = set.find(ch)
		result[i - 1] = num
		$NameNode.get_node("lab_" + str(i)).text = set[num]


func _process(delta):
	
	if Input.is_action_just_pressed("ui_right"):
		cursorIndex += 1
		if cursorIndex > 5:
			cursorIndex = 0

	if Input.is_action_just_pressed("ui_left"):
		cursorIndex -= 1
		if cursorIndex < 0:
			cursorIndex = 5

	if Input.is_action_just_pressed("ui_up"):
		result[cursorIndex] += 1
		if result[cursorIndex] > 26:
			result[cursorIndex] = 0
		drawLatter()
		
	if Input.is_action_just_pressed("ui_down"):
		result[cursorIndex] -= 1
		if result[cursorIndex] < 0:
			result[cursorIndex] = 26
		drawLatter()
		
	if Input.is_action_just_pressed("ui_accept") :
		saveName()
		
	$NameNode/ArrowNode/ArrowLabel.rect_position.x = cursorIndex * 48
	
func drawLatter():
	var elem = $NameNode.get_node("lab_" + str(cursorIndex + 1))
	elem.text = set[result[cursorIndex]]
	
func saveName():
	
	var name = ""
	
	for i in result:
		if i > 0 :
			name += set[i]
	
	if name.length() < 3:
		$NotifLabel.text = "3 latters minimum"
		$NotifLabel.visible = true
		$Timer.start()
		doReturn = false
		return
		
	Scores.saveData(score, name)
	makeRequest(name)

func makeRequest(name):
	var query = JSON.print({"name":name, "score": score})
	var headers = ["Content-Type: application/json"]
	$HTTPRequest.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _on_Timer_timeout():
	$NotifLabel.visible = false
	if doReturn:
		get_tree().change_scene("res://scenes/Leaders.tscn")


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code == 200:
		$NotifLabel.text = "saved"
		$NotifLabel.visible = true
		doReturn = true
		$Timer.start()
	else :
		$NotifLabel.text = "server error"
		$NotifLabel.visible = true
		doReturn = true
		$Timer.start()