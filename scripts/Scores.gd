extends Node

signal onGetLeaders(list)

var score = 0
var savePath = "user://save.dat"
var saveData = {}
var baseUrl = "http://localhost:5500/api"
var httpGet
var httpPost

var timer

func _ready():
	var file = File.new()
	if file.file_exists(savePath) :
		file.open(savePath, File.READ)
		var data = JSON.parse(file.get_as_text())
		file.close()
		saveData = data.result
	else :
		saveData = {
			"name": "",
			"score": 0
		}
		
	httpGet = HTTPRequest.new()
	httpPost = HTTPRequest.new()
	httpGet.connect("request_completed", self, "on_http_get_result")
	httpPost.connect("request_completed", self, "on_http_post_result")
	
	#print("KUSS")
	#timer = Timer.new()
	#timer.connect("timeout", self, "_on_timer")
	#timer.start(2)
	
func _on_timer():
	print("TICK")

func getData():
	return saveData

func isRecord(val):
	return val > saveData.score

func saveData(s, name):
	if s < saveData.score:
		return
	saveData.score = s
	saveData.name = name
	var file = File.new()
	file.open(savePath, File.WRITE)
	file.store_string(JSON.print(saveData))
	file.close()
	
func httpGetLeaders():
	#print("make request ", baseUrl + "/leaders")
	#print(httpGet)
	#httpGet.request(baseUrl + "/leaders")
	pass

func httpSaveScore(score, name):
	pass
	
func on_http_get_result(result, response_code, headers, body):
	print("CODE ", response_code)
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
	
func on_http_post_result(result, response_code, headers, body):
	pass
	
	
	
	
	