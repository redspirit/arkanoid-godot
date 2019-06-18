extends Area2D

var speed = 700

func _ready():
	pass

func _physics_process(delta):
	position.y -= delta * speed
	
	