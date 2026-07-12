extends StaticBody3D

func abrir_puerta():
	var tween = create_tween()
	tween.tween_property(self, "position:y", position.y - 8.0, 2.0)
