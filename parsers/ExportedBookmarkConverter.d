private import tango.text.Util;
private import tango.io.stream.Lines;
private import tango.io.device.Array;
private import parsers.model.BookmarkConverter;
	
debug (BookmarkConverter) {
	import tango.util.log.Trace;
	import tango.io.device.File;

	void main() {
		char text[] = cast(char[])File.get("/home/lmartin92/Documents/bookmarks_1_3_12.html");
		auto c = new BookmarkConverter(text);
		auto d = new BookmarkConverter(text);
				
		Trace(text.length).newline.flush;
		Trace(c.get.length).newline.flush;
		
		foreach(l; c.get) {
			Trace(l.url, l.name, l.actual_name).newline.flush;
		}
		
		foreach(l; d.get) { 
			Trace(l.url, l.name, l.actual_name).newline.flush;		
		}
		
		auto dup = new Deduplicator(c.get, d.get);
		
		Trace("Deduplicating").newline.flush;
		foreach(l; dup.deduplicate()) { 
			Trace(l.url, l.name, l.actual_name).newline.flush;			
		}
	}
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

class ExportedBookmarkLine : BookmarkLine {
private:
	char[]		_line,
				_url,
				_name,
				_actual_name;
		
	void parseLine() {
		char[] test = "\"";
			
		if(containsPattern(line, "&feature"))
			test  = "&feature";
			
		int us, ue, ns, ne, as, ae;
		us = ue = ns = ne = as = ae = 0;
			
		us = locatePattern(line,  "HREF=\"") + 6;
		ue = locatePattern(line, test, us);
			
		as = locatePattern(line, "watch?v=", us) + 8;
		ae = ue;
			
		ns = locatePattern(line, "\">", ue) + 2;
		ne = locatePattern(line, `</A>`, ns);
		
		version (Debug) {	
			Trace(us, ue, as, ae, ns, ne).newline.flush;
		}
			
		_url = line[us .. ue];
		_name = line[ns .. ne];
		_actual_name = line[as .. ae];
	}
	
public:
	this(char[] line) {
		this._line = line;
		//parseLine();
	}
	
	char[] line() {
		return _line;	
	}
	
	char[] url() {
		void parse_url() { 
			char[] test = "\"";
			
			if(containsPattern(line, "&feature"))
				test  = "&feature";
			
			int us, ue;
			us = locatePattern(line,  "HREF=\"") + 6;
			ue = locatePattern(line, test, us);	
			
			_url = line[us .. ue];
		}
		
		if(_url == "")
			parse_url();
		return _url;
	}
	
	char[] name() {
		void parse_name() { 
			int ns , ne;
			ns = locatePattern(line, "\">") + 2;
			ne = locatePattern(line, `</A>`, ns);	
			
			_name = line[ns .. ne];	
		}
		
		if(_name == "") 
			parse_name();
		return _name;	
	}
	
	char[] actual_name() {
		void parse_actual_name() { 
			char[] test = "\"";
			
			if(containsPattern(line, "&feature"))
				test  = "&feature";
			
			int as, ae;
			as = locatePattern(line, "watch?v=") + 8;
			ae = locatePattern(line, test, as);	
			
			_actual_name = line[as .. ae];			
		}
		
		if(_actual_name == "")
			parse_actual_name();
		return _actual_name;	
	}
} 

class ExportedBookmarkConverter : BookmarkConverter {
private:
	char[] 			text;
	BookmarkLine[] 	lines;
		
	void parseText() {
		auto lines1 = new Lines!(char)(new Array(text));
			
		foreach(line; lines1) { 
			if(containsPattern(line, "youtube"))
				lines ~= new ExportedBookmarkLine(line);		
		}
	}
		
public:
	this(char[] text) {
		this.text = text;	
	}
	
	BookmarkLine[] get() {
		if(lines == null)
			parseText();
		
		return lines;
	}
}

class ExportedBookmarkDeduplicator : BookmarkDeduplicator{
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


