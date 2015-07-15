# VPAttributedFormat
VPAttributedFormat project represents category: **NSAttributedString+VPAttributedFormat**.  
This category provides methods for building attributed string based on attributed format and arguments that should satisfy this format.  
The most suitable case of using this category is text controls with variable attributed text configured in interface builder.  
You need set correct string format to attributed text and configure necessary attributes.  
Then you need pass necessary arguments in code by using methods of this category.  
See 'Usage' and 'Examples' sections for more details.

## Installation
#### Cocoa Pods
Add to your Podfile ```pod "VPAttributedFormat"```.
#### Drag&Drop
1. Drag and drop VPAttributedFormat.xcodeproj to your project;
2. Add VPAttributedFormat to Build Settings -> Target Dependencies;
3. Add VPAttributedFormat.framework to Build Settings -> Link Binary With Libraries;
4. Add "-all_load" flag to Build Settings -> Other Linker Flags.

## System Requirements
It requires building with iOS SDK 6.0 and later.

## Usage
##### Import framework header or module
```objective-c
// By header
#import <VPAttributedFormat/VPAttributedFormat.h>
```
```objective-c
// By module
@import VPAttributedFormat;
```
##### Set correct format and attributes for text control in interface builder
![usage](https://cloud.githubusercontent.com/assets/7302163/8710224/d34da150-2b0d-11e5-9714-9d8f57873283.png)
##### Create IBOutlet and link it with text control
```objective-c
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
```
##### Populate format with necessary arguments
```objective-c
NSString *hot = @"Hot";
NSString *cold = @"Cold";
  
self.textLabel.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.textLabel.attributedText,
                                 hot,
                                 cold];
```
##### Enjoy the result
![result](https://cloud.githubusercontent.com/assets/7302163/8710248/f9da5598-2b0d-11e5-9800-92b422ef15fb.png)

## Examples
VPAttributedFormatExample directory contains example project. It provides Basic and Pro format examples.  
![example](https://cloud.githubusercontent.com/assets/7302163/8709672/b0560006-2b09-11e5-9a42-505bd420e804.png)
