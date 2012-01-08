private import tango.io.device.File;
private import tango.sys.HomeFolder;

class Logger {
private:
	File file;

public:
	this(char[] file) {
		char[] afile = "";
		
		if(file[0] == '~') { 
			afile = homeFolder ~ file[1 .. $];		
		} else afile = file;
			
		this.file = new File(afile, File.ReadWriteOpen);		
	}
	
	char[] read() {
		char[] ret = new char[file.length];
		
		file.read(ret);
		
		return ret;	
	}
	
	void write(char[] content) {
		file.write(content);
		file.write("\n");	
	}
	
	void truncate() {
		file.truncate;	
	}
	
	void close() {
		file.close;	
	}
}