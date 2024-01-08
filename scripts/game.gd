class_name Game extends Node3D

const NEXT_HOLE_TIMER_WAIT = 3.0

@onready var menu_background = $MenuBackground
@onready var GUI = $PuttingHUD
@onready var level_select = $LevelSelect
@onready var multiplayer_menu = $MultiplayerMenu
@onready var multiplayer_spawner = $MultiplayerSpawner
@onready var round_timer = $RoundTimer
@onready var scoreboard = $Scoreboard

var player : Golfball

var players_won : int

var next_hole_timer : Timer

func _ready():
	active_game(false)
	
	level_select.change_level_signal.connect(change_level_receiver)
	level_select.golfball_left.connect(golfball_left)
	level_select.game_won.connect(game_win_receiver)
	
	multiplayer_menu.player_added.connect(set_player)
	multiplayer_menu.is_singleplayer.connect(select_singleplayer)
	multiplayer_menu.is_multiplayer.connect(select_multiplayer)
	
	if multiplayer.is_server():
		round_timer.timeout.connect(round_timer_timeout)
	
	next_hole_timer = initialize_timer()

func round_timer_timeout():
	start_next_hole_timer.rpc()

func next_hole_receiver():
	next_hole.rpc()

@rpc("authority", "call_local")
func next_hole():
	scoreboard_next_hole()
	players_won = 0
	round_timer.stop()
	level_select.next_hole()
	if not level_select.last_hole:
		round_timer.start()
		initialize_player.rpc(level_select.get_current_spawn_location_transform())
	else:
		if multiplayer.is_server():
			active_game(false)

@rpc("authority", "call_local")
func initialize_player(pos):
	player.move_to(pos)
	player.enable(pos)

func change_level_receiver(path, level_name):
	change_level.rpc(path, level_name)
	
@rpc("authority", "call_local")
func change_level(path, level_name):
	if menu_background:
		menu_background.queue_free()
		menu_background = null
	
	scoreboard.reset()
	update_gui.rpc()
	
	level_select.change_level(path, level_name)
	active_game(true)
	
	if multiplayer.is_server():
		next_hole.rpc()

@rpc("any_peer", "call_local")
func update_gui():
	GUI.update_text(player.putts)
	scoreboard.update()

func update_gui_receiver():
	update_gui.rpc()

func game_win_receiver(peer_id):
	if peer_id == player.get_multiplayer_authority():
		game_win.rpc(peer_id)
		level_select.activate_hole_camera()
	
@rpc("any_peer", "call_local")
func game_win(peer_id):
	players_won += 1
	print("winners: " + str(players_won))
	
	if peer_id == player.get_multiplayer_authority():
		player.disable()
		update_gui.rpc()
	
	if players_won == get_tree().get_nodes_in_group("players").size():
		print("All players have won")
		if multiplayer.is_server():
			start_next_hole_timer.rpc()

func active_game(game_active):
	if game_active:
		GUI.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		level_select.visible = false
	else:
		GUI.visible = false
		level_select.visible = true
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func golfball_left(peer_id):
	if player.get_multiplayer_authority() == peer_id:
		player.move_back()

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

func initialize_timer():
	if not multiplayer.is_server():
		return
	
	if next_hole_timer:
		remove_child(next_hole_timer)
	
	var tmp = Timer.new()
	tmp.wait_time = NEXT_HOLE_TIMER_WAIT
	tmp.autostart = false
	tmp.one_shot = true
	tmp.timeout.connect(next_hole_receiver)
	add_child(tmp)
	return tmp

func scoreboard_next_hole():
	scoreboard.next_hole()
	update_gui.rpc()

@rpc("authority", "call_local")
func start_next_hole_timer():
	level_select.activate_hole_camera()
	player.disable()
	if multiplayer.is_server():
		next_hole_timer.start()
