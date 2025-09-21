extends AudioStreamPlayer2D

func _ready():
	get_tree().get_root().add_child(self)
	self.owner = null
