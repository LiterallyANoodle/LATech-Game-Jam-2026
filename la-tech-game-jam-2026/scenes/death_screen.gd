extends Control


func _ready() -> void:
	# Keep hidden at start
	visible = false
	# Connect to signal
	SignalBus.WIZARD_DIED.connect(_on_wizard_died)

func _on_wizard_died() -> void:
	visible = true
	modulate.a = 0
	var tween: Tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.5) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
