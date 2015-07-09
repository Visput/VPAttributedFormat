//
//  VPConversionSubstring.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstring.h"

/**
 *  The VPConversionSubstring class represents substring with single format and
 *  arguments related to this format.
 *  For example, format "%*d %g" contains two conversion substrings:
 *  1. "%*d" with two arguments: int width argument and int value argument;
 *  2. "%g" with one argument: double value argument.
 */
@interface VPConversionSubstring : VPSubstring

/// Array of VPConversionArgument objects.
@property (nonatomic, readonly, strong) NSArray *arguments;

/// Indicates if conversion substring is complete.
@property (nonatomic, readonly, assign) BOOL isComplete;

/**
 *  Builds formatted string.
 *
 *  Internally it uses 'stringWithFormat:' method of NSString class:
 *  [NSString stringWithFormat:self.value, self.arguments[0], self.arguments[1], ..];
 *
 *  @return A formated string built by using 'value' and 'arguments' properties.
 */
- (NSString *)buildSubstring;

@end
