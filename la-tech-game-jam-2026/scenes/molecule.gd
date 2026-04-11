class_name Molecule extends Node2D

func move(direction: Vector2) -> void:
	direction = direction * constants.GRID_SIZE
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "position", self.position + direction, constants.MOVE_TIME) \
		.set_trans(Tween.TRANS_CUBIC)
