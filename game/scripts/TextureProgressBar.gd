extends TextureProgressBar


@onready var player = $"../../Player"


func _ready():
	player.healthChanged.connect(update)
	update()

func update():
	value = player.currentHealth * 100 / player.MAX_HEALTH
