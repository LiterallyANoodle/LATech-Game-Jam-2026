extends RichTextLabel


func _ready() -> void:
	
	# Clear
	text = ""
	SignalBus.log_event.connect(_on_log_event)
	
	# Init message
	_on_log_event("Game Start.") 
	
func _on_log_event(message: String) -> void:
	# Add a new line with the message and add ">" to begining of message
	# [color] tags work here if you enable 'BBCode Enabled' in the inspector
	append_text("\n> " + message)
	
	await get_tree().process_frame
	
	# Autoscroll to the bottom so we see the newest message
	var scrollbar: VScrollBar = get_v_scroll_bar()
	scrollbar.value = scrollbar.max_value
