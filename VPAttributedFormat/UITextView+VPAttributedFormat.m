//
//  UITextView+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "UITextView+VPAttributedFormat.h"
#import "VPAttributedTextControlHelper.h"

@interface UITextView ()<VPAttributedTextControl>
@end

@implementation UITextView (VPAttributedFormat)

- (void)vp_setAttributedFormatArguments:(id)nilValue, ... {
    va_list arguments;
    va_start(arguments, nilValue);
    [self vp_setAttributedFormatArgumentsList:arguments];
    va_end(arguments);
}

- (void)vp_setAttributedFormatArgumentsList:(va_list)arguments {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self];
    [helper setAttributedFormatArguments:arguments];
}

@end
