# StoredWrapper

StoredWrapper is a Swift Package Manager library that provides a convenient property wrapper for persisting values in UserDefaults. It offers a clean and type-safe way to work with stored properties in Swift, supporting various data types including custom Codable types.

## Description

StoredWrapper simplifies the process of storing and retrieving values from UserDefaults by providing a `@Stored` property wrapper. It supports both UIKit and SwiftUI, and can be used with any type that conforms to the Codable protocol.

Key features:
- Compatibility with any Codable type
- Easy-to-use `@Stored` property wrapper
- Type-safe key management
- SwiftUI compatible with `DynamicProperty` conformance

## Requirements

Swift 5.8, iOS 14

## Installation

Add this package to your project using Swift Package Manager. In Xcode, go to File > Add Package Dependency and enter the repository URL:

```
https://github.com/YevhenBiiak/StoredWrapper.git
```

## Usage

### UIKit

```swift
class ViewController: UIViewController {
    @Stored("username") var username: String = "DefaultUser"
    @Stored("isLoggedIn") var isLoggedIn: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        print(username) // Retrieves the stored value or uses the default
        isLoggedIn = true // Automatically saves to UserDefaults
    }
}
```

### SwiftUI

```swift
struct ContentView: View {
    @Stored("username") var username: String = "DefaultUser"
    @Stored("isLoggedIn") var isLoggedIn: Bool = false

    var body: some View {
        Text("Welcome, \(username)!")
            .onTapGesture {
                isLoggedIn.toggle() // Automatically updates UserDefaults
            }
    }
}
```

### Using String Keys

```swift
@Stored("apiKey") var apiKey: String?
```

### Using Type-Safe Keys

First, extend `Stored.Keys`:

```swift
extension Stored<String>.Keys {
    static let username = Key(name: "username")
}
```

Then use it in your code:

```swift
@Stored(.username) var username: String = "DefaultUser"
```

### Using with Codable Models

```swift
struct UserSettings: Codable {
    var theme: String
    var notificationsEnabled: Bool
}

class SettingsManager {
    @Stored("userSettings") var settings: UserSettings = UserSettings(theme: "light", notificationsEnabled: true)

    func updateTheme(to newTheme: String) {
        settings.theme = newTheme // Automatically encodes and saves to UserDefaults
    }

    func toggleNotifications() {
        settings.notificationsEnabled.toggle() // Automatically updates UserDefaults
    }
}
```

This approach provides type-safety, helps prevent typos in key names, and allows easy storage of complex Codable types.
