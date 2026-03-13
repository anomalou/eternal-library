class_name EnumTypes

enum EntityType {
	BOOKSHELF,
	TABLE,
	FIRE_SOURCE,
	SHELF,
	BOOK
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

enum PageType {
	GIBBERISH = 0,
	KNOWLEDGE = 1,
	NOTES = 2
}
