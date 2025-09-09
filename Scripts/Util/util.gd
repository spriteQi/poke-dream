# 该类是工具类，用于编写会复用的静态方法
extends Node
class_name Util

# 将纹理的指定颜色视为底色，转换成透明色
static func transparent_conversion(image: Image, transparent_color: Color) -> Image:
	# 检查并更改图像格式为RGBA8以支持alpha通道
	if image.get_format() != Image.FORMAT_RGBA8:
		image.convert(Image.FORMAT_RGBA8)
	image.decompress()
	# 遍历像素转换指定transparent_color为透明
	for x in range(image.get_width()):
		for y in range(image.get_height()):
			var color = image.get_pixel(x, y)
			if color.is_equal_approx(transparent_color):
				color.a = 0
				image.set_pixel(x, y, color)
	return image
