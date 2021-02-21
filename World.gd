extends Node2D


func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_just_released("ui_fullscreen"):
		OS.set_window_fullscreen(!OS.window_fullscreen)
	if Input.is_action_just_released("ui_quit"):
		get_tree().quit(0)
