# 该类是工具类，用于编写会复用的静态方法
extends Node
class_name Util

# 节点居中
static func node_center(node: Node) -> void:
	node.position = (Vector2(node.get_window().size) - node.size) / 2

# 将纹理的指定颜色视为底色，转换成透明色
static func transparent_conversion_image(image: Image, transparent_color: Array) -> Image:
	# 检查并更改图像格式为RGBA8以支持alpha通道
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)
	image.decompress()
	# 遍历像素转换指定transparent_color为透明
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			# 遍历需要处理的Color数组，匹配则处理后跳出
			for c in transparent_color:
				if color.is_equal_approx(c):
					color.a = 0
					image.set_pixel(x, y, color)
					break
	return image

# 重载transparent_conversion_image
static func transparent_conversion_texture(texture: Texture, transparent_color: Array) -> ImageTexture:
	var image: Image = texture.get_image()
	transparent_conversion_image(image, transparent_color)
	return ImageTexture.create_from_image(image)

# 用于打包后也能动态读取资源文件
static func dynamic_load_resource(path: String) -> Resource:
	# 检查文件是否存在
	if not FileAccess.file_exists(path):
		push_error("PNG文件不存在: " + path)
		return null
	# 加载图像
	var image = Image.load_from_file(path)
	if image == null:
		push_error("无法加载PNG图像: " + path)
		return null
	# 创建纹理
	var texture = ImageTexture.create_from_image(image)
	return texture
