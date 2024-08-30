@tool
extends TileMap
@export var generateMap : bool #gives us a button in the inspector that we can press to return a function to generate terrain
@export var clearMap : bool #Gives us a button to clear the map

@export var mapWidth : int #width of map
@export var mapHeight : int #height of map

@export var terrainSeed : int #lets us set the map to seed in the inspector
@export var light_grass_Threshold : float #threshold for grass tiles
@export var dark_grass_Threshold: float #threshold for dark grass and for obstacles, I guess?
@export var obstacleThreshold : float #threshold for tree obstacles, not currently used

#All of the tiles come from the same tileset, so source_id will be 0. 
var source_id = 0
var light_grass_tiles: Array = [Vector2i(0,0), Vector2i(1,0), Vector2i(2,0), Vector2i(3,0), Vector2i(4,0), Vector2i(5,0), Vector2i(6,0), Vector2i(7,0)]
var dark_grass_tiles: Array = [Vector2i(24,0),Vector2i(25,0),Vector2i(26,0),Vector2i(27,0),Vector2i(28,0),Vector2i(29,0),Vector2i(30,0)]
var obstacle_tiles: Array = [Vector2i(8,8), Vector2i(9,8), Vector2i(10,8), Vector2i(11,8), Vector2i(12,8), Vector2i(13,8), Vector2i(14,8), Vector2i(15,8)]

func _ready():
	pass
	
func _process(delta):
	#The code below is for testing map generation with the Inspector tool
	if generateMap: #if it's on, generate the map and then toggle it off so it isn't constantly generating
		generateMap = false
		GenerateMap()
	if clearMap == true:
		clearMap = false
		clear() #clear tilemap

func GenerateMap():
	clear() #clear out old tilemap
	print("Generating map")
	var noise = FastNoiseLite.new() #Instancing a new FastNoiseLite image
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH #assign type of noise map we create
	var rng = RandomNumberGenerator.new() #create a random number
	terrainSeed = rng.randi() #Going to see if I can just force the terrainSeed to always be randomly generated when the button is pressed
	if terrainSeed == 0 : #If the terrainSeed is zero, generate a random seed
		terrainSeed = rng.randi()  #generate the number
	else:
		noise.seed = terrainSeed #sets the nosie seed to our randomly generated number
		
	#Check each pixel of the noise image and see what its value is, between -1 and 0. Then we implement thresholds that determine the terrain being generated.
	
	for x in range(mapWidth):
		for y in range(mapHeight):
			if noise.get_noise_2d(x,y) < dark_grass_Threshold: #if it's more than the grassThreshold
				var rng_obstacle = obstacle_tiles.pick_random()
				set_cell(0, Vector2i(x, y), 0, rng_obstacle) #this SHOULD create the obstacle tile
			elif noise.get_noise_2d(x,y) < light_grass_Threshold:
				var rng_dark_grass = dark_grass_tiles.pick_random()
				set_cell(0, Vector2i(x, y), 0, rng_dark_grass)
			else:
				var rng_grass = light_grass_tiles.pick_random() #randomly picks one of the tiles in the ground_tiles set
				set_cell(0, Vector2i(x,y), 0, rng_grass)#make grass tile
			print(noise.get_noise_2d(x,y)) #Can use this to print out the values of the noise profile
	
	#Code below for generating the borders of the map
	for x in range(mapWidth):
		for y in range(mapHeight):
			if x == 0 or x == 99: #If it's the left or right border
				var rng_obstacle = obstacle_tiles.pick_random()
				set_cell(0, Vector2i(x, y), 0, rng_obstacle) #make obstacle
	for x in range(mapWidth):
		for y in range(mapHeight):
			if y == 0 or y == 59: #if it's the top or bottom border
				var rng_obstacle = obstacle_tiles.pick_random()
				set_cell(0, Vector2i(x, y), 0, rng_obstacle) #make obstacle
