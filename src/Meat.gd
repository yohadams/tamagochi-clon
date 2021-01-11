extends AnimatedSprite

onready var meat = get_parent().get_child(0)

func _ready():
	play("play")
	yield(meat, "animation_finished")
	queue_free()
	
