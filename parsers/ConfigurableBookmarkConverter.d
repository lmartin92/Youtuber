private import parsers.model.BookmarkConverter;
private import tango.text.Util;
private import tango.io.stream.Lines;
private import tango.io.device.Array;
private import ArrayMethods = tango.core.Array;
import tango.util.log.Trace;

debug (BookmarkConverter) {
	void main() {
		instruction inst;
		inst.which_lines ~= 0;
		inst.which_lines ~= 2;
		inst.uniq_ident = "url";
		inst.pattern = "youtube";
		inst.locatables[placement.us] ~= "\"url\": \"";
		inst.locatables[placement.ue] ~= "\"";
		inst.locatables[placement.ue] ~= "&feature";
		inst.locatables[placement.ue] ~= "&list";
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
		
		instruction inst2;
		inst2.which_lines ~= 0;
		inst2.uniq_ident = "HREF=\"";
		inst2.pattern = "youtube";
		inst2.locatables[placement.us] ~= "HREF=\"";
		inst2.locatables[placement.ue] ~= "\"";
		inst2.locatables[placement.ue] ~= "&feature";
		inst2.locatables[placement.ue] ~= "&list";
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
		
		instruction inst3;
		inst3.which_lines ~= 0;
		inst3.uniq_ident = ":::";
		inst3.pattern = "youtube";
		inst3.locatables[placement.us] ~= ",,,";
		inst3.locatables[placement.ue] ~= ":::";
		inst3.locatables[placement.ns] ~= ":::";
		inst3.locatables[placement.ne] ~= ";;;";
		inst3.locatables[placement.as] ~= ";;;";
		inst3.locatables[placement.ae] ~= "...";
		inst3.which_locatable[placement.us] = 0;
		inst3.which_locatable[placement.ue] = 0;
		inst3.which_locatable[placement.ns] = 0;
		inst3.which_locatable[placement.ne] = 0;
		inst3.which_locatable[placement.as] = 0;
		inst3.which_locatable[placement.ae] = 0;
		
		ConfigurableBookmarkConverter.add_iset(inst);
		ConfigurableBookmarkConverter.add_iset(inst2);
		ConfigurableBookmarkConverter.add_iset(inst3);
		
		char[] text = cast(char[])File.get("/home/lmartin92/.config/google-chrome/Default/Bookmarks");
		char[] text2 = cast(char[])File.get("/home/lmartin92/Documents/bookmarks_1_9_12.html");
		char[] text3 = cast(char[])File.get("/home/lmartin92/Documents/log");
		Trace.formatln("{}", text.length);
		Trace.formatln("{}", text2.length);
		auto b = new ConfigurableBookmarkConverter(text);
		auto b2 = new ConfigurableBookmarkConverter(text);
		auto b3 = new ConfigurableBookmarkConverter(text3);
		BookmarkLine[] lines = b.get;
		Trace.formatln("{}", lines.length);
		Trace.formatln("{}", b2.get.length);
		Trace.formatln("{}", b3.get.length);
		foreach(l; lines) {
			Trace(l.url);
			Trace(l.name);
			Trace(l.actual_name);
		}
		
		foreach(l; b2.get) {
			Trace(l.url);
			Trace(l.name);
			Trace(l.actual_name);
		}
		
		foreach(l; b3.get) {
			Trace(l.url);
			Trace(l.name);
			Trace(l.actual_name);
		}
	}
}

struct instruction {
public:
	int[]			 	which_lines;
	char[][][placement] locatables;
	int[placement]		which_locatable;
	char[]				uniq_ident;
	char[]				pattern;
}

enum placement {
	us,
	ue,
	ns,
	ne,
	as,
	ae
}

class ConfigurableBookmarkLine : BookmarkLine {
private:
	char[] 		_line;
	char[] 		_url;
	char[] 		_name;
	char[] 		_actual_name;
	instruction inst;
	
	int[] pull_loc(placement start, placement end) {
		// test if it is in there, if so give location
		int test_and_locate(char[] loc, bool add_length = false, int start = 0) {
			int ret = -1;
			
			if(containsPattern(_line, loc)) {
				ret = locatePattern(_line, loc, start);
				
				if(add_length)
					ret += loc.length;
			}
			
			return ret;
		}		
		
		int[] locate(placement place, bool add_length = true, int loc = 0) {
			int[] ret;
			int temp;
			int last = 0;
			
			for(int i = 0; i <= inst.which_locatable[place]; i++) {
				last = ret.length > 0 ? ret[ret.length - 1] : loc;
				for(int j = 0; j < inst.locatables[place].length; j++) {
					temp = test_and_locate(inst.locatables[place][j], add_length, last);
					if(temp != -1) {
						ret ~= temp;
					}
				}
				ArrayMethods.sort(ret);
			}
			
			return ret;
		}
		
		int[] ret, starts, ends;
		
		starts = locate(start);
		ret ~= starts[inst.which_locatable[start]];
		ends = locate(end, false, ret[0]);
		ret ~= ends[inst.which_locatable[end]];
		
		return ret;
	}
		
public:
	this(char[] line, instruction set) {
		_line = line;
		inst = set;
	}	
		
	char[] line() {
		return _line;
	}
		
	char[] url() {
		if(_url == "") {
			int[] where = pull_loc(placement.us, placement.ue);
			_url = _line[where[0] .. where[1]];
		}
			
		return _url;
	}
		
	char[] name() {
		if(_name == "") {
			int[] where = pull_loc(placement.ns, placement.ne);
			_name = _line[where[0] .. where[1]];
		}
			
		return _name;
	}
		
	char[] actual_name() {
		if(_actual_name == "") {
			int[] where = pull_loc(placement.as, placement.ae);
			_actual_name = _line[where[0] .. where[1]];
		}
			
		return _actual_name;
	}
}
	
class ConfigurableBookmarkConverter : BookmarkConverter {
private:
	char[] 					content;
	BookmarkLine[] 			lines;
	static instruction[]   	i_sets;
			
	void parse_lines() {
		instruction my_iset;
				
		foreach(inst; i_sets) {
			if(containsPattern(content, inst.uniq_ident))
				my_iset = inst;	
		}
			
		char[][] _lines;
		auto lines2 = new Lines!(char)(new Array(content));
		foreach(line; lines2) _lines ~= line;
				
		for(int i = 0; i < _lines.length; i++) {
			if(containsPattern(_lines[i], my_iset.pattern)) {
				char[] current_line;
				foreach(w; my_iset.which_lines) {  
					current_line ~= _lines[i - w];			
				}
				lines ~= new ConfigurableBookmarkLine(current_line, my_iset);
			}
		}
	}
			
public:
	this(char[] content) {
		this.content = content;	
	}
		
	BookmarkLine[] get() { 
		if(lines == null)
			parse_lines();
				
		return lines;
	}
	
	static void add_iset(instruction i_set) {
		i_sets ~= i_set;
	}
		
	static char[] encode(BookmarkLine line) {
		return ",,," ~ line.url ~ ":::" ~ line.name ~ ";;;" ~ line.actual_name ~ "...";	
	}
}