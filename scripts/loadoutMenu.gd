extends Control

@onready var primaryWeaponMenu = $Panel/primaryWeaponSelector
@onready var secondaryWeaponMenu = $Panel/secondaryWeaponSelector2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(0, Global.primaryWeapons.size()):
		primaryWeaponMenu.add_item(Global.primaryWeapons[i].weapon_name)
	
	for i in range(0, Global.secondaryWeapons.size()):
		secondaryWeaponMenu.add_item(Global.secondaryWeapons[i].weapon_name)
	
	primaryWeaponMenu.item_selected.connect(selectPrimary)
	secondaryWeaponMenu.item_selected.connect(selectSecondary)

func selectPrimary(option: int):
	Global.localPlayer.turret.loadTheseWeapons(option, -1)

func selectSecondary(option: int):
	Global.localPlayer.turret.loadTheseWeapons(-1, option)
