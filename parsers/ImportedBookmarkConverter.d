private import parsers.ConfigurableBookmarkConverter;

void init_imported_converter() {
	instruction inst;
	inst.which_lines ~= 0;
	inst.which_lines ~= 2;
	inst.uniq_ident = "url";
	inst.pattern = "youtube";
	inst.locatables[placement.us] ~= "\"url\": \"";
	inst.locatables[placement.ue] ~= "\"";
	inst.locatables[placement.ue] ~= "&feature";
	inst.locatables[placement.ns] ~= "\"name\": \"";
	inst.locatables[placement.ne] ~= "\"";
	inst.locatables[placement.as] ~= "watch?v=";
	inst.locatables[placement.ae] ~= "\"";
	inst.locatables[placement.ae] ~= "&feature";
	inst.which_locatable[placement.us] = 0;
	inst.which_locatable[placement.ue] = 0;
	inst.which_locatable[placement.ns] = 0;
	inst.which_locatable[placement.ne] = 0;
	inst.which_locatable[placement.as] = 0;
	inst.which_locatable[placement.ae] = 0;
	
	ConfigurableBookmarkConverter.add_iset(inst);
}
/*
debug (BookmarkConverter) {
	import tango.util.log.Trace;
	import tango.io.device.File;

	void main() {
		char text[] = cast(char[])File.get("/home/lmartin92/.config/google-chrome/Default/Bookmarks");
		auto c = new ImportedBookmarkConverter(text);
		auto d = new ImportedBookmarkConverter(text);
				
		Trace.formatln("{}", text.length);
		Trace.formatln("{}", c.get.length);
		Trace.formatln("{}", d.get.length);
		
		foreach(l; c.get) {
			Trace(l.url, l.name, l.actual_name);
		}
		
		foreach(l; d.get) { 
			Trace(l.url, l.name, l.actual_name);		
		}
		
		auto dup = new Deduplicator(c.get, d.get);
		
		Trace("Deduplicating");
		foreach(l; dup.deduplicate()) { 
			Trace(l.url, l.name, l.actual_name);			
		}
	}
}

class ImportedBookmarkLine : BookmarkLine {
private:
	char[]		_line,
				_url,
				_name,
				_actual_name;

public:
	public this(char[] line) {
		this._line = line;
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
			us = locatePattern(line,  "\"url\": \"") + 8;
			ue = locatePattern(line, test, us);	
			_url = _line[us .. ue];	
		}
		
		if(_url == "")
			parse_url();
		return _url;
	}
	
	char[] name() {
		void parse_name() { 
			int ns , ne;
			ns = locatePattern(line, "\"name\": \"") + 9;
			ne = locatePattern(line, "\"", ns);	
			
			_name = _line[ns .. ne];	
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
			
			_actual_name = _line[as .. ae];			
		}
		
		if(_actual_name == "")
			parse_actual_name();
		return _actual_name;
	}
}

class ImportedBookmarkConverter : BookmarkConverter {
private:
	char[] 			text;
	BookmarkLine[] 	lines;
		
	void parseText() {
		auto lines2 = new Lines!(char)(new Array(text));
		char[][] lines1;
		foreach(line; lines2) lines1 ~= line;
		int key = 0;
		foreach(value; lines1) { 
			if(containsPattern(value, "youtube")) {		
				char[] actual_line = value;
				actual_line ~= lines1[key - 2];	
				lines ~= new ImportedBookmarkLine(actual_line);		
			}
			key++;
		}
	}
		
public:
	public this(char[] text) {
		this.text = text;	
	}
	
	BookmarkLine[] get() {
		if(lines == null)
			parseText();
		return lines;
	}
}*/
