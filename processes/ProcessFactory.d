private import tango.text.Util;
private import parsers.ExportedBookmarkConverter;
private import parsers.model.BookmarkConverter;
private import Path = tango.io.Path;
private import tango.util.log.Trace;
private import tango.sys.Process;
private import tango.core.Thread;

class Runner {
private:
	Process process;
	BookmarkLine _line;
	Renamer renamer;
	bool _completed;
	
public:
	this(BookmarkLine line, Renamer renamer) {
		this._line = line;	
		this.renamer = renamer;
	}
	
	void run() {
		char[][] args;
		args ~= "youtube-dl";
		args ~= "--extract-audio";
		args ~= "--audio-format=mp3";
		args ~= _line.url;
			
		process = new Process(true, args);
		Trace.formatln("Downloading: {} .", _line.url);
			
		process.execute;
	}
	
	void finish() {
		auto result = process.wait;
			
		if(result.status == 0) { 
			Trace("Download success.");
		}
		else Trace("Download failed.");
			
		_completed = renamer.rename(_line);
	}
	
	BookmarkLine line() {
		return _line;
	}
	
	bool completed() {
		return _completed;	
	}
} 

struct Replacement {
public:
	char to_replace;
	char replacement;
}

class Renamer {
private:
	Replacement[] filters;
		
public:
	this(Replacement[] filters) {
		this.filters = filters;	
	}	
	
	bool rename(BookmarkLine line) {
		bool rename_it(char[] name, char[] rname) { 
			bool ret = true;
			if(Path.exists(name ~ ".mp3")) {  
				Trace.formatln("Renaming {} to {}.", name ~ ".mp3", rname ~ ".mp3");
				Path.rename(name ~ ".mp3", rname ~ ".mp3");				
			} else ret = false;
				
			return ret;
		}
		
		char[] rename_to = line.name.dup;
			
		foreach(f; filters) {
			replace(rename_to, f.to_replace, f.replacement);
		}
		
		return rename_it(line.actual_name, rename_to);
	}
} 

class ProcessFactory {
private:
	Runner[] runners;
		
public:
	this(BookmarkLine[] lines, Renamer renamer) {
		foreach(line; lines) { 
			runners ~= new Runner(line, renamer);
		}
	}
	
	Runner[] get() {
		return runners;	
	}
}
