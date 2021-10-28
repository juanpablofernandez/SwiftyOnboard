# SwiftyOnboard
> A simple iOS framework that allows developers to create onboarding experiences.

[![Swift Version][swift-image]][swift-url]
[![Build Status][travis-image]][travis-url]
[![License][license-image]][license-url]
[![CocoaPods](https://img.shields.io/cocoapods/v/SwiftyOnboard.svg)](https://cocoapods.org/pods/SwiftyOnboard)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Platform](https://img.shields.io/cocoapods/p/LFAlertController.svg?style=flat)](http://cocoapods.org/pods/LFAlertController)

SwiftyOnboard makes it easy to add onboarding to any iOS application. SwiftyOnboard handles all of the logic behind the pagination of views, which allows you to quickly add a highly customizable onboarding to your app, all in a lightweight framework.

![](screenshots/onboard1.gif)
![](screenshots/onboard2.gif)

## Contents

* [Requirements](#requirements)
* [Installation](#installation)
    * [CocoaPods](#cocoapods)
    * [Manually](#manually)
* [Usage](#usage)
    * [Properties](#properties)
    * [Methods](#methods)
    * [Protocols](#protocols)
        * [DataSource](#swiftyonboarddatasource)
        * [Delegate](#swiftyonboarddelegate)
* [Notes](#notes)
* [Contribute](#contribute)
* [License](#license)

## Requirements

- iOS 9.0+
- Xcode 7.3+

## Installation

#### CocoaPods
You can use [CocoaPods](http://cocoapods.org/) to install `SwiftyOnboard` by adding this to your `Podfile`:

```ruby
use_frameworks!
pod 'SwiftyOnboard'
```
If you get the ``Unable to find a specification for `SwiftyOnboard`.``  error after running `pod install`.

Run the following commands on your project directory:
```
pod repo update
```
```
pod install
```
#### Carthage
To install via Carthage add this to your Cartfile:
```ruby
github "juanpablofernandez/SwiftyOnboard"
```
#### Manually
1. Drag and drop ```SwiftyOnboard.swift``` ```SwiftyOnboardOverlay.swift``` ```SwiftyOnboardPage.swift``` in your project.  
2. That's it!

## Usage
1. Import `SwiftyOnboard` module to your `ViewController` class
```swift
import SwiftyOnboard
```
2. Add `SwiftyOnboard` to `ViewController`, then set dataSource and delegate for it
```swift
class ViewController: UIViewController {
    override func viewDidLoad() {
            super.viewDidLoad()

            let swiftyOnboard = SwiftyOnboard(frame: view.frame)
            view.addSubview(swiftyOnboard)
            swiftyOnboard.dataSource = self
        }
}
```
3. Conform your `ViewController` to `SwiftyOnboardDataSource` protocol and implement all the methods, e.g.
```swift
extension ViewController: SwiftyOnboardDataSource {

        func swiftyOnboardNumberOfPages(swiftyOnboard: SwiftyOnboard) -> Int {
            return 3
        }

        func swiftyOnboardPageForIndex(swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
            let page = SwiftyOnboardPage()
            return page
        }
}
```
4. `SwiftyOnboard` works with default implementation. Override it to customize its behavior

<!-- [Example project with CocoaPods](https://github.com/juanpablofernandez). -->

### Properties

SwiftyOnboard has the following properties:
```swift
public var dataSource: SwiftyOnboardDataSource?
```
An object that supports the SwiftyOnboardDataSource protocol and can provide views to populate the SwiftyOnboard.
```swift
public var delegate: SwiftyOnboardDelegate?
```
An object that supports the SwiftyOnboardDelegate protocol and can respond to SwiftyOnboard events.
```swift
public var shouldSwipe: Bool
```
Whether or not swiping is enabled [default = true].
```swift
public var fadePages: Bool
```
Whether or not pages will fade upon transition [default = true].

### Methods

SwiftyOnboard class has the following methods:
```swift
func goToPage(index: Int, animated: Bool)
```
This method allows you to move to a certain page in the onboarding.

### Protocols

The SwiftyOnboard follows the Apple convention for data-driven views by providing two protocol interfaces, SwiftyOnboardDataSource and SwiftyOnboardDelegate.
#### SwiftyOnboardDataSource
SwiftyOnboardDataSource protocol has the following methods:
```swift
func swiftyOnboardNumberOfPages(swiftyOnboard: SwiftyOnboard) -> Int
```
Return the number of items (pages) in the onboarding.
```swift
func swiftyOnboardViewForBackground(swiftyOnboard: SwiftyOnboard) -> UIView?
```
Return a view to be displayed as the background of the onboarding.
```swift
func swiftyOnboardPageForIndex(swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage?
```
Return a view (page) to be displayed at the specified index in the onboarding.
```swift
func swiftyOnboardViewForOverlay(swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay?
```
Return an overlay (view) to be displayed on top of the onboarding pages. e.g. [The continue and skip buttons which don't move with the pages, also included is the page control]
```swift
func swiftyOnboardOverlayForPosition(swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double)
```
Edit the overlay (view) for the desired position. e.g. [Change the "continue button" text to "Done", when the last page is reached]
```swift
func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor?
```
Set the background color for the page at the given index. (Very useful when you have pages with different background colors)

#### SwiftyOnboardDelegate
SwiftyOnboardDelegate protocol has the following methods:
```swift
func swiftyOnboard(swiftyOnboard: SwiftyOnboard, currentPage index: Int)
```
This method is called whenever a page is shown, it holds the index to that page. It is called regardless of whether the page was swiped programmatically or through user interaction.
```swift
func swiftyOnboard(swiftyOnboard: SwiftyOnboard, leftEdge position: Double)
```
This method is called whenever the pages are scrolling, it holds the current distance between the left side of the screen and the left side of the first page.
```swift
func swiftyOnboard(swiftyOnboard: SwiftyOnboard, tapped index: Int)
```
This method is called whenever a page is tapped by the user, it holds the index of the tapped page.

## Notes
* Landscape mode is not supported

## Contribute
Contributions are welcomed! There are however certain guidelines you must follow when you contribute:
* Have descriptive commit messages.
* Make a pull request for every feature (Don't make a pull request that adds 3 new features. Make an individual pull request for each of those features, with a descriptive message).
* Don't update the example project, or any other irrelevant files.

I want to see your amazing onboarding. Take screenshots and/or record a gif and send it my way!

## License

Distributed under the MIT license. See ``LICENSE`` for more information.

[swift-image]:https://img.shields.io/badge/swift-3.0-orange.svg
[swift-url]: https://swift.org/
[license-image]: https://img.shields.io/badge/License-MIT-blue.svg
[license-url]: LICENSE
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[codebeat-image]: https://codebeat.co/badges/c19b47ea-2f9d-45df-8458-b2d952fe9dad
[codebeat-url]: https://codebeat.co/projects/github-com-vsouza-awesomeios-com
