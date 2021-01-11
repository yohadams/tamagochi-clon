extends AnimatedSprite

onready var hit = get_parent().get_child(1)

func _ready():
	get_parent().hit_count += 1
	play("play")
	yield(hit, "animation_finished")
	get_parent().hit_count -= 1
	queue_free()
