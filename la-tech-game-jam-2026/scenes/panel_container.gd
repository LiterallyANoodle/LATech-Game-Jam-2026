extends PanelContainer


func _ready() -> void:
	visible = true


func _input(event: InputEvent) -> void:
	# 'ui_focus_next' is the Tab key by default
	if event.is_action_pressed("ui_focus_next"):
		visible = !visible
