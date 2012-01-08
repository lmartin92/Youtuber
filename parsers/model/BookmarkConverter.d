interface BookmarkLine {
public:
	char[] line();
	char[] url();
	char[] name();
	char[] actual_name();
}

interface BookmarkConverter {
public:
	BookmarkLine[] get();
}

interface BookmarkDeduplicator {
public:
	BookmarkLine[] deduplicate();
}
