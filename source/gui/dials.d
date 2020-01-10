import std.stdio;

import gtk.MainWindow;
import gtk.Widget;
import gtk.Dialog;
import gtk.VBox;
import gtk.Label;
import gtk.Box;
import gtk.Entry;

string md1a = "<span lang=\"utf-8\" color=\"green\"><b>";
string md1b =	"</b></span>";
string md2a = "<span lang=\"utf-8\"><tt>";
string md2b =	"</tt></span>";

struct DialogResp {
	int num;
	string text;
}

class EntryDialog : Dialog {
	this(string title, MainWindow w) {
		super();
		setTransientFor(w);
		setTitle(title);
		setDefaultSize(400, 250);

		auto content = getContentArea();
		content.add(new Label("ke passa"));

		showAll();
	}
}

DialogResp DialogEntry(string title, string head,	string entryLabel,
	string entryPre, bool visible, MainWindow win) {

    auto dial = new Dialog();
    dial.setTransientFor(win);
    dial.setTitle(title);

    auto content = dial.getContentArea();
    content.setSpacing(4);
    auto label = new Label(head);

    auto hbox = new Box(Orientation.HORIZONTAL, 4);
    auto name = new Label(entryLabel);
    auto entry = new Entry();
    entry.setText(entryPre);
    entry.setWidthChars(32);
    entry.setVisibility(visible);

	DialogResp resp = {-6, entryPre};
	bool activated;

	auto endDial = () {
		if (activated) {
			resp.num = -5;
		} else {
			resp.text = entry.getText();
		}
		dial.destroy();
	};

	entry.addOnActivate(delegate void(Entry e) {
		activated = true;
		resp.num = -5;
		resp.text = entry.getText();
		endDial();
	});

    hbox.packStart(name,  false, true, 4);
    hbox.packStart(entry, true,  true, 4);
    content.packStart(label, false, true, 4);
    content.packStart(hbox, false, true, 4);

    dial.addButton("Cancel", -6);
    dial.addButton("OK", -5);
    dial.setDefaultResponse(-5);
    dial.showAll();

 	if (!activated) {
		resp.num = dial.run();
		endDial();
	}

    return resp;
}

class TwoLabelsDial : Dialog {
	this(string title, string textOne, string textTwo, MainWindow w) {
		super();
		int resp = -6;

		setTransientFor(w);
		setTitle(title);
		setDefaultSize(300, 150);

		auto content = getContentArea();
		content.setSpacing(6);
		content.setMarginTop(6);
		content.setMarginBottom(6);
		content.setMarginStart(12);
		content.setMarginEnd(12);

		auto labelOne = new Label(textOne);
		labelOne.setMarkup(md1a ~ textOne ~ md1b);
		auto labelTwo = new Label(textTwo);
		labelTwo.setMarkup(md2a ~ textTwo ~ md2b);
		content.add(labelOne);
		content.add(labelTwo);

		addButton("Cancel", -6);
		addButton("OK", -5);
		setDefaultResponse(-6);
		addOnResponse(delegate void(int resp, Dialog d) { quitDial(resp); });

		showAll();
		resp = run();
	}

	void quitDial(int resp) {
		writeln("Response on Dialog destroy: ", resp);
		destroy();
	}
}

class TestDialog : Dialog {
	private:
	GtkDialogFlags flags = GtkDialogFlags.MODAL;
	MessageType messageType = MessageType.INFO;
	string[] buttonLabels = ["OK", "Save Preset", "Cancel"];
	int responseID;
	ResponseType[] responseTypes = [ResponseType.OK, ResponseType.ACCEPT, ResponseType.CANCEL];
	string messageText = "";
	string titleText = "New image...";
	MainWindow _w;
	//Box contentArea; // grabbed from the Dialog
	//AreaContent areaContent; // this is filled with stuff and passed to contentArea;

	public:
	this(MainWindow w) {
		_w = w;
		super(titleText, _w, flags, buttonLabels, responseTypes);
		//farmOutContent();
		addOnResponse(&doSomething);
		run();
		destroy();
	}

	void farmOutContent() {
		// FARM it out to AreaContent class
		//contentArea = getContentArea();
		//areaContent = new AreaContent(contentArea);
	}

	void doSomething(int response, Dialog d) {
		switch(response) {
			case ResponseType.OK:
				writeln("Creating new image file with these specs:");

				//foreach(item; areaContent.getNewImageDataGrid.getData()) {
				//	writeln("data item: ", item);
				//}

				/*
				writeln("filename: ", areaContent.getNewImageDataGrid.getData()[0]);
				writeln("width: ", areaContent.getNewImageDataGrid.getData()[1]);
				writeln("height: ", areaContent.getNewImageDataGrid.getData()[2]);
				writeln("resolution: ", areaContent.getNewImageDataGrid.getData()[3]);
				*/
			break;

			case ResponseType.ACCEPT:
				writeln("Bringing up a second dialog to save presets using...");

				//foreach(item; areaContent.getNewImageDataGrid.getData()) {
				//	writeln("data item: ", item);
				//}
			break;

			case ResponseType.CANCEL:
				writeln("Cancelled.");
			break;

			default:
				writeln("Dialog closed.");
			break;
		}
	}
}
