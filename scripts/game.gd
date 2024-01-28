class_name Game extends Node

const DID_NOT_FINISH_SCORE = 14

var hud : UserHUD
var menu_background : MenuBackground
var level_select : LevelSelect
var scoreboard : Scoreboard
var game_status : GameStatus

func set_level_select(level_select):
	self.level_select = level_select

func set_singleplayer():
	level_select.activate()
