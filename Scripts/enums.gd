class_name EnumTypes

enum SystemType {
	GALLERY_LAYOUT,
	GALLERY
}

static func system_to_str(system : SystemType) -> String:
	return SystemType.keys().get(system)

enum EnvironmentType {
	BOOKSHELL,
}

enum GalleryType {
	GENERAL,
}

enum Direction {
	E = 0,
	SE = 1,
	SW = 2,
	W = 3,
	NW = 4,
	NE = 5
}

enum WallDirection {
	SE = 0,
	S = 1,
	SW = 2,
	NW = 3,
	N = 4,
	NE = 5
}
