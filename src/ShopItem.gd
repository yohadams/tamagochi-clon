extends TextureButton


export var label:String = ''
export var cost:int = 0
export var effect:String = ''
export var icon:Texture = null


func _ready():
	$Name.text = label
	$Cost.text = str(cost)
	$Effect.text = effect
	$Icon.texture = icon
