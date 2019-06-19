extends HTTPRequest

signal onLeaders(items)
signal onSave


var httpGet
var baseUrl = "http://redspirit.ru:5500/api"
var requestMode
	
	
func getLeaders():
	requestMode = "leaders"
	request(baseUrl + "/leaders")

func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	if requestMode == "leaders":
		var json = JSON.parse(body.get_string_from_utf8())
		emit_signal("onLeaders", json.result)
	elif requestMode == "save":
		pass
		
		
	
