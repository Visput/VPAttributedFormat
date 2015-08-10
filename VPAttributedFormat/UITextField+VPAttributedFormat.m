//
//  UITextField+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "UITextField+VPAttributedFormat.h"
#import "VPAttributedTextControlHelper.h"

@implementation UITextField (VPAttributedFormat)

- (void)vp_setAttributedTextFormatArguments:(BOOL)keepFormat, ... {
    va_list arguments;
    va_start(arguments, keepFormat);
    [self vp_setAttributedTextFormatArguments:arguments
                                   keepFormat:keepFormat];
    va_end(arguments);
}

- (void)vp_setAttributedTextFormatArguments:(va_list)arguments
                                 keepFormat:(BOOL)keepFormat {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self
                                                                              attributedTextKey:@selector(attributedText)];
    [helper setAttributedTextFormatArguments:arguments
                                  keepFormat:keepFormat
                        attributedTextGetter:^NSAttributedString *{
                            return self.attributedText;
                        } attributedTextSetter:^(NSAttributedString *attributedText) {
                            self.attributedText = attributedText;
                        }];
}

- (void)vp_setAttributedPlaceholderFormatArguments:(BOOL)keepFormat, ... {
    va_list arguments;
    va_start(arguments, keepFormat);
    [self vp_setAttributedPlaceholderFormatArguments:arguments
                                          keepFormat:keepFormat];
    va_end(arguments);
}

- (void)vp_setAttributedPlaceholderFormatArguments:(va_list)arguments
                                        keepFormat:(BOOL)keepFormat {
    VPAttributedTextControlHelper *helper = [VPAttributedTextControlHelper helperForTextControl:self
                                                                              attributedTextKey:@selector(attributedPlaceholder)];
    [helper setAttributedTextFormatArguments:arguments
                                  keepFormat:keepFormat
                        attributedTextGetter:^NSAttributedString *{
                            return self.attributedPlaceholder;
                        } attributedTextSetter:^(NSAttributedString *attributedText) {
                            self.attributedPlaceholder = attributedText;
                        }];
}

@end
