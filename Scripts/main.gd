extends Node
var StartingPlayerPosition = Vector2i(102,114)

func _ready():
	$TitleScreen/TitleCamera.make_current()
	$GlobalShadow.hide() #Make sure the menu isn't super dark

func _on_title_screen_new_game():
	$Map.clear() #clear old tilemap
	$Map.GenerateMap() #generate new map
	$TitleScreen.hide() #hide title screen
	$Player/Camera2D.make_current() #switch to player camera
	$GlobalShadow.show() #Make the shadow 

func _on_title_screen_new_pre_built_game(): #Working towards a game mode that has a series of pre-made maps, rather than leaning on the (currently) unstable mapgen
	$Map.clear()#Clear preexisting map
	$TitleScreen.hide() #hide title screen
	get_tree().call_group("Enemy", "queue_free") #Despawn pre-existing enemies
	var LevelOne = preload("res://Levels/level_one.tscn") #I'm literally just learning how to switch scenes, so this doesn't work lmao
	load("res://Levels/level_one.tscn") #Ditto for this line 
	



func _on_player_game_over_signal():
	print("Ope you're dead")
	$Player.position = StartingPlayerPosition #throw the player back in the corner of the map so they aren't insta-ambushed by enemies upon new game start
	$TitleScreen.show()
	$Map.clear()
	$TitleScreen/TitleCamera.make_current()
	$GlobalShadow.hide()
	#get_tree().call_group("Enemy", "queue_free") Despawn pre-existing enemies, fiddling with this currently
