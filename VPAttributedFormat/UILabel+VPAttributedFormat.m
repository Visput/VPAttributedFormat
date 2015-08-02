//
//  UILabel+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "UILabel+VPAttributedFormat.h"
#import "VPAttributedTextControlHelper.h"

@interface UILabel ()<VPAttributedTextControl>
@end

@implementation UILabel (VPAttributedFormat)

- (void)vp_setAttributedTextFormatArguments:(BOOL)keepFormat, ... {
    va_list arguments;
    va_start(arguments, keepFormat);
    [self vp_setAttributedTextFormatArguments:arguments
                                   keepFormat:keepFormat];
    va_end(arguments);
}

- (void)vp_setAttributedTextFormatArguments:(va_list)arguments
                                 keepFormat:(BOOL)keepFormat {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self];
    [helper setAttributedTextFormatArguments:arguments
                                  keepFormat:keepFormat];
}

@end
