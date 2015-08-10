//
//  UIButton+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 8/4/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "UIButton+VPAttributedFormat.h"
#import "VPAttributedTextControlHelper.h"

@implementation UIButton (VPAttributedFormat)

- (void)vp_setAttributedTitleFormatArgumentsForState:(UIControlState)state
                                          keepFormat:(BOOL)keepFormat, ... {
    va_list arguments;
    va_start(arguments, keepFormat);
    [self vp_setAttributedTitleFormatArguments:arguments
                                      forState:state
                                    keepFormat:keepFormat];
    va_end(arguments);
}

- (void)vp_setAttributedTitleFormatArguments:(va_list)arguments
                                    forState:(UIControlState)state
                                  keepFormat:(BOOL)keepFormat {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self
                                                                              attributedTextKey:[self vp_keyForState:state]];
    [helper setAttributedTextFormatArguments:arguments
                                  keepFormat:keepFormat
                        attributedTextGetter:^NSAttributedString *{
                            return [self attributedTitleForState:state];
                        } attributedTextSetter:^(NSAttributedString *attributedText) {
                            [self setAttributedTitle:attributedText forState:state];
                        }];
}

#pragma mark -
#pragma mark Private

- (const void *)vp_keyForState:(UIControlState)state {
    static const void *VPControlStateNormalKey = &VPControlStateNormalKey;
    static const void *VPControlStateHighlightedKey = &VPControlStateHighlightedKey;
    static const void *VPControlStateDisabledKey = &VPControlStateDisabledKey;
    static const void *VPControlStateSelectedKey = &VPControlStateSelectedKey;
    static const void *VPControlStateApplicationKey = &VPControlStateApplicationKey;
    static const void *VPControlStateReservedKey = &VPControlStateReservedKey;
    
    const void *key = NULL;
    
    switch (state) {
        case UIControlStateNormal: {
            key = VPControlStateNormalKey;
            break;
        }
        case UIControlStateHighlighted: {
            key = VPControlStateHighlightedKey;
            break;
        }
        case UIControlStateDisabled: {
            key = VPControlStateDisabledKey;
            break;
        }
        case UIControlStateSelected: {
            key = VPControlStateSelectedKey;
            break;
        }
        case UIControlStateApplication: {
            key = VPControlStateApplicationKey;
            break;
        }
        case UIControlStateReserved: {
            key = VPControlStateReservedKey;
            break;
        }
        default: {
            NSAssert(0, @"Wrong UIControlState value: %lu", (unsigned long)state);
            break;
        }
    }
    
    return key;
}

@end
