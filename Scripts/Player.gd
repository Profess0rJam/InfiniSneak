extends CharacterBody2D

var screen_size  #size of the game window
@export var player_speed = 100 #Player speed
var sneaking : bool = false #set boolean for whether we're sneaking or not
var sprinting : bool = false #set boolean for whether or not we're sprinting
var stamina : float = 100 #stamina amount that players have
@onready var player_noise = $Noise/PlayerNoise
signal InvalidSpawnSignal
signal GameOverSignal
var original_noise =  Vector2(1,1)

func _ready():
	screen_size = get_viewport_rect().size #get the size of the screen and assign it to screen_size
	print("Screen size is" + str(screen_size))
func _physics_process(delta):
	var velocity = Vector2(0,0) #set player starting velocity
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("sneak"):
			sneaking = true
	if Input.is_action_pressed("sprint"):
		if stamina > 0 and velocity.length() > 0: #if we're sprinting and we're moving
			stamina -= 0.5 #decrease stamina by one
			sprinting = true #set sprinting to true
	
	if sneaking == true: #if we're sneaking, divide player speed
		if velocity.length() > 0:
			velocity = velocity.normalized() * (player_speed / 2) #normalize sets velocity to 1, which stops diagonal movement from causing higher velocity
	elif sprinting == true: #if we're sprinting, multiply player speed
		if velocity.length() > 0:
			velocity = velocity.normalized() * (player_speed * 2) #normalize sets velocity to 1, which stops diagonal movement from causing higher velocity
	else:
		if velocity.length() > 0:
			velocity = velocity.normalized() * player_speed  #normalize sets velocity to 1, which stops diagonal movement from causing higher velocity
			
			

	if sprinting == true and velocity.length() > 0: #If the player is sprinting and we're actually moving
		player_noise.scale *= 2 #double the size of the noise collider
		if player_noise.scale >= Vector2(2,2): #If the noise collider is twice the default or larger
			player_noise.scale = Vector2(2,2) #reset it to twice the size
	elif sprinting == false and sneaking == true: #If we aren't sprinting AND we are sneaking AND we are moving
		player_noise.scale /= 2 #half the scale of the noise collider
		if player_noise.scale <= Vector2(0.5,0.5): #If it's lower than half of the default
			player_noise.scale = Vector2(0.5,0.5) #reset it to half of the default
	else:
			player_noise.scale = original_noise #Every frame check to see if we've stopped crouching or sprinting to set it back to the original
			
	if velocity.length() == 0: #if we aren't moving
		if stamina < 100: #Make sure stamina isn't going above the cap
			stamina += 0.5 #start to recover stamina
		
			
	position += velocity * delta #updates position each frame
	#position = position.clamp(Vector2(0,0), screen_size) #"clamps" character to a limited area. In this case, the screen
	sneaking = false #every frame, reset sneak status to false unless they're holding the button down
	sprinting = false #every frame, reset sprint status to false unless they're holding the button down
	move_and_slide()
	
func _process(delta):
	$StaminaBar.set_value(stamina) #Update stamina display
	





func _on_detector_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.name == "GameOverCollider":
		GameOverSignal.emit()
