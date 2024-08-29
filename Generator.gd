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

# Called when the node enters the scene tree for the first time.
func _ready():
		
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var points = PackedVector3Array()
	
	for i in range(0,y_length):
		if y_labels.get_child_count() < y_length*2:
			var label = load("res://Label.tscn").instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
			y_labels.add_child(label)
			#label.global_position = pos
			#label.text = str(i)
			label.name = "Y + " + str(i)
			label.set_owner(get_tree().get_edited_scene_root())
	
	var pos = Vector3(0,-y_length * (y_size/float(subdivision.y)),0)
	var spacing = Vector3.UP * y_size/float(subdivision.y)
	var y_count = -y_length
	var y_label_properties = y_labels.get_children()
	for y_point:Label3D in y_label_properties:
		y_point.global_position = pos
		y_point.text = str(y_count)
		y_point.font_size = label_size
		pos = pos + spacing
		y_count = y_count + 1
		
		pass
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
