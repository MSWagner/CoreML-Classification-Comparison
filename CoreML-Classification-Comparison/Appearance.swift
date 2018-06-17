import UIKit

/// Defines the global appearance for the application.
struct Appearance {
    /// Sets the global appearance for the application.
    /// Call this method early in the applicaiton's setup, i.e. in `applicationDidFinishLaunching:`
    static func setup() {
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        UINavigationBar.appearance().tintColor = .white
        UINavigationBar.appearance().backgroundColor = Colors.Main.red
        UINavigationBar.appearance().barTintColor = Colors.Main.red
        UINavigationBar.appearance().isTranslucent = false

        UIApplication.shared.statusBarStyle = .lightContent

        UITabBar.appearance().tintColor = Colors.Main.red
    }
}