extends Node

# Space between grid spaces in pixels
const GRID_SIZE: int = 64
const EXAMPLE_WINDOW: int = 450
const EXAMPLE_MAX_SIZE: int = 4

# How long it takes for player/blocks to move one grid tile
const MOVE_TIME: float = 0.2

const ROUND_TIME: float = 120.0

# Atom textures
@onready var elements_tex: Texture2D = load("res://assets/Elements.png")
@onready var air_tex: AtlasTexture = AtlasTexture.new()
@onready var fire_tex: AtlasTexture = AtlasTexture.new()
@onready var earth_tex: AtlasTexture = AtlasTexture.new()
@onready var water_tex: AtlasTexture = AtlasTexture.new()

# level 1 atoms
@onready var iron_tex: AtlasTexture = AtlasTexture.new()
@onready var copper_tex: AtlasTexture = AtlasTexture.new()

# level 2 atoms
@onready var gold_tex: AtlasTexture = AtlasTexture.new()
@onready var silver_tex: AtlasTexture = AtlasTexture.new()

# level 3 atoms
@onready var quintessence_tex: AtlasTexture = AtlasTexture.new()

func _ready() -> void:
	# level 0
	air_tex.set_atlas(elements_tex)
	air_tex.region = Rect2(5 * 16, 0, 16, 16)
	fire_tex.set_atlas(elements_tex)
	fire_tex.region = Rect2(4 * 16, 0, 16, 16)
	earth_tex.set_atlas(elements_tex)
	earth_tex.region = Rect2(7 * 16, 0, 16, 16)
	water_tex.set_atlas(elements_tex)
	water_tex.region = Rect2(6 * 16, 0, 16, 16)
	
	# level 1
	iron_tex.set_atlas(elements_tex)
	iron_tex.region = Rect2(1 * 16, 0, 16, 16)
	copper_tex.set_atlas(elements_tex)
	copper_tex.region = Rect2(3 * 16, 0, 16, 16)
	
	# level 2
	gold_tex.set_atlas(elements_tex)
	gold_tex.region = Rect2(2 * 16, 0, 16, 16)
	silver_tex.set_atlas(elements_tex)
	silver_tex.region = Rect2(8 * 16, 0, 16, 16)
	
	# level 3
	quintessence_tex.set_atlas(elements_tex)
	quintessence_tex.region = Rect2(0 * 16, 0, 16, 16)
