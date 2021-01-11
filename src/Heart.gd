extends AnimatedSprite

onready var heart = get_parent().get_child(2)

func _ready():
	get_tree().get_root().get_node('MainScene').heart_count += 1
	play("play")
	yield(heart, "animation_finished")
	get_tree().get_root().get_node('MainScene').heart_count -= 1
	queue_free()
	
