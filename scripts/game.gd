class_name Game extends Node3D

@onready var menu_background = $MenuBackground
@onready var GUI = $PuttingHUD
@onready var level_select = $LevelSelect
@onready var multiplayer_menu = $MultiplayerMenu
@onready var multiplayer_spawner = $MultiplayerSpawner
@onready var round_timer = $RoundTimer
@onready var scoreboard = $Scoreboard

var golfball_last_pos : Vector3
var out_of_bounds_area : OutOfBoundsArea

var player : Golfball

var hole : Hole
var current_level : Node3D
var current_level_name : String

func _ready():
	game_status(false)
	
	if !level_select.change_level.is_connected(change_level_receiver):
		level_select.change_level.connect(change_level_receiver)
	
	if !multiplayer_menu.player_added.is_connected(set_player):
		multiplayer_menu.player_added.connect(set_player)
	
	if !multiplayer_menu.is_singleplayer.is_connected(select_singleplayer):
		multiplayer_menu.is_singleplayer.connect(select_singleplayer)
	
	if !multiplayer_menu.is_multiplayer.is_connected(select_multiplayer):
		multiplayer_menu.is_multiplayer.connect(select_multiplayer)
	
	if !level_select.levels_found.is_connected(add_levels_to_spawn_list):
		level_select.levels_found.connect(add_levels_to_spawn_list)
	
	if !round_timer.timeout.is_connected(timeout):
		round_timer.timeout.connect(timeout)

func update_gui_receiver():
	update_gui.rpc()

@rpc("any_peer", "call_local", "reliable")
func update_gui():
	scoreboard.update()
	GUI.update_text(player.putts)

func change_level_receiver(path, level_name):
	change_level.rpc(path, level_name)

@rpc("authority", "call_local")
func change_level(path, level_name):
	if player:
		player.disable()
	update_gui.rpc()
	if menu_background:
		menu_background.queue_free()
		menu_background = null
	round_timer.start_timer()
	current_level_name = level_name
	remove_current_level()
	initialize_level(path)
	game_status(true)

func game_win(peer_id):
	round_timer.stop_timer()
	if peer_id == player.get_multiplayer_authority():
		player.disable()
		update_gui.rpc()
		game_status(false)
		hole.activate_hole_camera()
	else:
		print(str(peer_id) + " WON THE GAME!!!")

@rpc("authority", "call_local")
func end_game():
	round_timer.stop_timer()
	player.disable()
	update_gui.rpc()
	game_status(false)
	hole.activate_hole_camera()

func game_status(game_active):
	if game_active:
		GUI.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		level_select.visible = false
	else:
		GUI.visible = false
		level_select.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func initialize_level(path):
	if player:
		player.enable()
	
	current_level = load(path).instantiate()
	get_tree().current_scene.add_child(current_level)
	var tmp_children = current_level.get_children()
	for child in tmp_children:
		if child is Hole:
			hole = child
			if !hole.game_win.is_connected(game_win):
				hole.game_win.connect(game_win)
		if child is OutOfBoundsArea:
			out_of_bounds_area = child
			if !out_of_bounds_area.golfball_left.is_connected(golfball_left):
				out_of_bounds_area.golfball_left.connect(golfball_left)

func golfball_left(peer_id):
	if player.get_multiplayer_authority() == peer_id:
		player.move_back()

func remove_current_level():
	if current_level:
		current_level.get_parent().remove_child(current_level)

func set_player(player):
	if not self.player:
		self.player = player
		player.putted.connect(update_gui_receiver)

func select_singleplayer():
	multiplayer_menu.queue_free()
	multiplayer_menu = null
	level_select.activate()

func select_multiplayer():
	if multiplayer.is_server():
		level_select.activate()

func add_levels_to_spawn_list(level_paths):
	if level_paths is Array:
		for level in level_paths:
			multiplayer_spawner.add_spawnable_scene(level)

func timeout():
	end_game.rpc()
