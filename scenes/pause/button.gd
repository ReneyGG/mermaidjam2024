extends TextureButton

var focus := false

func _ready():
	pass # Replace with function body.

func _on_mouse_entered():
	#get_parent().get_parent().get_node("Hover").play()
	self.scale.x = lerp(self.scale.x, 1.05, 1.0)
	self.scale.y = lerp(self.scale.y, 1.05, 1.0)

func _on_mouse_exited():
	self.scale.x = lerp(self.scale.x, 1.0, 1.0)
	self.scale.y = lerp(self.scale.y, 1.0, 1.0)
