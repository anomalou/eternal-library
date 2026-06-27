extends Node
class_name BookManager

var _seed_manager : SeedManager

var _book_cache : Dictionary[String, BookData]

func init(seed_manager : SeedManager):
	self._seed_manager = seed_manager
	Log.info("Book manager initialized")

func find(id : String) -> BookData:
	return _book_cache.get(id)

func generate_player_journal(player_id : String) -> String:
	var journal_id = _seed_manager.generate_object_id("player_journal", "", player_id)
	# test only gibberish text
	var notes : NotesChapter = NotesChapter.new(
		"Phasellus molestie tellus ut nibh luctus, a venenatis dolor dignissim. Donec nisi justo, euismod lacinia risus ac, euismod facilisis elit. Donec malesuada tincidunt ipsum sed aliquet. Fusce dapibus, ligula vitae aliquet iaculis, ligula sapien laoreet ipsum, sit amet consectetur ex enim ac velit. Quisque egestas dolor sit amet hendrerit fringilla."
	)
	var book : BookData = BookData.new(journal_id, [notes])
	_book_cache.set(journal_id, book)
	return journal_id
	

func generate_book(id : String, is_gibberish : bool) -> BookData:
	Log.info("Generation book content ", id)
	if is_gibberish:
		var note : NotesChapter = NotesChapter.new(generate_gibberish(id))
		var book : BookData = BookData.new(id, [note])
		_book_cache.set(id, book)
		return book
	return null

func generate_gibberish(id : String) -> String:
	var content : String = ""
	var content_id : String = _seed_manager.generate_object_id("book_content", "", id)
	var paragraphs_id : String = _seed_manager.generate_object_id("book_paragraphs", "", content_id)
	var paragraphs_rnd : RandomNumberGenerator = _seed_manager.get_temp_rnd(paragraphs_id)
	for paragraph in range(paragraphs_rnd.randi_range(3, 10)):
		content += _generate_gibberish_paragraph(paragraph, paragraphs_id)
		content += "\n"
	return content

func _generate_gibberish_paragraph(paragraph_index : int, paragraphs_id : String) -> String:
	var paragraph : String = ""
	var sentencies_id : String = _seed_manager.generate_object_id("book_sentencies", str(paragraph_index), paragraphs_id)
	var sentencies_rnd : RandomNumberGenerator = _seed_manager.get_temp_rnd(sentencies_id)
	for sentence in range(sentencies_rnd.randi_range(1, 8)):
		paragraph += _generate_gibberish_sentence(sentence, sentencies_id)
		paragraph += " "
	return paragraph

func _generate_gibberish_sentence(sentence_index : int, sentencies_id : String) -> String:
	var sentence : Array[String] = []
	var words_id : String = _seed_manager.generate_object_id("book_words", str(sentence_index), sentencies_id)
	var commas_id : String = _seed_manager.generate_object_id("book_commas", str(sentence_index), sentencies_id)
	var words_rnd : RandomNumberGenerator = _seed_manager.get_temp_rnd(words_id)
	var commas_rnd : RandomNumberGenerator = _seed_manager.get_temp_rnd(commas_id)
	var words_count : int = words_rnd.randi_range(5, 20)
	var commas_number : int = commas_rnd.randi_range(0, round(words_count / 2.0))
	for word in range(words_count):
		sentence.append(_generate_gibberish_word(word, words_id))
		sentence.append(" ")
	for comma in range(commas_number):
		var index : int = commas_rnd.randi_range(1, words_count - 1)
		sentence.insert(2 * index - 1, ",")
	var first_word : String = sentence.pop_front()
	first_word = first_word.capitalize()
	sentence.push_front(first_word)
	sentence.pop_back()
	sentence.append(".")
	return "".join(sentence)

func _generate_gibberish_word(word_index : int, words_id : String) -> String:
	var word : String = ""
	var word_id = _seed_manager.generate_object_id("sentence_word", str(word_index), words_id)
	var word_rnd : RandomNumberGenerator = _seed_manager.get_temp_rnd(word_id)
	var length : int = word_rnd.randi_range(3, 10)
	for chr_index in range(length):
		var chr : String =  char(word_rnd.randi_range(97, 122))
		word += chr
	return word
