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

+ (instancetype)attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat, ... {
    va_list arguments;
    va_start(arguments, attributedFormat);
    NSAttributedString *attributedString = [[[self class] alloc] initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    return attributedString;
}

- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat, ... {
    va_list arguments;
    va_start(arguments, attributedFormat);
    self = [self initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    return self;
}

- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat arguments:(va_list)arguments {
    VPAttributedStringFormatter *formatter = [VPAttributedStringFormatter new];
    self = [self initWithAttributedString:[formatter stringWithFormat:attributedFormat arguments:arguments]];
    return self;
}

@end
