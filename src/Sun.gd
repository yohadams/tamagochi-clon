extends KinematicBody2D

const speed = 90
var velocity = Vector2()

func _ready():
	pass # Replace with function body.

func _process(delta):
	var sun = get_parent().get_node('Sun')
	if (sun.position.x > -600):
		velocity.x = -speed
	else:
		queue_free()
	
	move_and_slide(velocity, Vector2(0, -1))
