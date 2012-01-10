private import parsers.ConfigurableBookmarkConverter;

void init_exported_converter() {
	instruction inst2;
	inst2.which_lines ~= 0;
	inst2.uniq_ident = "HREF=\"";
	inst2.pattern = "youtube";
	inst2.locatables[placement.us] ~= "HREF=\"";
	inst2.locatables[placement.ue] ~= "\"";
	inst2.locatables[placement.ue] ~= "&feature";
	inst2.locatables[placement.ns] ~= "\">";
	inst2.locatables[placement.ne] ~= `</A>`;
	inst2.locatables[placement.as] ~= "watch?v=";
	inst2.locatables[placement.ae] ~= "\"";
	inst2.locatables[placement.ae] ~= "&feature";
	inst2.which_locatable[placement.us] = 0;
	inst2.which_locatable[placement.ue] = 0;
	inst2.which_locatable[placement.ns] = 0;
	inst2.which_locatable[placement.ne] = 0;
	inst2.which_locatable[placement.as] = 0;
	inst2.which_locatable[placement.ae] = 0;
	
	ConfigurableBookmarkConverter.add_iset(inst2);
}
/*
debug (BookmarkConverter) {
	import tango.util.log.Trace;
	import tango.io.device.File;

	void main() {
		char text[] = cast(char[])File.get("/home/lmartin92/Documents/bookmarks_1_9_12.html");
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
}*/




