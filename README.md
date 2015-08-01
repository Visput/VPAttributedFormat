## VPAttributedFormat
VPAttributedFormat project represents category: **NSAttributedString+VPAttributedFormat**.  
This category provides methods for building attributed string based on attributed format and arguments that should satisfy this format.  
The most suitable case of using this category is text controls with variable attributed text configured in interface builder.  
You need set correct string format to attributed text and configure necessary attributes.  
Then you need pass necessary arguments in code by using methods of this category.  
See [Usage](#usage) and [Examples](#examples) sections for more details.  

![example](https://cloud.githubusercontent.com/assets/7302163/8714863/a33e91c2-2b3f-11e5-93aa-f886c019ca38.png)

### Installation
##### Cocoa Pods
Add to your Podfile:  
```
pod "VPAttributedFormat"
use_frameworks!
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
Use *vp_setAttributedFormatArguments:YES, ...* if you need update arguments multiple times.
```objective-c
// Objective C
NSString *hot = @"Hot";
NSString *cold = @"Cold";

[self.textLabel vp_setAttributedFormatArguments:YES, hot, cold];
```
```swift
// Swift
let hot = "Hot"
let cold = "Cold"

var arguments: [CVarArgType] = [hot, cold]
withVaList(arguments) { pointer in
  textControl.vp_setAttributedFormatArguments(pointer, keepFormat: true);
}
```
###### Set arguments only once  
Use *vp_setAttributedFormatArguments:NO, ...* if you need set arguments only once.
```objective-c
// Objective C
NSString *hot = @"Hot";
NSString *cold = @"Cold";

[self.textLabel vp_setAttributedFormatArguments:NO, hot, cold];
```
```swift
// Swift
let hot = "Hot"
let cold = "Cold"

var arguments: [CVarArgType] = [hot, cold]
withVaList(arguments) { pointer in
  textControl.vp_setAttributedFormatArguments(pointer, keepFormat: false);
}
```

Use *vp_attributedStringWithAttributedFormat:format, ...* if you want set text directly to *attributedText* property.
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
