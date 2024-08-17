package;

import haxe.ui.HaxeUIApp;

class Main {
    public static function main() {
        var app = new HaxeUIApp();
        app.ready(() -> {
            app.addComponent(new MainView());
            app.start();
        });
    }
}
