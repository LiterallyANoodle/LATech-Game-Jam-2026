extends SubViewport

@onready var timer: Timer = $Timer
@onready var demon_follower: PathFollow2D = $Path2D/PathFollow2D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	demon_follower.progress_ratio = 1 - (timer.time_left / constants.ROUND_TIME)
