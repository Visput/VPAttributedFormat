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

@interface VPAttributedTextControlHelper ()

@property (nonatomic, copy) NSAttributedString *attributedFormat;
@property (nonatomic, copy) NSAttributedString *attributedText;
@property (nonatomic, weak) id textControl;

@end

@implementation VPAttributedTextControlHelper

+ (instancetype)helperForTextControl:(id)textControl
                   attributedTextKey:(const void *)attributedTextKey {
    NSParameterAssert(textControl != nil);
    NSParameterAssert(attributedTextKey != NULL);
    
    VPAttributedTextControlHelper *helper = objc_getAssociatedObject(textControl, attributedTextKey);
    if (helper == nil) {
        helper = [[self class] new];
        helper.textControl = textControl;
        objc_setAssociatedObject(textControl, attributedTextKey, helper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return helper;
}

- (void)setAttributedTextFormatArguments:(va_list)arguments
                              keepFormat:(BOOL)keepFormat
                    attributedTextGetter:(NSAttributedString *(^)(void))attributedTextGetter
                    attributedTextSetter:(void(^)(NSAttributedString *attributedText))attributedTextSetter {
    NSParameterAssert(attributedTextGetter != NULL);
    NSParameterAssert(attributedTextSetter != NULL);
    
    NSAttributedString *attributedText = attributedTextGetter();
    
    BOOL isFormatUninitialized = self.attributedFormat == nil;
    BOOL isFormatChanged = ![self.attributedText isEqualToAttributedString:attributedText];
    if (isFormatUninitialized || isFormatChanged) {
        self.attributedFormat = attributedText;
    }

    NSAttributedString *resultAttributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.attributedFormat
                                                                                                 arguments:arguments];
    attributedTextSetter(resultAttributedText);
    self.attributedText = resultAttributedText;
    
    if (!keepFormat) {
        self.attributedFormat = nil;
    }
}

@end
