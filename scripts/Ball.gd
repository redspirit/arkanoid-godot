extends RigidBody2D

var isHolding = true
var gpos


func grab(pos):
	isHolding = true
	set_position(pos)
	gpos = global_position

func release(speed):
	linear_velocity = Vector2(1, -1.1) * speed 
	isHolding = false


func _integrate_forces(state):
	if isHolding:
		state.transform = Transform2D(0.0, gpos)
		state.linear_velocity = Vector2()



func _on_Ball_body_exited(body):
	if body.get("isBlock") :
		body.kick()

