extends Control

var selected_button = 0
var play_pressed = false
var in_menu = true

func _ready():
	$FadeOut/FadeOutAnim.play_backwards("fade_out")


func _input(event):
	if event.is_action_pressed("ui_down") and in_menu:
		selected_button = min(selected_button + 1, 2)
		select_button()
	if event.is_action_pressed("ui_up") and in_menu:
		selected_button = max(selected_button - 1, 0)
		select_button()
	if event.is_action_released("ui_accept"):
		match selected_button:
			0:
				_on_PlayButton_pressed()
			1:
				_on_SettingsButton_pressed()
			2:
				_on_Quit_pressed()
	
func select_button():
	if in_menu:
		for btn in $BG/ElementsContainer/Buttons/ButtonsContainer.get_children():
			btn.get_node("Label").hide()
		var btn = $BG/ElementsContainer/Buttons/ButtonsContainer.get_child(selected_button)
		btn.get_node("Label").show()
	


func _on_PlayButton_pressed():
	$BGMAudio.stop()
	play_pressed = true
	$FadeOut/FadeOutAnim.play("fade_out")



func _on_SettingsButton_pressed():
	in_menu = false
	$SettingsAnim.play("switch")
	$BG/ElementsContainer/SettingsRect/ButtonsContainer/BackButton.grab_focus()

func _on_Quit_pressed():
	get_tree().quit()


func _on_FadeOutAnim_animation_finished(anim_name):
	if play_pressed:
		get_tree().change_scene("res://Scenes/World.tscn")


func _on_BackButton_pressed():
	in_menu = true
	$SettingsAnim.play_backwards("switch")
	$BG/ElementsContainer/Buttons/ButtonsContainer/SettingsButton.grab_focus()


func _on_FullScreenButton_pressed():
	var FullscreenButton = $BG/ElementsContainer/SettingsRect/ButtonsContainer/FullScreenButton
	FullscreenButton.text = "Fullscreen Mode: ON" if FullscreenButton.text == "Fullscreen Mode: OFF" else "Fullscreen Mode: ON"
	OS.window_fullscreen = !OS.window_fullscreen


func _on_VolumeSlider_drag_ended(value_changed):
	var VolumeSlider = $BG/ElementsContainer/SettingsRect/ButtonsContainer/VolumeSlider
	AudioServer.set_bus_volume_db(0, VolumeSlider.value)

func _on_MusicSlider_drag_ended(value_changed):
	var MusicSlider = $BG/ElementsContainer/SettingsRect/ButtonsContainer/MusicSlider
	AudioServer.set_bus_volume_db(1, MusicSlider.value)
