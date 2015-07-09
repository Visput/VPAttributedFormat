# VPAttributedFormat
VPAttributedFormat project represents category: **NSAttributedString+VPAttributedFormat**.  
This category provides methods for building attributed string based on attributed format and arguments that should satisfy this format.  
The most suitable case of using this category is text controls with variable attributed text configured in interface builder.  
You need set correct string format to attributed text and configure necessary attributes.  
Then you need pass necessary arguments in code by using methods of this category.  

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
