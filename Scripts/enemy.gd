extends CharacterBody2D

@onready var player = $"../Player" #Allows enemies to automatically know who the player is

@onready var nav_agent = $NavigationAgent2D as NavigationAgent2D #use the navigation agent
@onready var enemy = $"."


const speed = 130 #set enemy speed
var seen = false #if the player has been seen
var heard = false #if the player has been heard

func _physics_process(_delta: float):
	if seen or heard == true: #Check if the player has been seen or heard
		var dir = to_local(nav_agent.get_next_path_position()).normalized() #Determining direction
		velocity = dir * speed #Velocity equals direction multiplied by speed
		move_and_slide() #enable movement with move_and_slide function
		$EnemySprite.look_at(player.position) #Have the sprite facing the correct direction while chasing the player
		$Sight.look_at(player.position) #Have the sight raycast directed at the player
		$Sight.rotate(180.6) #BUG for some reason the raycast doesn't actually look at the player, and needs to be offset by 180.7 radians to be where I want it
	if seen and heard == false: #If the player is not seen or heard...
		velocity = Vector2(0,0) #Stop movement to prevent jitters
	

func makepath(): #path making function
	nav_agent.target_position = player.global_position #target position is now equal to player position

func _on_timer_timeout(): #When the path timer times out
	makepath() #When the timer times out, create the next step in the path

func _on_hearing_area_entered(area):
	if area.name == "Noise": #If the enemy's "hearing" area overlaps with the player "noise" area...
		heard = true #set heard to true
		$Timer.start() #pathfinding timer starts

func _on_hearing_area_exited(area):
	if area.name == "Noise": #If the player noise area leaves the enemy hearing area...
		heard = false #No longer hears the player
		$Timer.stop() #Stop the pathfinding process

func sightcheck():
	var seen_object = $Sight.get_collider() #get information on whatever we're colliding with
	if seen_object == player: #Check if it's the player
		seen = true #If it is, we set this to seen
		$Timer.start() #Start pathfinding timer
	else:
		await get_tree().create_timer(1).timeout #Give a full second before the chase starts OR for the chase to end
		seen = false #Set seen status to false
		$Timer.stop() #Stop pathfinding timer



func _on_sight_timer_timeout():
	sightcheck()

