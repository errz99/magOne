import std.stdio;
import gtk.MainWindow;
import gtk.Main;
import gtk.Widget;
import gtk.Button;

import dials;

class MainWin : MainWindow {
	CallButton button;

	this() {
		super("MagOne");
		//addOnDestroy(delegate void(Widget w) { quitApp(); });
		
		addOnDestroy(delegate void(Widget w) {
			Main.quit();
			writeln("Adios");
		});
		
		setDefaultSize(600, 400);

		auto button = new CallButton(this);
		add(button);

		showAll();
	}

	//void quitApp() {		
	//	Main.quit();
	//	writeln("Bye, bye.");
	//}
}

class CallButton : Button {
	this(MainWindow w) {
		super("To Dialog");
		addOnClicked(delegate void(Button b) { showDialog(w); });
	}

	void showDialog(MainWindow w) {
		writeln("Ahora aparece el Dialog");
		//anto entryDial = new EntryDialog("My Dialog", w);
		//auto twoLabelsDial = new TwoLabelsDial("Mi titulo", "Texto Uno", "Texto Dos", w);		
		//auto resp = twoLabelsDial.run();
		
		//auto testDial = new TestDialog(w);
		//auto resp = testDial.run();
		
		auto resp = DialogEntry("Titulo", "Cabeza", "Etiqueta", "Previo", true, w);
		
		if (resp.num == -5) {				
			writeln("Ok pressed: ", resp);
		}	
	}
}
