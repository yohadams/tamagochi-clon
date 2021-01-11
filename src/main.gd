extends Node2D

# Needs
var hunger = 0
var fun = 100
var health = 100
export var poop = 0
var money = 100

# Stats
var slime_name = 'test'
var species = 'Slime'
var born_date = 0
var dog_traits = 0
var cat_traits = 0
var bird_traits = 0
var deer_traits = 0
var pig_traits = 0

var poop_count = 0

const hunger_bar = preload('res://scenes/HungerBar.tscn')
const poop_node = preload('res://scenes/Poop.tscn')
const heart = preload('res://scenes/Heart.tscn')
const hit = preload('res://scenes/Hit.tscn')
const sun = preload('res://scenes/Sun.tscn')
const meat = preload('res://scenes/Meat.tscn')


const bars = ['Hunger', 'Fun', 'Health', 'Poop']
const popups = ['Shop', 'Stats', 'WorkPopup', 'PetPopup']

var heart_positions = [Vector2(100,120), Vector2(300, 160), Vector2(220,85)]
var heart_count = 0

var hit_positions = [Vector2(100,120), Vector2(270, 160), Vector2(220,85)]
var hit_count = 0


var _timer = null
var poop_timer = null
var sun_timer = null

func _ready():
	load_save()
	setup_timer()
	setup_poop_timer()
	setup_sun_timer()
	render_bars()
	render_stats()
	add_sun()

func _process(delta):
	render_bars()
	render_stats()
	check_poop()

func setup_timer():
	_timer = Timer.new()
	add_child(_timer)
	_timer.connect("timeout", self, "process_hunger")
	_timer.set_wait_time(60)
	_timer.set_one_shot(false) # Make sure it loops
	_timer.start()

func setup_poop_timer():
	poop_timer = Timer.new()
	add_child(poop_timer)
	poop_timer.connect("timeout", self, "process_poop")
	poop_timer.set_wait_time(60)
	poop_timer.set_one_shot(false) # Make sure it loops
	poop_timer.start()

func setup_sun_timer():
	sun_timer = Timer.new()
	add_child(sun_timer)
	sun_timer.connect("timeout", self, "add_sun")
	sun_timer.set_wait_time(600)
	sun_timer.set_one_shot(false) # Make sure it loops
	sun_timer.start()

func process_hunger():
	if (hunger + 1 < 100):
		hunger += 1
	else:
		hunger = 100
		health -= 5

func process_poop():
	health -= poop_count

func add_sun():
	var new_sun = sun.instance()
	new_sun.set_position(Vector2(600, -300))
	$Background.add_child(new_sun)

func get_value(name):
	match name:
		'Hunger':
			return hunger
		'Fun':
			return fun
		'Poop':
			return poop
		'Health':
			return health
		'Money':
			return money

func render_stats():
	$Stats/StatsPanel/VBoxContainer/Name.text = slime_name
	$Stats/StatsPanel/VBoxContainer/Spiecies.text = 'Species: ' + species
	$Stats/StatsPanel/VBoxContainer/Age.text = 'Age: ' + str(born_date)
	$Stats/StatsPanel/VBoxContainer/CatLevel.text = 'Cat level: ' + str(cat_traits)
	$Stats/StatsPanel/VBoxContainer/DogLevel.text = 'Dog level: ' + str(dog_traits)
	$Stats/StatsPanel/VBoxContainer/DeerLevel.text = 'Deer level: ' + str(deer_traits)
	$Stats/StatsPanel/VBoxContainer/PigLevel.text = 'Pig level: ' + str(pig_traits)
	$Stats/StatsPanel/VBoxContainer/BirdLevel.text = 'Bird level: ' + str(bird_traits)

func render_bars():
	for bar in bars:
		get_node(bar + '/' + bar + 'Label').text = bar + ' ' + str(get_value(bar)) + '/100'
		var sprite = get_node(bar + '/Bar')
		var scale = sprite.get_scale()
		scale.x = get_value(bar) * 2
		sprite.position.x = -(100 - get_value(bar))
		sprite.set_scale(scale)
	$Money.text = 'Money ' + str(money) + ' $'

func close_all_popups(exept):
	for popup in popups:
		if (exept != popup):
			get_node(popup).hide()

func open_menu():
	close_all_popups('Shop')
	if !$Shop.visible:
		$Shop.show()
	else:
		$Shop.hide()

func open_stats():
	close_all_popups('Stats')
	if !$Stats.visible:
		$Stats.show()
	else:
		$Stats.hide()

func save_game():
	var save_game = File.new()
	save_game.open('user://' + slime_name + '.save', File.WRITE)
	save_game.store_line(to_json({
		"slime_name": slime_name,
		"health": health,
		"poop": poop,
		"fun": fun,
		"hunger": hunger,
		"money": money,
		"spieces": species,
		"age": born_date,
		"cat_level": cat_traits,
		"dog_level": dog_traits,
		"deer_level": deer_traits,
		"pig_level": pig_traits,
		"bird_level": bird_traits,
		"poop_count": poop_count,
		"save_time": OS.get_unix_time()
	}))
	save_game.close()

func load_save():
	var save_game = File.new()
	if not save_game.file_exists('user://' + slime_name + '.save'):
		return # Error! We don't have a save to load.
	else:
		save_game.open('user://' + slime_name + '.save', File.READ)
		var save_data = parse_json(save_game.get_line())
		health = save_data['health']
		hunger = save_data['hunger']
		poop = save_data['poop']
		fun = save_data['fun']
		money = save_data['money']
		species = save_data['spieces']
		born_date = save_data['age']
		cat_traits = save_data['cat_level']
		dog_traits = save_data['dog_level']
		deer_traits = save_data['deer_level']
		pig_traits = save_data['pig_level']
		bird_traits = save_data['bird_level']
		poop_count = save_data['poop_count']
		
		if (poop_count > 0):
			add_saved_poops()
		
		var now = OS.get_unix_time()
		var elapsed_time = now - save_data['save_time']
		
		if (hunger + ceil(elapsed_time/60) > 100):
			hunger = 100
			health -= ceil(elapsed_time/600)
		else:
			hunger += ceil(elapsed_time/60)
	
	save_game.close()


func give_dog_food():
	var cost = int($Shop/Panel/VBoxContainer/DogFood/Cost.text)
	if (money >= cost):
		if (hunger > 0):
			money -= cost
			dog_traits += 1
			reduce_hunger(10)
			rise_poop(10)
			heal(10)

func give_cat_food():
	var cost = int($Shop/Panel/VBoxContainer/CatFood/Cost.text)
	if (money >= cost):
		if (hunger > 0):
			money -= cost
			cat_traits += 1
			reduce_hunger(10)
			rise_poop(10)
			heal(10)

func give_pig_food():
	var cost = int($Shop/Panel/VBoxContainer/PigFood/Cost.text)
	if (money >= cost):
		if (hunger > 0):
			money -= cost
			pig_traits += 1
			reduce_hunger(10)
			rise_poop(10)
			heal(10)

func give_giraffe_food():
	var cost = int($Shop/Panel/VBoxContainer/BirdFood/Cost.text)
	if (money >= cost):
		if (hunger > 0):
			money -= cost
			bird_traits += 1
			reduce_hunger(10)
			rise_poop(10)
			heal(10)

func give_deer_food():
	var cost = int($Shop/Panel/VBoxContainer/DeerFood/Cost.text)
	if (money >= cost):
		if (hunger > 0):
			money -= cost
			deer_traits += 1
			reduce_hunger(10)
			rise_poop(10)
			heal(10)

func reduce_hunger(x):
	if (hunger - x < 0):
		hunger = 0
	else:
		hunger -= x

func rise_poop(x):
	if (poop + x > 100):
		poop = 100
	else:
		poop += x

func check_poop():
	if (poop == 100):
		poop = 0
		var new_poop = poop_node.instance()
		new_poop.set_position(Vector2($Blob.position.x, $Blob.position.y + 10))
		poop_count += 1
		add_child(new_poop)

func add_saved_poops():
	for poop in range(0, poop_count):
		var new_poop = poop_node.instance()
		new_poop.set_position(Vector2(poop*33+32, $Blob.position.y + 10))
		add_child(new_poop)

func heal(x):
	if (health + x > 100):
		health = 100
	else:
		health += x

func go_to_work():
	close_all_popups('WorkPopup')
	$WorkPopup.show()

func close_work_popup():
	$WorkPopup.hide()

func mine():
	if (hit_count < 3):
		if (!(fun - 5 < 0)):
			if (hunger + 5 >= 100):
				health -= 5
				hunger = 100
			else:
				hunger += 5
			money += 5
			fun -= 5
			
			var hit_node = hit.instance()
			hit_node.set_position(hit_positions[hit_count])
			$WorkPopup/Panel.add_child(hit_node)

func close_pet_popup():
	$PetPopup.hide()

func open_pet_popup():
	close_all_popups('PetPopup')
	$PetPopup.show()

func pet_slime():
	if (heart_count < 3):
		if (fun + 5 >= 100):
			fun = 100
		else:
			fun += 5
			
		if (hunger + 1 >= 100):
			health -= 1
			hunger = 100
		else:
			hunger += 1
		
		var heart_node = heart.instance()
		heart_node.set_position(heart_positions[heart_count])
		$PetPopup/PetPanel.add_child(heart_node)
