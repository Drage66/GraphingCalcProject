extends Camera3D
@onready var cam_pivot:Node3D = get_parent()

@onready var cam_rotate_sensitivity = 0.01
@onready var cam_zoom_speed = 4.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	look_at(Vector3.ZERO)
	pass


func _input(event):
	if event is InputEventMouseMotion:
		if Input.is_action_pressed("CameraRotate"):
			cam_pivot.rotate_y(event.relative.x*cam_rotate_sensitivity)
			cam_pivot.rotate_x(event.relative.y*cam_rotate_sensitivity)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			global_transform.origin += global_transform.origin.direction_to(Vector3.ZERO)*cam_zoom_speed
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			global_transform.origin -= global_transform.origin.direction_to(Vector3.ZERO)*cam_zoom_speed
			pass