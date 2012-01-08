private import tango.text.Util;

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

class UrlParser {
	static char[] parse_actual_name(char[] url) {
		char[] test = "\"";
		
		if(containsPattern(url, "&feature"))
			test  = "&feature";
		
		int as, ae;
		as = locatePattern(url, "watch?v=") + 8;
		ae = locatePattern(url, test, as);	
		
		return url[as .. ae];
	}
}

class BookmarkDeduplicator{
	BookmarkLine[] source;
	BookmarkLine[] test;
	BookmarkLine[] dedup;
		
	void unduplicate() {
		foreach(s; source) { 
			bool add = true;
				
			foreach(t; test) {  
				if(t.line == s.line)
					add = false;		
			}
			
			if(add)
				dedup ~= s;
		}
	}
		
public:
	this(BookmarkLine[] source, BookmarkLine[] test) {
		this.source = source;
		this.test = test;
	}
	
	BookmarkLine[] deduplicate() {
		if(!dedup) { 
			unduplicate();		
		}
		
		return dedup;
	}
}
