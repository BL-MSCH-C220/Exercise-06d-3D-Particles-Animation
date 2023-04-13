# Exercise-06d-3D-Particles-Animation

Exercise for MSCH-C220

A demonstration of this exercise is available at [https://youtu.be/0CytaWMH64E](https://youtu.be/0CytaWMH64E)

This exercise is a chance to play with Godot's 3D Particles and 3D Sprites. We will be doing a little more animating. Also, you will have a chance to export a game as a finished product.

Fork this repository. When that process has completed, make sure that the top of the repository reads [your username]/Exercise-06d-3D-Particles-Animation. *Edit the LICENSE and replace BL-MSCH-C220 with your full name.* Commit your changes.

Clone the repository to a Local Path on your computer.

Open Godot. Import the project.godot file and open the "FPS" project.

In res://Game.tscn, I have provided a starting place for the exercise: the scene contains a FPS character in an empty warehouse with five moving targets. Your gun can shoot those targets, but you will need to provide feedback to the player.

First, we need to create a scene for the explosion. In Scene->New Scene, Create Root Node: 3D Scene. Name the Spatial node "Explosion". Right-click and Add Child Node. Select AnimatedSprite3D. In the Inspector panel, AnimatedSprite3D->Frames->New Sprite Frames, and then edit the newly created SpriteFrames.

In the AnimationFrames panel, select the "Add Frames from a Sprite Sheet" button, and select res://Assets/Explosion.png. The grid is 8 x 8; select all the frames and press the "Add 64 Frame(s)" Button. Set Speed(FPS)=60 and Loop=Off. Return to the AnimatedSprite3D Inspector panel.

Set SpriteBase3D->Offset->y to 25. Set Flags->Billboard to Enabled, and Double Sided=Off. 

Now, right-click on the Explosion node and Add Child Node. Select Particles. Select the new Particles node.

In the Inspector, set 
 - Particles->Amount: 40
 - Time->Lifetime: 0.75
 - Time->One Shot->On
 - Time->Randomness:1
 - Drawing->Local Coords: Off
 - Drawing->Draw Order: View Depth
 - Draw Passes->Pass 1: New Quad Mesh

Edit the New Quad Mesh: PrimitiveMesh->Material: New Spatial Material. 

Edit that Material: 

 - Flags->Transparent: On
 - Flags->Unshaded: On
 - Vertex Color->Use as Albedo: On
 - Parameters->Blend Mode: Add
 - Parameters->Billboard Mode: Particle Billboard
 - Particles Anim->H Frames: 6
 - Particles Anim->V Frames: 5
 - Particles Anim->Loop: On
 - Albedo->Texture: res://Assets/Smoke.png

Back in the Inspector for the Particles node, Process Material->Process Material: New Particles Material. Edit that material:

 - Trail->Divisor: 6
 - Emission Shape->Shape: Sphere
 - Emission Shape->Sphere Radius: 0.8
 - Direction->Direction: 0,1,0
 - Direction->Spread: 0
 - Gravity->Gravity: 0,0,0
 - Initial Velocity->Velocity: 5
 - Initial Velocity->Velocity Rand: 0.1
 - Angular Velocity->Velocity: 40
 - Angular Velocity->Velocity Rand: 1
 - Linear Accel->Accel: 4
 - Linear Accel->Accel Random: 1
 - Angle->Angle: 360
 - Angle->Angle Random: 1
 - Scale->Scale Random: 0.8
 - Scale->Scale Curve, New Curve Texture (edit it so it starts at 0, goes to 1 about a third of the way and then goes back to zero)
 - Color->Color Ramp: new Gradient Texture (edit it so it starts at #212529 and goes to #ced4da)
 - Animation->Speed: 1
 - Animation->Offset: 1
 - Animation Offset Random: 1

Attach a script to the Explosion node, res://Explosion/Explosion.gd:

```
extends Spatial

func _ready():
	$AnimatedSprite3D.play()
	$Particles.emitting = true

func _physics_process(_delta):
	if not $AnimatedSprite3D.playing and not $Particles.emitting:
		queue_free()

```

Then save the scene as res://Explosion/Explosion.tscn

In res://Player/Player.gd, add the following after line 3:
```
onready var Explosion = load("res://Explosion/Explosion.tscn")
onready var Explosions = get_node("/root/Game/Explosions")
```

And then add the following after (what is now) line 27:
```
				var explosion = Explosion.instance()
				Explosions.add_child(explosion)
				explosion.global_transform.origin = $Pivot/RayCast.get_collision_point()
```

Now, we will add an Enemy to the scene. Open res://Enemy/Enemy.tscn

Select the Skeleton node, and add a child BoneAttachment. In the Inspector, set the Bone Name to right_hand_thumb_1.

As a child of the BoneAttachment, add a new MeshInstance node. Rename it Knife. Its Mesh should be set to res://Assets/knife_smooth.obj.

The knife will need to be tranformed. Set its Translation to (0.035, 0.3, -0.1). Rotate it to (-4, 14, -18), and scale it to (20,20,20).

Edit the Enemy's script, res://Enemy/Enemy.gd. Replace the `_physics_process`, `die`, and `_on_animationPlayer_animation_finished` methods with the following:

```
func _physics_process(_delta):
    if not dead:
        if $AnimationPlayer.current_animation == "Idle" and randf() < 0.01:
            $AnimationPlayer.play("Attack")

func die():
    if not dead:
        $AnimationPlayer.play("Death")
        dead = true

func _on_AnimationPlayer_animation_finished(anim_name):
    if anim_name != "Death":
        $AnimationPlayer.play("Idle")

```

Save the Enemy scene and return to the Game scene.

Instance res://Enemy/Enemy.tscn as a child of the Game node. Translate the enemy to (9, -3, -4), rotate it to (0, -60, 0), and scale it to (1.5,1.5,1.5). Make sure the enemy is added to the "target" group.

Run the game. You should be able to shoot the targets and the enemy.

When you are happy with the result, go to Project->Export. Tap Add… and then select Mac OSX. You will need to Add an Export Template for Godot 3.5. You will also need to set up an Identifier: com.c220.project should be sufficient. Otherwise, the default settings should work; export the project as project.dmg. If Godot tells you to download a template or other resources, follow those steps until you are able to export the file.

If you are not using a Mac, feel free to export other project types to test. 

Quit Godot. In GitHub desktop, add a summary message, commit your changes and push them back to GitHub. If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (https://github.com/[username]/Exercise-06d-3D-Particles-Animation) on Canvas.

The final state of the file should be as follows (replacing the "Created by" information with your name):
```
# Exercise-06d-3D-Particles-Animation

Exercise for MSCH-C220

An exploration of Godot's 3D Particles and 3D Sprites.

## Implementation

Built using Godot 3.5

Exported for MacOS as project.dmg

## References

The blaster and target models are from the [Blaster Kit](https://kenney.nl/assets/blaster-kit) at kenney.nl.

The knife model is from the [Weapon Pack](https://kenney.nl/assets/weapon-pack), and the crosshair is from the [Shooting Gallery](https://kenney.nl/assets/shooting-gallery) set at kenney.nl.

The skybox was downloaded from [HDRIhaven.com](https://hdrihaven.com/hdri/?c=indoor&h=empty_warehouse_01).

The smoke particle assets were downloaded from [opengameart.org](https://opengameart.org/sites/default/files/Smoke30Frames_0.png)

The explosion animation was also downloaded from [opengameart.org](https://opengameart.org/content/explosion-sheet)

The enemy character was downloaded from [https://github.com/BL-MSCH-C220/3D-Character](https://github.com/BL-MSCH-C220/3D-Character).

## Future Development

None

## Created by 

Jason Francis
```
