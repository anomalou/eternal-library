extends Shelf
class_name ShelfInteractive

func generate(_id : String):
	super(_id)

func hide_book(_hide : bool, index : int):
	var inst_transform = multimesh.get_instance_transform(index)
	inst_transform = inst_transform.scaled_local(Vector3.ZERO if _hide else Vector3.ONE)
	multimesh.set_instance_transform(index, inst_transform)
