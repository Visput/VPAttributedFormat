//
//  VPConversionSubstring.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstring.h"

@class VPSpecifiersProvider;
@class VPConversionArgument;

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPConversionSubstring class represents substring with single format and
 *  arguments related to this format.
 *  For example, format "%*d %g" contains two conversion substrings:
 *  1. "%*d" with two arguments: int width argument and int value argument;
 *  2. "%g" with one argument: double value argument.
 */
@interface VPConversionSubstring : VPSubstring

/// Array of VPConversionArgument objects.
@property (nonatomic, readonly, strong) NSArray<VPConversionArgument *> *arguments;

/// Indicates if conversion substring is complete.
@property (nonatomic, readonly, assign) BOOL isComplete;

/**
 *  Creates instance of VPConversionSubstring class that is initalized with specifiers provider.
 *
 *  @param provider An object that provides access to different kind of specifiers.
 *                  This object passed as parameter for ability to share it between
 *                  multiple instances of VPConversionSubstring class.
 *
 *  @return An instance of VPConversionSubstring class.
 */
- (instancetype)initWithSpecifiersProvider:(VPSpecifiersProvider *)provider;

/**
 *  Builds formatted attributed string.
 *
 *  Internally it uses 'stringWithFormat:' method of NSString class:
 *  [NSString stringWithFormat:self.value, self.arguments[0], self.arguments[1], ..];
 *  Result NSString object is used for creating NSAttributedString object.
 *  Basically returned object doesn't contain any attributes.
 *  It contains attributes only if conversion argument is instance of NSAttributedString or its subclasses.
 *  In this case argument attributes are migrated to result string.
 *
 *  @return A formated attributed string built by using 'value' and 'arguments' properties.
 */
- (nullable NSAttributedString *)buildAttributedSubstring;

@end
NS_ASSUME_NONNULL_END
