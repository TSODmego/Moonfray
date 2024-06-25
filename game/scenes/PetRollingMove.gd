extends Sprite2D

@export var scroll_speed := 100 # 滚动速度
@export var frame_width := 32 # 每一帧的宽度

var scroll_offset := 0.0 # 滚动偏移量

func _process(delta):
	scroll_offset += scroll_speed * delta
	
	if scroll_offset >= frame_width:
		scroll_offset -= frame_width
	
	# 设置Sprite2D的区域
	region_rect.position.x = int(scroll_offset)
	region_rect.size.x = frame_width
