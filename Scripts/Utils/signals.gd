extends Node

@warning_ignore("unused_signal")
signal player_enter_gallery(from : HexCoord, to : HexCoord)
@warning_ignore("unused_signal")
signal player_move(position : Vector3, view : Vector2)

@warning_ignore("unused_signal")
signal prepare_book(id : String, color : Color, global_pos : Vector3)
@warning_ignore("unused_signal")
signal start_reading(id : String, is_gibberish : bool)
@warning_ignore("unused_signal")
signal return_book(id : String)
