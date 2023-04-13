extends KinematicBody

onready var Camera = $Pivot/Camera

var gravity = -30
var max_speed = 8
var mouse_sensitivity = 0.002
var mouse_range = 1.2
var orig_crosshair = Vector3.ZERO

var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	orig_crosshair = $Pivot/Crosshair.transform.origin

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		$Pivot.rotate_x(event.relative.y * mouse_sensitivity)
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Pivot.rotation.x = clamp($Pivot.rotation.x, -mouse_range, mouse_range)

func _physics_process(_delta):
	$Pivot/Laser.transform.origin.z = 52.0
	$Pivot/Laser.scale.y = 100.0
	$Pivot/Crosshair.transform.origin = orig_crosshair
	$Pivot/Laser.hide()
	if $Pivot/RayCast.is_colliding():
		var target = $Pivot/RayCast.get_collider()
		var distance = float(transform.origin.distance_to(target.transform.origin))
		$Pivot/Crosshair.translation.z = distance-2
		$Pivot/Laser.transform.origin.z = distance/2.0
		$Pivot/Laser.scale.y = distance
	if Input.is_action_pressed("shoot"):
		$Pivot/Laser.show()
		if $Pivot/RayCast.is_colliding():
			var target = $Pivot/RayCast.get_collider()
			if target.is_in_group("target"):
				target.die()
