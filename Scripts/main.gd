extends Node



func _ready():
	$Camera2D/UI/StaminaBar.set_value($Player.stamina)#Update stamina amount

func _on_player_stamchange(): #Update 
	$Camera2D/UI/StaminaBar.set_value($Player.stamina) #Update stamina amount
	

func _process(delta):
	$Camera2D.position = $Player.position
