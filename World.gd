extends Node2D

export (PackedScene) var Planet

var BLOCK_SIZE = 100
var prev_block
var rendered_blocks = []
var distance = 0

var planets = {}
var FULL_HEALTH = 1000.0
var health = FULL_HEALTH

func get_planet_per_block():
	return 5

func get_planets(top_left):
	var key = str(top_left)
	if (key in planets):
		return planets[key]
	if top_left[0] == 0 and top_left[1] == 0:
		return []
	var p = []
	for i in range(get_planet_per_block()):
		var r = randi() % int(max(BLOCK_SIZE / 100, 10) + 10)
		var x = randi() % BLOCK_SIZE
		var y = randi() % BLOCK_SIZE
		var position = Vector2(x,y) + top_left
		p.append([position,r])
	planets[key] = p
	return p
	
func render_planets(top_left):
	var key = str(top_left)
	#print('render ', key)
	if !rendered_blocks.has(key):
		rendered_blocks.append(key)
		for p in get_planets(top_left):
			var planet = Planet.instance()
			planet.position = p[0]
			planet.add_to_group('planet_group'+key)
			planet.connect("crashed",self,"_on_Planet_crashed")
			add_child(planet)
		

func free_planets(top_left):
	#print('free ', str(top_left))
	get_tree().call_group("planet_group"+str(top_left), "queue_free")
	rendered_blocks.erase(str(top_left))
	
func get_block(vec):
	return Vector2(floor(vec.x/BLOCK_SIZE) * BLOCK_SIZE, floor(vec.y/BLOCK_SIZE) * BLOCK_SIZE)

func _ready():
	randomize()
	BLOCK_SIZE = int(max(get_viewport().get_visible_rect().size[0], get_viewport().get_visible_rect().size[1]))
	$StartPosition.position = Vector2(BLOCK_SIZE/2, BLOCK_SIZE/2)
	prev_block = get_block($StartPosition.position)
	$Player.position = $StartPosition.position

func update_render_blocks():
	var curr_block = get_block($Player.position)
	$HUD.debug(str(health) + str(curr_block)+' '+str(prev_block)+' '+str($Player.position))
	#print(curr_block, prev_block)
	if str(curr_block) != str(prev_block):
		if curr_block.x > prev_block.x:
			render_planets(curr_block + Vector2(BLOCK_SIZE, 0))
			render_planets(curr_block + Vector2(BLOCK_SIZE, -BLOCK_SIZE))
			render_planets(curr_block + Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block - Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block - Vector2(BLOCK_SIZE, -BLOCK_SIZE))
			free_planets(prev_block - Vector2(BLOCK_SIZE, 0))
		if curr_block.x < prev_block.x:
			render_planets(curr_block - Vector2(BLOCK_SIZE, 0))
			render_planets(curr_block - Vector2(BLOCK_SIZE, -BLOCK_SIZE))
			render_planets(curr_block - Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block + Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block + Vector2(BLOCK_SIZE, -BLOCK_SIZE))
			free_planets(prev_block + Vector2(BLOCK_SIZE, 0))
		if curr_block.y > prev_block.y:
			render_planets(curr_block + Vector2(0,BLOCK_SIZE))
			render_planets(curr_block + Vector2(-BLOCK_SIZE, BLOCK_SIZE))
			render_planets(curr_block + Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block - Vector2(0,BLOCK_SIZE))
			free_planets(prev_block - Vector2(-BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block - Vector2(BLOCK_SIZE, BLOCK_SIZE))
		if curr_block.y < prev_block.y:
			render_planets(curr_block - Vector2(0,BLOCK_SIZE))
			render_planets(curr_block - Vector2(-BLOCK_SIZE, BLOCK_SIZE))
			render_planets(curr_block - Vector2(BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block + Vector2(0,BLOCK_SIZE))
			free_planets(prev_block + Vector2(-BLOCK_SIZE, BLOCK_SIZE))
			free_planets(prev_block + Vector2(BLOCK_SIZE, BLOCK_SIZE))
	prev_block = curr_block

func _process(delta):
	update_render_blocks()
	distance = max(distance, floor(-$Player.position.y/100))
	$HUD.set_score(distance)
	
func prepare_game():
	planets = {}
	get_tree().call_group('planets', 'queue_free')
	var blocks = [
		Vector2(-BLOCK_SIZE,-BLOCK_SIZE),
		Vector2(-BLOCK_SIZE,0),
		Vector2(-BLOCK_SIZE,BLOCK_SIZE),
		Vector2(0,-BLOCK_SIZE),
		Vector2(0,0),
		Vector2(0,BLOCK_SIZE),
		Vector2(BLOCK_SIZE, -BLOCK_SIZE),
		Vector2(BLOCK_SIZE, 0),
		Vector2(BLOCK_SIZE,BLOCK_SIZE)
	]
	for b in blocks:
		render_planets(b)
	prev_block = get_block($StartPosition.position)
	$Player.position = $StartPosition.position
	
func start_game():
	distance = 0
	health = FULL_HEALTH
	$Player.position = $StartPosition.position
	$Player.start()

func game_over():
	$Player.stop()
	$HUD.game_over()

func _on_HUD_start_game():
	start_game()


func _on_Planet_crashed(ratio):
	health = max(health - 100*ratio - ($Player.left_v + $Player.right_v), 0)
	$HUD.set_health(health/FULL_HEALTH)
	print(health)
	if health == 0:
		game_over()


func _on_HUD_prepare_game():
	prepare_game()
	pass
