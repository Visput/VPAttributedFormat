//
//  VPSpecifiersProvider.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/13/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPSpecifiersProvider class provides access to different kind of specifiers and modifiers.
 *  See below links for understading type and conversion specifiers and length modifiers.
 *  Documentation links:
 *  NSString. Format specifiers: https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
 *  IEEE. Formatted output: http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
 */
@interface VPSpecifiersProvider : NSObject

/**
 *  Lazily loaded dictionary that contains value wrapper class names and related to them list of type specifiers.
 *  Keys are NSString objects. Every string represents unique value wrapper class name.
 *  Values are NSSet objects. Every object represents set of NSString objects.
 *  Every string represents unique type specifier, for example: \@"lld".
 *  @see VPValueWrapper.h for full list of value wrapper classes.
 */
@property (nonatomic, readonly, strong) NSDictionary<NSString *, NSSet<NSString *> *> *wrapperClassSpecifiers;

/// Lazily loaded set of NSNumber objects. Every number represents unique conversion specifier char, for example: \@'d'.
@property (nonatomic, readonly, strong) NSSet<NSNumber *> *conversionSpecifiers;

/// Lazily loaded set of NSNumber objects. Every number represents unique length modifier char, for example: \@'l'.
@property (nonatomic, readonly, strong) NSSet<NSNumber *> *lengthModifiers;

/// Lazily loaded set of NSNumber objects. Every number represents unique digit char, for example: \@'1'.
@property (nonatomic, readonly, strong) NSSet<NSNumber *> *digits;

@end
NS_ASSUME_NONNULL_END
