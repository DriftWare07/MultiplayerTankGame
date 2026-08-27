extends Polygon2D

@onready var base = get_parent() as Tank
@export var primary : PrimaryWeapon
@export var secondary : SecondaryWeapon

var primaryCooldownTimer = 0.0
var secondaryCooldownTimer = 0.0
var mag = 0

const muzzleFlash = preload("res://scenes/muzzle.tscn")

signal fired
func _ready() -> void:
	reload()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if primaryCooldownTimer < 0.0 and mag > 0 and Input.is_action_pressed("PrimaryFire"):
		var p = primary.bullet.instantiate() as Bullet
		p.my_owner = base
		get_tree().root.add_child(p)
		p.global_position = global_position
		p.global_rotation = global_rotation
		p.move_local_x(10)
		
		var mf = muzzleFlash.instantiate() as Node2D
		add_child(mf)
		mf.move_local_x(10)
		
		
		base.apply_impulse((Vector2.UP*-primary.knockback*100).rotated(deg_to_rad(rotation_degrees+base.rotation_degrees+90)))
		
		primaryCooldownTimer = primary.fire_delay
		mag -= 1
		if mag <= 0:
			base.reload(primary.reload_time)
		fired.emit()
		screenFreeze()
	
	if secondaryCooldownTimer < 0.0 and Input.is_action_pressed("SecondaryFire"):
		var p = secondary.bullet.instantiate() as Bullet
		p.my_owner = base
		get_tree().root.add_child(p)
		p.global_position = global_position
		p.global_rotation = global_rotation
		secondaryCooldownTimer = secondary.fire_delay
		p.rotation_degrees += randf_range(-secondary.spread,secondary.spread)
	
	primaryCooldownTimer -= delta
	secondaryCooldownTimer -= delta
	
	look_at(get_global_mouse_position())

func screenFreeze(time = 0.15):
	Engine.time_scale = 0
	await get_tree().create_timer(time, true, false,true).timeout
	Engine.time_scale = 1.0

func reload():
	mag = primary.max_mag
