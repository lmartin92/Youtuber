private import parsers.ConfigurableBookmarkConverter;

void init_logger_converter() {
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
	
	ConfigurableBookmarkConverter.add_iset(inst3);
}

/*
private import tango.text.Util;
private import tango.io.stream.Lines;
private import tango.io.device.Array;
private import parsers.model.BookmarkConverter;

private import tango.util.log.Trace;

class LoggerBookmarkLine : BookmarkLine {
private:
	char[][] lines;
	char[] content;
public:
	this(char[] content) {
		lines = split(content, ":::");
		this.content = content;
	}
	
	char[] line() {
		return content;	
	}
	
	char[] url() {
		return lines[0];
	}
	
	char[] name() {
		return lines[1];
	}
	
	char[] actual_name() {
		return lines[2];
	}
}

class LoggerBookmarkConverter : BookmarkConverter {
private:
	char[] 			text;
	BookmarkLine[] 	lines;
		
public:
	this(char[] text) {
		this.text = text;	
	}
		
	BookmarkLine[] get() {
		auto lines1 = new Lines!(char)(new Array(text));
			
		foreach(line; lines1) { 
			if(containsPattern(line, "youtube"))
				lines ~= new LoggerBookmarkLine(line);		
		}
		
		return lines;
	}
	
	static char[] encode(BookmarkLine line) {
		return ",,," ~ line.url ~ ":::" ~ line.name ~ ";;;" ~ line.actual_name ~ "...";	
	}
}
*/