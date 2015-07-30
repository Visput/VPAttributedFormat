//
//  VPAttributedTextControlHelper.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPAttributedTextControlHelper.h"
#import "NSAttributedString+VPAttributedFormat.h"
#import <objc/runtime.h>

static const void *VPTextControlHelperKey = &VPTextControlHelperKey;

@interface VPAttributedTextControlHelper ()

@property (nonatomic, copy) NSAttributedString *attributedFormat;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, weak) NSObject<VPAttributedTextControl> *textControl;

@end

@implementation VPAttributedTextControlHelper

+ (instancetype)helperForTextControl:(NSObject<VPAttributedTextControl> *)textControl {
    VPAttributedTextControlHelper *helper = objc_getAssociatedObject(textControl, VPTextControlHelperKey);
    if (helper == nil) {
        helper = [[self class] new];
        helper.textControl = textControl;
        objc_setAssociatedObject(textControl, VPTextControlHelperKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return helper;
}

- (void)setAttributedFormatArguments:(va_list)arguments
                          keepFormat:(BOOL)keepFormat {
    BOOL isFormatUninitialized = self.attributedFormat == nil;
    BOOL isFormatChanged = ![self.attributedText isEqualToAttributedString:self.textControl.attributedText];
    if (isFormatUninitialized || isFormatChanged) {
        self.attributedFormat = self.textControl.attributedText;
    }

    self.textControl.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.attributedFormat
                                                                                        arguments:arguments];
    self.attributedText = self.textControl.attributedText;
    
    if (!keepFormat) {
        self.attributedFormat = nil;
    }
}

@end
