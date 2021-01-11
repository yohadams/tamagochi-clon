extends AnimatedSprite

onready var hit = get_parent().get_child(2)

func _ready():
	get_tree().get_root().get_node('MainScene').hit_count += 1
	play("play")
	yield(hit, "animation_finished")
	get_tree().get_root().get_node('MainScene').hit_count -= 1
	queue_free()
