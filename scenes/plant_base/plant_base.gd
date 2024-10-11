extends Node2D

@export var texture : Texture
@export var type : String

func _ready():
	$Sprite2D.texture = texture

func pick():
	pass
 
func drop():
	pass

func harvest():
	queue_free()
