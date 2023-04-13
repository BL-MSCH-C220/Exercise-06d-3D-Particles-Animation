extends StaticBody

var speed = 0
var y_range = 0

func _ready():
	randomize()
	speed = (randf() * 0.05) + 0.001
	y_range = randi() % 10


func _physics_process(_delta):
	transform.origin.y += speed
	if transform.origin.y >= y_range:
		speed = abs(speed)*-1
	if transform.origin.y <= -y_range:
		speed = abs(speed)		


func die():
	queue_free()
