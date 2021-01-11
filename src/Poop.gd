extends TextureButton

var poop_life = 100

const hit = preload('res://scenes/HitPoop.tscn')
var hit_positions = [Vector2(0,0), Vector2(20, 20), Vector2(40,40), Vector2(60,60), Vector2(70,70)]
var hit_count = 0

func damage_poop():
	if (hit_count < 5):
		if (poop_life - 10 <= 0):
			get_parent().poop_count -= 1
			get_parent().money += 3
			queue_free()
		else:
			poop_life -= 10
			
		var hit_node = hit.instance()
		hit_node.set_position(hit_positions[hit_count])
		add_child(hit_node)
	
