class_name EnumTypes

enum SystemType {
	GALLERY_LAYOUT,
	GALLERY
}

static func system_to_str(system : SystemType) -> String:
	return SystemType.keys().get(system)

enum EntityType {
	BOOKSHELL,
}

enum GalleryType {
	GENERAL,
}

static func gallery_to_str(gallery : GalleryType) -> String:
	return GalleryType.keys().get(gallery)

enum Direction {
	E = 0,
	SE = 1,
	SW = 2,
	W = 3,
	NW = 4,
	NE = 5
}
