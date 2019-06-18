extends Sprite

var speed = 120
var bonusName = ""

func _ready():
	pass

func _physics_process(delta):
	position.y += delta * speed

func spawn(name, pos):
	bonusName = name
	set_position(pos)
	$anim.play(name)
	$Timer.start(10)
	

func _on_Timer_timeout():
	queue_free()
