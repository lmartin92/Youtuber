import data.Logger;
import io.Env;
import parsers.model.BookmarkConverter;
import parsers.ExportedBookmarkConverter;
import processes.ProcessFactory;
import parsers.ImportedBookmarkConverter;
import parsers.LoggerBookmarkConverter;
import parsers.ConfigurableBookmarkConverter;

import tango.io.FileScan;
import tango.text.Util;
import tango.sys.HomeFolder;
import tango.util.log.Trace;
import tango.io.device.File;
import tango.io.Console;
import tango.core.Thread;
	
int main() {
	BookmarkDeduplicator			dedup;
	BookmarkLine[]					downloads;
	char[][char[]] 					filter;
	ProcessFactory					factory;
	Runner[]						runners;
	Setup 							setup = new Setup();
	bool 							go;
		
	setup.setup();	
	if(!setup.wait) {
		return setup.error;	
	}
	scope(exit) {
		setup.logger.close;	
	}
		
	dedup = new BookmarkDeduplicator(setup.bookmarks.get, setup.compare.get);
	Trace("We are now removing any duplicate downloads.");
	downloads = dedup.deduplicate;
	Trace.formatln("You have {} videos to download as mp3s.", downloads.length);
		
	Replacement[] replacements;
	Replacement s;
	s.to_replace = ' '; s.replacement = '_';
	replacements ~= s;
	factory = new ProcessFactory(downloads, new Renamer(replacements));
	Trace("We have now setup our excellent renaming tool.");
	Trace("This gives your files nice names.");
		
	// fromt his point these could be ran in granularized groups
	runners = factory.get;
	Trace("About to start downloads");
	for(int i = 0; i < runners.length; i++) {
		Trace.formatln("Starting download {} of {}.", i+1, runners.length);
		runners[i].run;
		runners[i].finish;
		if(!runners[i].completed) {	
			Trace("Oops, the download failed.");
			Trace("What would you like to do? Abort (a), Retry (r), Skip (s): ");
			bool again = true;
			while(again) {
				char[] what; Cin.readln(what);
				switch (what[0]) {		
					case 'a':
						Trace("We are exiting as requested due to a bad download");
						Trace.formatln("Error: reason (exiting due to bad download). Code: {}.", 3);
						return 3;
						break;
					case 'r':
						i--;
						again = false;
						break;
					case 's':
						again = false;
						break;
					default:
						Trace("You may [a]bort, [r]etry, [s]kip. Try again: ");
						break;		
				}
			}
		} else { 
			setup.logger.write(LoggerBookmarkConverter.encode(runners[i].line));
		}
	}
	
	Trace("Finished downloading. Thanks, bye.");
	
	setup.logger.close;
	
	return 0;
}

class Setup {
private:
	Env 				_env;
	BookmarkConverter 	_bookmarks;
	Logger				_logger;
	BookmarkConverter	_compare;
		
	Thread[3]			threads;
	bool 				_wait = true;
	int					_error = 0;
	bool 				which = false;
		
	char[] get_bookmarks_file() {
		char[] ret;
		auto scan = new FileScan;	
		scan(expandTilde("~/Documents/"), ".html");
	
		foreach(f; scan.files) {
			if(containsPattern(f.toString, "bookmarks")) { 
				ret = f.toString;
				break;
			}   
		}
		
		if(ret == "") { 
			ret = homeFolder ~ "/.config/google-chrome/Default/Bookmarks";		
		}
		
		which = true;
	
		return ret;
	}
		
	void setup_env() {
		_env = new Env("~/Music");
		_env.createDir();
		Trace("Setup our environment. We will put your files in your Music folder.");	
	}
	
	void setup_bookmarks() {
		char[] bfile = get_bookmarks_file();
		if(bfile == "") {
			Trace("We failed to locate your bookmarks file.");
			Trace("Remember to export your bookmarks before running this program.");
			Trace("Thanks bye.");
			Trace.formatln("Error: reason (could not locate bookmarks file). Code: {}.", 1);
			_error = 1;
			_wait = false;	
		} else {
			Trace.formatln("We have located your bookmarks file at {}.", bfile);	
		}
		if(!which)
			_bookmarks = new ExportedBookmarkConverter(cast(char[])File.get(bfile));
		else
			_bookmarks = new ImportedBookmarkConverter(cast(char[])File.get(bfile));
		Trace("Your bookmarks file has been read.");
		if(_bookmarks.get.length == 0) {
			Trace("You apparently have not bookmarked any YouTube videos.");
			Trace("We will now exit as there is nothing to do.");
			Trace("Error: reason (no bookmarks of YouTube in bookmark file). Code: {}", 2);
			_error = 2;	
			_wait = false;
		} else {
			Trace.formatln("You have {} mp3s to download from YouTube.", bookmarks.get.length);	
		}
	}
	
	void setup_compare() {
		Trace("Opening our log file.");
		_logger = new Logger("~/Documents/log");
		char[] log_contents = _logger.read();
		if(log_contents == "") {
			Trace("This must be your first time using this program. Thank you for using our product.");	
		} else {
			Trace("Thanks for the repeat usage of our product.");
			Trace("We have managed to read lines from our log file.");
			Trace("This will keep you from having repeat downloads.");	
		}
		_compare = new LoggerBookmarkConverter(log_contents);
		Trace.formatln("You have downloaded {} YouTube videos as mp3s in the past.", compare.get.length);
	}
		
public:
	Env env() {
		return _env;	
	}
	
	BookmarkConverter bookmarks() {
		return _bookmarks;	
	}
	
	Logger logger() {
		return _logger;	
	}	
	
	BookmarkConverter compare() {
		return _compare;
	}
	
	void setup() {
		threads[0] = new Thread(&setup_env);
		threads[1] = new Thread(&setup_bookmarks);
		threads[2] = new Thread(&setup_compare);
			
		foreach(t; threads) { 
			t.start();		
		}
	}
	
	bool wait() {
		foreach(t; threads) t.join; 
		return _wait;
	}
	
	int error() {
		return _error;	
	}
}