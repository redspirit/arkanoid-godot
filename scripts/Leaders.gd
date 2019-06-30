extends Node2D


func _ready():
	var data = Scores.getData()
	$ListNode/ItemNode.visible = false
	$HTTPRequest.request("http://redspirit.ru:5500/api/leaders?name=" + data.name)
	


func makeList(items):
	var i = 0
	for item in items:
		i += 1
		var node = $ListNode/ItemNode.duplicate(0)
		node.visible = true
		node.position.y = (i - 1) * 48 
		if item.has("separator") :
			node.get_node("separator").visible = true
			node.get_node("num").visible = false
			node.get_node("name").visible = false
			node.get_node("score").visible = false
		else :
			node.get_node("num").text = str(item.num)
			node.get_node("name").text = item.name
			node.get_node("score").text = str(item.score)
		$ListNode.add_child(node)
		
		

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if response_code != 200:
		print("ERROR ", body)
		return

	var json = JSON.parse(body.get_string_from_utf8())
	makeList(json.result)


func _on_TouchBack_pressed():
	get_tree().change_scene("res://scenes/Menu.tscn")
