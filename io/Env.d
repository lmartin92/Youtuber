private import tango.sys.Environment;
private import tango.sys.HomeFolder;
private import tango.util.log.Trace;
private import Path = tango.io.Path;
private import tango.io.FileScan;
private import Integer = tango.text.convert.Integer;
	
debug (Env) {
	import tango.io.device.File;
		
	void main() {
		auto e = new Env("~/Music");
		
		e.createDir();
		
		auto d = new Env("~/Booger");
		
		d.createDir();	
	}
}

class Env {
	char[] dir;
		
public:
	this(char[] dir) {
		this.dir = dir;
	}
		
	bool setup() {
		bool ret = false;
		auto env = new Environment;
		char[] where = expandTilde(dir);
			
		try{ 
			env.cwd(where);	
			ret = true;	
		} catch { 
			Trace("Path does not exist: should fail");	
		}
		
		return ret;
	}
	
	bool createDir() {
		bool ret = setup();
		if(!ret) return ret;
			
		auto env = new Environment;
		auto scan = new FileScan;
		scan.sweep("." , true);	
		Path.PathParser p;
		int current = 0;
	
		foreach(folder; scan.folders) {
			uint to_eat = 0;	
			p = Path.parse(folder.toString);
			auto i = Integer.parse(p.name, 0, &to_eat);
				
			if(to_eat > 0) { 
				current = i > current ? i : current;
			}
		}
		
		debug (Env) {  
			Trace(dir ~ "/" ~ Integer.toString(current + 1)).newline.flush;
		}
		
		bool done;
			
		while(!done) { 
			try {
				Path.createFolder(expandTilde("~/Music/") ~ "/" ~ Integer.toString(current + 1));
				env.cwd(expandTilde("~/Music/") ~ "/" ~ Integer.toString(current + 1));
				done = true;
			} catch {  
				current++;		
			}	
		}
		
		debug (Env) { 
			Trace(current).newline.flush;
		}
		
		return ret;
	}
}
