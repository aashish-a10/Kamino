# Kamino

iOS Project implemented with MVVM and data binding using RxSwift. 

![Alt text](README/structure.png?raw=true "Project Structure")

## Xcode project targets 

* **Kamino:** This is the iOS app target for Kamino App and contains the app delegate and other app-specific resources, such as the info.plist. Other than the app delegate, this target does not contain any source.  
* **iOSKit:** This Cocoa Touch Framework contains all the UI code specific to the Kamino iOS app such as view controllers and views.  
* **CommonKit:** This Cocoa Touch Framework contains code that depends on UIKit and that could be used on other UIKit platforms such as tvOS.  
* **ServiceKit:** This last Cocoa Touch Framework contains code that does not depend on UIKit. Therefore, this framework can be used in any Apple platform such as Mac OS

## Architecture concepts
* MVVM
* Data Binding using RxSwift
* Programmatic UI components
* Dependency Injection
* Response Data Caching
* Error handling in ViewModel, in Networking
* [Advanced iOS App Architecture](https://www.raywenderlich.com/8477-introducing-advanced-ios-app-architecture)

### Requirements
* Xcode Version 11.2.1+ Swift 5.0+
* RxSwift
* Used Carthage for 3rd party dependency

### How to use app
* On App Launch, a  network call is made and planet Kamino details are fetched and displayed, there are 2 buttons
  - **Like** To Like the planet   
  - **Residents** - It takes to list of residents on the planet.
* On selecting a resident, resident detail is displayed.  
 