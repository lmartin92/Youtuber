private import tango.text.Util;
	
import tango.util.log.Trace;

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

class BookmarkDeduplicator{
	BookmarkLine[] source;
	BookmarkLine[] test;
	BookmarkLine[] dedup;
		
	void unduplicate() {
		foreach(s; source) { 
			bool add = true;
				
			foreach(t; test) { 
				if(t.url == s.url) {
					add = false;
					break;
				}		
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
