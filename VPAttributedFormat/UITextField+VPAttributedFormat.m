//
//  UITextField+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "UITextField+VPAttributedFormat.h"
#import "VPAttributedTextControlHelper.h"

@interface UITextField ()<VPAttributedTextControl>
@end

@implementation UITextField (VPAttributedFormat)

- (void)vp_setAttributedFormatArguments:(BOOL)keepFormat, ... {
    va_list arguments;
    va_start(arguments, keepFormat);
    [self vp_setAttributedFormatArguments:arguments
                               keepFormat:keepFormat];
    va_end(arguments);
}

- (void)vp_setAttributedFormatArguments:(va_list)arguments
                             keepFormat:(BOOL)keepFormat {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self];
    [helper setAttributedFormatArguments:arguments
                              keepFormat:keepFormat];
}

@end
