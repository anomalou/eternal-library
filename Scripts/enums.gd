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
	NE = 0,
	N = 1,
	NW = 2,
	SW = 3,
	S = 4,
	SE = 5
}
