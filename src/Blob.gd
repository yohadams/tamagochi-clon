extends KinematicBody2D

const speed = 80
var velocity = Vector2()
var vector = 'right';

var cat_traits = [
	{'x': 0, 'y': 0, 'w': 64, 'h': 64},
	{'x': 64, 'y': 0, 'w': 64, 'h': 64},
	{'x': 128, 'y': 0, 'w': 64, 'h': 64},
	{'x': 0, 'y': 64, 'w': 64, 'h': 64},
	{'x': 64, 'y': 64, 'w': 64, 'h': 64},
	{'x': 128, 'y': 64, 'w': 64, 'h': 64},
	{'x': 0, 'y': 128, 'w': 64, 'h': 64},
	{'x': 64, 'y': 128, 'w': 64, 'h': 64},
]

var dog_traits = [
	{'x': 0, 'y': 0, 'w': 80, 'h': 64},
	{'x': 80, 'y': 0, 'w': 80, 'h': 64},
	{'x': 160, 'y': 0, 'w': 80, 'h': 64},
	{'x': 0, 'y': 64, 'w': 80, 'h': 64},
	{'x': 80, 'y': 64, 'w': 80, 'h': 64},
	{'x': 160, 'y': 64, 'w': 80, 'h': 64},
	{'x': 0, 'y': 128, 'w': 80, 'h': 64},
	{'x': 80, 'y': 128, 'w': 80, 'h': 64},
]

var deer_traits = [
	{'x': 0, 'y': 0, 'w': 90, 'h': 80},
	{'x': 90, 'y': 0, 'w': 90, 'h': 80},
	{'x': 180, 'y': 0, 'w': 90, 'h': 80},
	{'x': 0, 'y': 80, 'w': 90, 'h': 80},
	{'x': 90, 'y': 80, 'w': 90, 'h': 80},
	{'x': 180, 'y': 80, 'w': 90, 'h': 80},
	{'x': 0, 'y': 160, 'w': 90, 'h': 80},
	{'x': 90, 'y': 160, 'w': 90, 'h': 80},
]

var bird_traits = [
	{'x': 0, 'y': 0, 'w': 140, 'h': 64},
	{'x': 140, 'y': 0, 'w': 140, 'h': 64},
	{'x': 0, 'y': 64, 'w': 140, 'h': 64},
	{'x': 140, 'y': 64, 'w': 140, 'h': 64},
	{'x': 0, 'y': 128, 'w': 140, 'h': 64},
	{'x': 140, 'y': 128, 'w': 140, 'h': 64},
	{'x': 0, 'y': 192, 'w': 140, 'h': 64},
	{'x': 140, 'y': 192, 'w': 140, 'h': 64},
]

func _ready():
	pass # Replace with function body.

func _process(delta):
	var blob = get_parent().get_node('Blob')
	
	if (blob.position.x > 700):
		vector = 'left'
	elif (blob.position.x < 100):
		vector = 'right'
		
	if (vector == 'right'):
		velocity.x = speed
		$Sprite.set_flip_h(false)
		$PigTraits.set_flip_h(false)
		$CatTraits.set_flip_h(false)
		$DogTraits.set_flip_h(false)
		$DogTraits.set_position(Vector2(-24,0))
		$DeerTraits.set_flip_h(false)
		$BirdTraits.set_flip_h(false)
	else:
		velocity.x = -speed
		$Sprite.set_flip_h(true)
		$PigTraits.set_flip_h(true)
		$CatTraits.set_flip_h(true)
		$DogTraits.set_flip_h(true)
		$DogTraits.set_position(Vector2(24,0))
		$DeerTraits.set_flip_h(true)
		$BirdTraits.set_flip_h(true)
		
	set_cat_traits()
	set_pig_traits()
	set_dog_traits()
	set_deer_traits()
	set_bird_traits()
	move_and_slide(velocity, Vector2(0, -1))
	
func set_cat_traits():
	var main = get_parent()
	var cat_level = main.cat_traits
	var current_level = null
	if (int(floor(cat_level/5)) >= len(cat_traits)):
		current_level = cat_traits[7]
	else:
		current_level = cat_traits[floor(cat_level/5)]
	$CatTraits.set_region_rect(Rect2(current_level.x, current_level.y, current_level.w, current_level.h))

func set_pig_traits():
	var main = get_parent()
	var pig_level = main.pig_traits
	var current_level = null
	if (int(floor(pig_level/5)) >= len(cat_traits)):
		current_level = cat_traits[7]
	else:
		current_level = cat_traits[floor(pig_level/5)]
	$PigTraits.set_region_rect(Rect2(current_level.x, current_level.y, current_level.w, current_level.h))

func set_dog_traits():
	var main = get_parent()
	var dog_level = main.dog_traits
	var current_level = null
	if (int(floor(dog_level/5)) >= len(dog_traits)):
		current_level = dog_traits[7]
	else:
		current_level = dog_traits[floor(dog_level/5)]
	$DogTraits.set_region_rect(Rect2(current_level.x, current_level.y, current_level.w, current_level.h))

func set_deer_traits():
	var main = get_parent()
	var deer_level = main.deer_traits
	var current_level = null
	if (int(floor(deer_level/5)) >= len(deer_traits)):
		current_level = deer_traits[7]
	else:
		current_level = deer_traits[floor(deer_level/5)]
	$DeerTraits.set_region_rect(Rect2(current_level.x, current_level.y, current_level.w, current_level.h))
	
func set_bird_traits():
	var main = get_parent()
	var bird_level = main.bird_traits
	var current_level = null
	if (int(floor(bird_level/5)) >= len(bird_traits)):
		current_level = bird_traits[7]
	else:
		current_level = bird_traits[floor(bird_level/5)]
	$BirdTraits.set_region_rect(Rect2(current_level.x, current_level.y, current_level.w, current_level.h))
