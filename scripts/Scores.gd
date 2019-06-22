extends Node

signal onGetLeaders(list)

var score = 0
var savePath = "user://save.dat"
var saveData = {}
var baseUrl = "http://localhost:5500/api"

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
		
		
func getData():
	return saveData

func isRecord(val):
	return val > saveData.score

func saveData(s, name):
	saveData.score = s
	saveData.name = name
	var file = File.new()
	file.open(savePath, File.WRITE)
	file.store_string(JSON.print(saveData))
	file.close()
	
