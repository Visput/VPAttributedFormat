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

static NSString *const VPAttributedTextKeyPath = @"attributedText";
static const void *VPTextControlHelperKey = &VPTextControlHelperKey;

@interface VPAttributedTextControlHelper ()

@property (nonatomic, copy) NSAttributedString *attributedFormat;
@property (nonatomic, weak) NSObject<VPAttributedTextControl> *textControl;
@property (nonatomic, assign) BOOL isObservingAttributedString;

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

- (void)setAttributedFormatArguments:(va_list)arguments {
    if (self.attributedFormat == nil) {
        self.attributedFormat = self.textControl.attributedText;
    }
    
    [self unregisterFromObservingAttributedText];
    self.textControl.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.attributedFormat
                                                                                        arguments:arguments];
    [self registerForObservingAttributedText];
}

#pragma mark -
#pragma mark KVO

- (void)registerForObservingAttributedText {
    if (!self.isObservingAttributedString) {
        self.isObservingAttributedString = YES;
        [self.textControl addObserver:self
                           forKeyPath:VPAttributedTextKeyPath
                              options:NSKeyValueObservingOptionNew
                              context:nil];
    }
}

- (void)unregisterFromObservingAttributedText {
    if (self.isObservingAttributedString) {
        self.isObservingAttributedString = NO;
        [self.textControl removeObserver:self
                              forKeyPath:VPAttributedTextKeyPath];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:VPAttributedTextKeyPath]) {
        self.attributedFormat = change[@"new"];
    }
}

- (void)dealloc {
    [self unregisterFromObservingAttributedText];
}

@end
