@tool
extends Node3D

@export_group("Floor Grid")
@export var grid_color:Color = Color("#d3c6aa")
@export var grid_box_color:Color = Color.WHITE_SMOKE
@export var x_size:int = 200
@export var y_size:int = 200 
@export var subdivision:Vector2i = Vector2i(20,20)
@export_group("")

@export_group("XYZ")
@export var thickness:float = 0.3
@export var arrow_size:float = 0.06
@export_enum("Square","Sphere") var point_type:int = 1
@export var point_size:float = 0.75
@export_subgroup("X")
@export var x_length:int = 11
@export var x_color:Color = Color("#d53d1d")
@export var x_arrow_size:float = 2

@export_subgroup("Y")
@export var y_length:int = 11
@export var y_color:Color = Color("#99f249")
@export var y_arrow_size:float = 2

@export_subgroup("Z")
@export var z_length:int = 11
@export var z_color:Color = Color("#3c78f6")
@export var z_arrow_size:float = 2
@export_group("")

@export_group("Labels")
@export var label_size:int = 1200
@onready var x_labels = $Labels/X
@onready var y_labels = $Labels/Y
@onready var z_labels = $Labels/Z

@onready var a = $A
@onready var b = $B

# XLabels
@onready var x_labels_parallel_side_offset = -5
@onready var x_label_spacing = x_size/float(subdivision.x)

# YLabels
@onready var y_labels_parallel_side_offset = -5
@onready var y_label_spacing = y_size/float(subdivision.y)

# ZLabels
@onready var z_labels_parallel_side_offset = -5
@onready var z_label_spacing = y_size/float(subdivision.y)


func labels_initializer(direction:Vector3,color,parallel_side_offset):
	#We add this for the ready call to start the labels for each axis
	if abs(direction) == Vector3.RIGHT:
		#X labels

		#Clears the residual labels before adding
		for clear_label in x_labels.get_children():
			clear_label.queue_free()
		for i in range(-x_length+1,x_length):
			var label = load("res://Label.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			x_labels.add_child(label)
			label.name = "X" + str(i)
			label.set_owner(get_tree().get_edited_scene_root())

			var x_label_pos = Vector3(i* x_label_spacing,0 ,x_labels_parallel_side_offset)
			label.text = str(i)
			label.font_size = label_size
			label.position = x_label_pos

			label.modulate = color

	elif abs(direction) == Vector3.UP:
		#Y labels

		#Clears the residual labels before adding 
		for clear_label in y_labels.get_children():
			clear_label.queue_free()
		for i in range(-y_length+1,y_length):
			var label = load("res://Label.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			y_labels.add_child(label)
			label.name = "Y" + str(i)
			label.set_owner(get_tree().get_edited_scene_root())

			var y_label_pos = Vector3(y_labels_parallel_side_offset, i* y_label_spacing,0)
			label.text = str(i)
			label.font_size = label_size
			label.position = y_label_pos

			label.modulate = color

	elif abs(direction) == Vector3.BACK:
		#Z labels

		#Clears the residual labels before adding 
		for clear_label in z_labels.get_children():
			clear_label.queue_free()
		for i in range(-z_length+1,z_length):
			var label = load("res://Label.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			z_labels.add_child(label)
			label.name = "Z" + str(i)
			label.set_owner(get_tree().get_edited_scene_root())

			var z_label_pos = Vector3(0,z_labels_parallel_side_offset, i* z_label_spacing)
			label.text = str(i)
			label.font_size = label_size
			label.position = z_label_pos

			label.modulate = color




# Called when the node enters the scene tree for the first time.
func _ready():
	labels_initializer(Vector3.UP,y_color,y_labels_parallel_side_offset)
	labels_initializer(Vector3.BACK,z_color,z_labels_parallel_side_offset)
	labels_initializer(Vector3.RIGHT,x_color,x_labels_parallel_side_offset)


	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var points = PackedVector3Array()
	
	# for i in range(0,y_length):
	# 	if y_labels.get_child_count() < y_length*2:
	# 		var label = load("res://Label.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	# 		y_labels.add_child(label)
	# 		#label.global_position = pos
	# 		#label.text = str(i)
	# 		label.name = "Y + " + str(i)
	# 		label.set_owner(get_tree().get_edited_scene_root())
	
	# var pos = Vector3(-5,-y_length * (y_size/float(subdivision.y)),0)
	# var spacing = Vector3.UP * y_size/float(subdivision.y)
	# var y_count = -y_length
	# var y_label_properties = y_labels.get_children()
	# for y_point:Label3D in y_label_properties:
	# 	y_point.global_position = pos
	# 	y_point.text = str(y_count)
	# 	y_point.font_size = label_size
	# 	pos = pos + spacing
	# 	y_count = y_count + 1
		
	# 	pass
	#$Labels.get_children()[0].name
	# Floor Grid
	DebugDraw3D.draw_box(Vector3.ZERO,Quaternion(),Vector3(x_size,200,y_size),grid_box_color,true)
	DebugDraw3D.draw_grid(Vector3.ZERO,Vector3(1,0,0)*x_size,Vector3(0,0,1)*y_size,subdivision,grid_color)
	
		
	#DebugDraw3D.draw_ray(Vector3.ZERO,Vector3.RIGHT,z_length,z_color)
	var line_thickness = DebugDraw3D.new_scoped_config().set_thickness(thickness).set_hd_sphere(true).set_center_brightness(1)
	#Draw Z Line
	draw_main_lines(Vector3.FORWARD,z_length,z_color)
	
	#Draw Y Line
	draw_main_lines(Vector3.UP,y_length,y_color)
	
	#Draw X Line
	draw_main_lines(Vector3.RIGHT,x_length,x_color)
	var screenPos = get_window()
	DebugDraw2D.set_text("Screen Position", screenPos)
	
	line_thickness = DebugDraw3D.new_scoped_config().set_thickness(0.01).set_hd_sphere(true).set_center_brightness(1)
	DebugDraw3D.draw_grid(Vector3.ZERO,Vector3(1,0,0)*x_size,Vector3(0,0,1)*y_size,subdivision*5,grid_color)


	# var aPos = a.global_position
	# aPos = aPos.normalized()
	
	# var bPos = b.global_position
	# bPos = bPos.normalized()

	# var dot = aPos.dot(bPos)
	# DebugDraw2D.set_text("DOT", dot)
	
	pass
	


func draw_main_lines(direction:Vector3,length,color):
	var points = PackedVector3Array()
	var pos = Vector3.ZERO
	var spacing = Vector3.ZERO
	if abs(direction) == Vector3.RIGHT:
		spacing = direction * x_size/float(subdivision.x)
	elif abs(direction) == Vector3.BACK:
		spacing = direction * y_size/float(subdivision.y)
	elif abs(direction) == Vector3.UP:
		spacing = direction * y_size/float(subdivision.y)
		pass
	for i in range(length):
		points.append(pos)
		points.append(-pos)
		pos = pos + spacing
		
	DebugDraw3D.draw_arrow(Vector3.ZERO,pos,color,arrow_size)			
	DebugDraw3D.draw_arrow(Vector3.ZERO,-pos,color,arrow_size)			
	DebugDraw3D.draw_point_path(points,point_type,point_size,color,color)
	
	DebugDraw2D.set_text("X Direction", x_size/float(subdivision.x))
	DebugDraw2D.set_text("Y Direction", y_size/float(subdivision.y))
