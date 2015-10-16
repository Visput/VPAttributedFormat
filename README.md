## VPAttributedFormat v1.2.4
VPAttributedFormat project represents categories:   
 - NSAttributedString+VPAttributedFormat  
 - UILabel+VPAttributedFormat  
 - UITextView+VPAttributedFormat  
 - UITextField+VPAttributedFormat
 - UIButton+VPAttributedFormat

These categories provide methods for building attributed string based on attributed format and arguments that should satisfy this format.  
The most suitable case of using these categories is text controls with variable attributed text configured in interface builder.  
You need set correct string format to attributed text and configure necessary attributes.  
Then you need pass necessary arguments in code by using methods of these categories.  
All standard controls that work with attributed strings are supported: UILabel, UITextView, UITextField, UIButton.  
See [Usage](#usage) and [Examples](#examples) sections for more details.  
Full documentation is available on [CocoaDocs](http://cocoadocs.org/docsets/VPAttributedFormat).

![example](https://cloud.githubusercontent.com/assets/7302163/8714863/a33e91c2-2b3f-11e5-93aa-f886c019ca38.png)

### Installation
##### Cocoa Pods
Add to your Podfile:  
```
pod "VPAttributedFormat"
```

##### Drag&Drop
1. Drag and drop VPAttributedFormat.xcodeproj to your project;
2. Add VPAttributedFormat to Build Settings -> Target Dependencies;
3. Add VPAttributedFormat.framework to Build Settings -> Link Binary With Libraries;
4. Add "-all_load" flag to Build Settings -> Other Linker Flags.

### Usage<a name="usage"></a>
##### Import framework header or module
```objective-c
// Objective C
// By header
#import <VPAttributedFormat/VPAttributedFormat.h>
// By module
@import VPAttributedFormat;
```
```swift
// Swift
import VPAttributedFormat
```

##### Set correct format and attributes for text control in interface builder
![usage](https://cloud.githubusercontent.com/assets/7302163/8714855/93099414-2b3f-11e5-8b20-ac1a48896378.png)

##### Create IBOutlet and link it with text control
```objective-c
// Objective C
@property (nonatomic, weak) IBOutlet UILabel *textLabel;
```
```swift
// Swift
@IBOutlet weak var textLabel: UILabel!
```

##### Populate format with necessary arguments

###### Set arguments multiple times
Use UILabel / UITextView / UITextField / UIButton category methods.  
Set keepFormat parameter to YES.
```objective-c
// Objective C
NSString *hot = @"Hot";
NSString *cold = @"Cold";

[self.textLabel vp_setAttributedTextFormatArguments:YES, hot, cold];
```
```swift
// Swift
let hot = "Hot"
let cold = "Cold"

var arguments: [CVarArgType] = [hot, cold]
withVaList(arguments) { pointer in
  textLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: true);
}
```
###### Set arguments only once  
Use UILabel / UITextView / UITextField / UIButton category methods.  
Set keepFormat parameter to NO.
```objective-c
// Objective C
NSString *hot = @"Hot";
NSString *cold = @"Cold";

[self.textLabel vp_setAttributedTextFormatArguments:NO, hot, cold];
```
```swift
// Swift
let hot = "Hot"
let cold = "Cold"

var arguments: [CVarArgType] = [hot, cold]
withVaList(arguments) { pointer in
  textLabel.vp_setAttributedTextFormatArguments(pointer, keepFormat: false);
}
```

###### Set attributed text directly  
Use NSAttributedString category methods.  
It's suitable for situations when attributed format comes from another part of application.
```objective-c
// Objective C
NSString *hot = @"Hot";
NSString *cold = @"Cold";

self.textLabel.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.textLabel.attributedText,
                                 hot,
                                 cold];
```
```swift
// Swift
let hot = "Hot"
let cold = "Cold"

var arguments: [CVarArgType] = [hot, cold]
textLabel.attributedText = withVaList(arguments) { pointer in
    NSAttributedString.vp_attributedStringWithAttributedFormat(textLabel.attributedText, arguments: pointer)
}
```

##### Enjoy!
![result](https://cloud.githubusercontent.com/assets/7302163/8714860/9b37dbb4-2b3f-11e5-8296-9a57f39cd702.png)

### System Requirements
It requires building with iOS SDK 6.0 and later.  
It can be used in Objective C and Swift code.

### Examples<a name="examples"></a>
[VPAttributedFormatExample](https://github.com/Visput/VPAttributedFormat/tree/master/VPAttributedFormatExample/ "VPAttributedFormatExample") is an example project. It provides Basic and Pro format examples. 

### License
VPAttributedFormat is released under the MIT license. See LICENSE for details.
