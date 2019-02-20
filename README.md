# BrickBatView

[![CI Status](https://img.shields.io/travis/zerojian/BrickBatView.svg?style=flat)](https://travis-ci.org/zerojian/BrickBatView)
[![Version](https://img.shields.io/cocoapods/v/BrickBatView.svg?style=flat)](https://cocoapods.org/pods/BrickBatView)
[![License](https://img.shields.io/cocoapods/l/BrickBatView.svg?style=flat)](https://cocoapods.org/pods/BrickBatView)
[![Platform](https://img.shields.io/cocoapods/p/BrickBatView.svg?style=flat)](https://cocoapods.org/pods/BrickBatView)



![example](https://raw.githubusercontent.com/ZeroJian/BrickBatView/master/Assets/Example.png)

BrickBatView It can be simply composed of view components into a alert view. Each component is created by you

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

* iOS 8.0+
* Swift4+

## Installation

BrickBatView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BrickBatView'
```
## Usage



##### Example

```swift
BrickBatView(inView: view)?
      .setup()
      .addTitleItem(title: "Title", infoicon: nil)
      .addMessageItem(text: "message")
      .addButtonItem(title: ["cancel", "done"], style: .fill)
      .show()		

```

##### Setup

```swift
BrickBatView(inView: view)?
      .handle(action: { (index) in
          print("sender index: \(index)")
      }, tapHidden: true)

      .identifier("BrickView_SETUP")

      .lifeCyle(showFinishedAction: { (show) in
          print("isShowFinished")
      }, hiddenAction: {
          print("isHidden")
      })
      .offset(10)
      .position(.bottom, edgeInster: 20)
...
```

##### Extension

```swift
extension BrickBatView {

func addExtensionTextField() -> Self {

      let textField = UITextField()
      textField.bounds.size.height = 50
      textField.placeholder = "BrickView addTextField Extension"
      textField.borderStyle = .roundedRect

      return addContentView(textField)
}

brickBatView
      .addExtensionTextField()
...	
```

##### Extension 2

```swift
let buttonView = ButtonView()	
brickBatView
      .addContentView(buttonView, controls: buttonView.button)
...

let item = BrickBarItem()
brickBatView
      .addBrickItem(item)
...

let imageView = UIimageView()
brickBatView
      .addGesture([imageView])
...
```

## Author

ZeroJian, zj17223412@outlook.com

## License

BrickBatView is available under the MIT license. See the LICENSE file for more info.
