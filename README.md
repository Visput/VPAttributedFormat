# VPAttributedFormat
NSAttributedString+VPAttributedFormat

## Installation
### Cocoa Pods
Add to your Podfile ```pod "VPAttributedFormat"```.
### Drag&Drop
1. Drag and drop VPAttributedFormat.xcodeproj to your project;
2. Add VPAttributedFormat to Build Settings -> Target Dependencies;
3. Add VPAttributedFormat.framework to Build Settings -> Link Binary With Libraries;
4. Add "-all_load" flag to Build Settings -> Other Linker Flags.

## System Requirements
It requires building with iOS SDK 6.0 and later.

## Usage
### Import framework header or module
```objective-c
// By header
#import <VPAttributedFormat/VPAttributedFormat.h>
```
```objective-c
// By module
@import VPAttributedFormat;
```
## Examples
VPAttributedFormatExample directory contains example project. It provides Basic and Pro format examples.  
![alt tag](https://raw.githubusercontent.com/Visput/VPAttributedFormat/develop/VPAttributedFormatExample/Screenshots/Example.png?token=AG9sE4o1kk6LNGEwnDLatMmEcWdlEd4Kks5Vr_7MwA%3D%3D)
