extends KinematicBody

var dead = false

func _ready():
	$AnimationPlayer.play("Idle")

func _physics_process(_delta):
	pass
	
func die():
	queue_free()

func _on_AnimationPlayer_animation_finished(anim_name):
	$AnimationPlayer.play("Idle")
