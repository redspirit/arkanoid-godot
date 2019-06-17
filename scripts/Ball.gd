extends RigidBody2D

var isHolding = false
var reset = false
var resetPos = Vector2()
var speed = 100

func getVelocity() :
	return Vector2(1, -1.1) * speed 

func myPosition(pos) :
	set_position(pos)
	resetPos = pos

func run(s):
	speed = s
	linear_velocity = getVelocity()
	reset = false
	#resetPos = position

func reset():
	reset = true
	#resetPos = position

func _integrate_forces(state):
	if reset:
		state.transform = Transform2D(0.0, resetPos)
		state.linear_velocity =  getVelocity()
		#reset = false
	#else :
	#	linear_velocity = getVelocity()
		
func _on_Ball_body_exited(body):
	if body.get("isBlock") :
		body.kick()

