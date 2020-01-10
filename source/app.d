import std.stdio;

import gtk.Main;
import mwin;

void main(string[] args) {

	MainWin mwin;

	Main.init(args);

	mwin = new MainWin();

	Main.run();

}
