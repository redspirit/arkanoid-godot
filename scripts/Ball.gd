extends RigidBody2D

signal CollideBall

var isHolding = true
var gpos

var speed = 0
var normalSpeed = 350
var slowedSpeed = 250

func _ready():
	speed = normalSpeed

func grab(pos):
	isHolding = true
	set_position(pos)
	gpos = global_position

func release():
	linear_velocity = Vector2(1, -1.2).normalized() * speed 
	isHolding = false

func doSlow():
	speed = slowedSpeed
	var norm = linear_velocity.normalized()
	linear_velocity = norm * speed
	$SpeedTimer.start(10)
	
func doNormalSpeed():
	speed = normalSpeed


func _integrate_forces(state):
	if isHolding:
		state.transform = Transform2D(0.0, gpos)
		state.linear_velocity = Vector2()


func _on_Ball_body_exited(body):
	if body.get("isBlock") :
		body.kick(false)

func setSpeed():
	var norm = linear_velocity.normalized()
	linear_velocity = norm * speed

func _on_SpeedTimer_timeout():
	doNormalSpeed()


func _on_Ball_body_entered(body):
	if body.name == "Player":
		emit_signal("CollideBall")
		$hitRacket.play()
		setSpeed()
	elif body.name == "Walls" :
		$hitBorder.play()
	else :
		if body.lives == 1 :
			$hitCube.play()
		else :
			$hitUnbreak.play()