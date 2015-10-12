//
//  NSAttributedString+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "NSAttributedString+VPAttributedFormat.h"
#import "VPAttributedStringFormatter.h"

@implementation NSAttributedString (VPAttributedFormat)

+ (instancetype)vp_attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat, ... {
    va_list arguments;
    va_start(arguments, attributedFormat);
    NSAttributedString *attributedString = [[[self class] alloc] vp_initWithAttributedFormat:attributedFormat
                                                                                   arguments:arguments];
    va_end(arguments);
    
    return attributedString;
}

+ (instancetype)vp_attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat
                                              arguments:(va_list)arguments {
    return [[[self class] alloc] vp_initWithAttributedFormat:attributedFormat
                                                   arguments:arguments];
}

- (instancetype)vp_initWithAttributedFormat:(NSAttributedString *)attributedFormat, ... __attribute__((objc_method_family(init))) {
    va_list arguments;
    va_start(arguments, attributedFormat);
    self = [self vp_initWithAttributedFormat:attributedFormat
                                   arguments:arguments];
    va_end(arguments);
    
    return self;
}

- (instancetype)vp_initWithAttributedFormat:(NSAttributedString *)attributedFormat
                                  arguments:(va_list)arguments __attribute__((objc_method_family(init))) {
    VPAttributedStringFormatter *formatter = [VPAttributedStringFormatter new];
    self = [self initWithAttributedString:[formatter stringWithFormat:attributedFormat
                                                            arguments:arguments]];
    
    return self;
}

@end
