package;

import sys.io.File;
import sys.FileSystem;
import sys.io.Process;

import haxe.io.Path;
import haxe.ui.HaxeUIApp;

import haxe.ui.containers.Box;
import haxe.ui.containers.VBox;
import haxe.ui.containers.ScrollView;

import haxe.ui.components.Image;
import haxe.ui.components.Label;
import haxe.ui.components.Button;

import haxe.ui.events.MouseEvent;

using StringTools;

typedef Quote = {
    var author:String;
    var text:String;
}

@:build(haxe.ui.ComponentBuilder.build("assets/main-view.xml"))
class MainView extends VBox {
    public var quotes:Array<Quote> = [
        {author: "swordcube", text: "Looks like that clover wasn't so lucky after all..."},
        {author: "swordcube", text: "The game blueballed itself!"},
        {author: "swordcube", text: "There goes the game, falling into the [[HOLE]]"},
        {author: "swordcube", text: "What happened???"},
        {author: "swordcube", text: "Did you push a dev build to production?"},
        {author: "swordcube", text: "Did you find a bug that didn't happen in QA testing?"},
        {author: "swordcube", text: "fnf boyfriend be like Beep like if you agree"},
        {author: "swordcube", text: "It would be so awesome, it would be so cool"},
        {author: "swordcube", text: "sex update when?"},
        {author: "swordcube", text: "closed source forever, EVIL FNF"}
    ];

    public function new() {
        super();
        final app:HaxeUIApp = HaxeUIApp.instance;
        app.icon = "assets/icon.ico";

        var crashDump:String = null;
        var crashDumpPath:String = null;

        final cmdArgs:Array<String> = Sys.args();
        final chosenQuote:Quote = quotes[Std.random(quotes.length - 1)];

        if(cmdArgs.length != 0) {
            if(FileSystem.exists(cmdArgs[0])) {
                crashDumpPath = cmdArgs[0];
                crashDump = File.getContent(crashDumpPath);
            } else 
                trace("Crash dialog opened without valid file path, using placeholders instead!");
        }
        final banner:Image = new Image();
        banner.resource = "assets/banner.png";
        banner.percentWidth = 100;
        banner.height = 100;
        addComponent(banner);
        
        final quote:Label = new Label();
        quote.text = '${chosenQuote.text}\nWhoops! Funkin Potioned has crashed!';
        quote.percentWidth = 100;
        quote.horizontalAlign = "center";
        quote.styleString = "text-align: center;";
        quote.marginTop = 5;
        quote.marginBottom = 5;
        addComponent(quote);

        final callStackArea:VBox = new VBox();
        callStackArea.percentWidth = 100;
        callStackArea.styleString = "padding:12px;padding-bottom:0px;";
        addComponent(callStackArea);

        final callStackTitle:Label = new Label();
        callStackTitle.text = "Call Stack:";
        callStackArea.addComponent(callStackTitle);

        final callStackScrollView:ScrollView = new ScrollView();
        callStackScrollView.percentWidth = 100;
        callStackScrollView.height = 158;
        callStackArea.addComponent(callStackScrollView);

        final callStackText:Label = new Label();
        callStackScrollView.addComponent(callStackText);
        
        final uncaughtArea:VBox = new VBox();
        uncaughtArea.percentWidth = 100;
        uncaughtArea.styleString = "padding:12px;padding-top:6px;padding-bottom:6px;";
        addComponent(uncaughtArea);
        
        final uncaughtErrorLabel:Label = new Label();
        uncaughtErrorLabel.text = 'Uncaught Error: Fuck You\nPlease report this to GitHub: https://github.com/swordcube/Funkin-Potioned';
        uncaughtArea.addComponent(uncaughtErrorLabel);

        if(crashDump != null && crashDump.length != 0) {
            final splitDump:Array<String> = crashDump.replace("\r", "").trim().split("\n");
            if(splitDump.length > 3) {
                final buf:StringBuf = new StringBuf();
                for(_ in 0...splitDump.length - 2)
                    buf.add('${splitDump.shift()}\n');

                callStackText.text = buf.toString().trim();
                uncaughtErrorLabel.text = splitDump.join("\n").trim();
            }
            else {
                callStackText.text = splitDump.shift();
                uncaughtErrorLabel.text = splitDump.join("\n").trim();
            }
        }
        else {
            final buf:StringBuf = new StringBuf();
            for(i in 0...30)
                buf.add('sample/testbench/Test${i + 1}.hx (line ${Std.random(300)})\n');
            
            callStackText.text = buf.toString().trim();
            uncaughtErrorLabel.text = 'Uncaught Error: Null Object Reference\nPlease report this to GitHub: https://github.com/swordcube/Funkin-Potioned';
        }
        final buttonArea:Box = new Box();
        buttonArea.percentWidth = 100;
        buttonArea.styleString = "padding:12px;padding-top:0px;spacing:12px";
        addComponent(buttonArea);

        final viewCrashDumpBtn = new Button();
        viewCrashDumpBtn.text = "View Crash Dump";
        viewCrashDumpBtn.horizontalAlign = "left";
        viewCrashDumpBtn.onClick = (event:MouseEvent) -> {
            try {
                if(!FileSystem.exists(crashDumpPath))
                    throw "File path doesn't exist";

                new Process("notepad", [crashDumpPath]);
            }
            catch(e) {
                trace('Something went wrong trying to view the crash dump: ${e}');
            }
        };
        buttonArea.addComponent(viewCrashDumpBtn);

        final restartBtn = new Button();
        restartBtn.text = "Restart";
        restartBtn.width = 75;
        restartBtn.horizontalAlign = "center";
        restartBtn.onClick = (event:MouseEvent) -> {
            try {
                final exePath:String = Path.join([Sys.getCwd(), "FunkinPotioned.exe"]);
                if(!FileSystem.exists(exePath))
                    throw "Could not find executable for Potioned";

                new Process(exePath, []);
                Sys.exit(0);
            }
            catch(e) {
                trace('Something went wrong trying to restart the game: ${e}');
            }
        }
        buttonArea.addComponent(restartBtn);
        
        final closeBtn = new Button();
        closeBtn.text = "Close";
        closeBtn.width = 75;
        closeBtn.horizontalAlign = "right";
        closeBtn.onClick = (event:MouseEvent) -> Sys.exit(0);
        buttonArea.addComponent(closeBtn);
    }
}