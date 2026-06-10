extends Node

@warning_ignore("unused_signal")
signal player_enter_gallery(from : HexCoord, to : HexCoord)
@warning_ignore("unused_signal")
signal player_move(position : Vector3, view : Vector2)

@warning_ignore("unused_signal")
signal prepare_book(id : String, color : Color, pos : Vector3)
@warning_ignore("unused_signal")
signal control_book(id : String)
