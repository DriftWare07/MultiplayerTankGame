extends Entity
class_name Tank

@export var speed = 50.0
@export var crewmates = 3
var mash_progress = 0.1

var reloadtimer = 0.0
var reloading = false
var immobileReload = false

@onready var reloadBar = $CanvasLayer/Control/reloadBar
@onready var reloadText = $CanvasLayer/Control/reloadBar/reloadText
@onready var turret = $turret

var spawnPoint = Vector2.ZERO

signal reloaded
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	super()
	reloaded.connect(turret.reload)
	spawnPoint = position
	
func _enter_tree() -> void:
	#setting auth
	set_multiplayer_authority(name.to_int())
	if !is_multiplayer_authority():
		#things that happen when this tank is NOT the local player
		$CanvasLayer.hide()
		$Camera2D.enabled = false
		$PointLight2D.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !is_multiplayer_authority():
		return
	var dir = Input.get_vector("left", "right","up", "down")
	if dir:
		apply_central_force(dir*speed*delta*100.0)
		var t = dir.angle()-rotation
		#print(t)
		apply_torque(t*2000.0)
		
	if reloading:
		
		reloadBar.show()
		reloadBar.value = reloadtimer
		
		if crewmates >= 3:
			reloadtimer -= delta
			reloadText.text = "Reloading..."
		elif crewmates == 2:
			if Input.is_action_just_pressed("reload"):
				reloadtimer -= mash_progress
			reloadText.text = "Mash R!"
		else:
			if Input.is_action_just_pressed("reload") and !dir:
				reloadtimer -= mash_progress
			reloadText.text = "Stop and Mash R!"
		immobileReload = crewmates < 2
	else:
		reloadBar.hide()
	
	
	if reloading and reloadtimer <= 0.0:
		reloading = false
		reloaded.emit()
	
	$engine.pitch_scale = lerp($engine.pitch_scale, dir.length()+0.1, delta*5.0)

func reload(time = 1.0):
	if reloading: return
	reloadBar.max_value = time
	reloadBar.value = time
	reloading = true
	reloadtimer = time

func die():
	position = spawnPoint
	hp = max_health
