//
//  NSAttributedString+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  This category provides methods for building attributed string based on
 *  attributed format and arguments that should satisfy this format.
 *
 *  The most suitable case of using this category is
 *  text controls with variable attributed text configured in Interface Builder.
 *  You need set correct string format to attributed text and configure necessary attributes.
 *  Then you need pass necessary arguments in code by using methods of this category.
 *  
 *  For example:
 *  if attributed format contains string "1 + 1 = %d",
 *     where substring "%d" has bold font attribute and
 *     arguments contain int value 2,
 *  then result of this category methods will be attributed string
 *       that contains string "1 + 1 = 2",
 *       where substring "2" has bold font attribute.
 *
 *  NSAttributedString objects can be used as attributed format arguments.
 *  If format attributes have conflict with argument attributes then format attributes used with higher priority.
 *
 *  @see Documentation and examples: https://github.com/Visput/VPAttributedFormat
 *  @see Documentation for format specifiers: https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
 */
@interface NSAttributedString (VPAttributedFormat)

/**
 *  Returns an NSAttributedString object initialized with a given attributed format and list of arguments.
 *
 *  @param attributedFormat Object that represents string format with attributes.
 *                          Behaviour is undefined if format is wrong.
 *                          Raises an NSInvalidArgumentException if 'attributedFormat' is nil.
 *
 *  @param ...              A comma-separated list of arguments to substitute into 'attributedFormat'.
 *                          Behaviour is undefined if arguments don't satisfy format.
 *
 *  @return An attributed string created by using 'attributedFormat' as a template
 *          into which the remaining argument values are substituted.
 */
+ (instancetype)vp_attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat, ...;

/**
 *  Returns an NSAttributedString object initialized with a given attributed format and list of arguments.
 *
 *  @param attributedFormat Object that represents string format with attributes.
 *                          Behaviour is undefined if format is wrong.
 *                          Raises an NSInvalidArgumentException if 'attributedFormat' is nil.
 *
 *  @param arguments        A list of arguments to substitute into 'attributedFormat'.
 *                          Behaviour is undefined if arguments don't satisfy format.
 *
 *  @return An attributed string created by using 'attributedFormat' as a template
 *          into which the remaining 'arguments' values are substituted.
 */
+ (instancetype)vp_attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat
                                              arguments:(va_list)arguments;

/**
 *  Returns an NSAttributedString object initialized with a given attributed format and list of arguments.
 *
 *  @param attributedFormat Object that represents string format with attributes.
 *                          Behaviour is undefined if format is wrong.
 *                          Raises an NSInvalidArgumentException if 'attributedFormat' is nil.
 *
 *  @param ...              A comma-separated list of arguments to substitute into 'attributedFormat'.
 *                          Behaviour is undefined if arguments don't satisfy format.
 *
 *  @return An attributed string created by using 'attributedFormat' as a template
 *          into which the remaining argument values are substituted.
 */
- (instancetype)vp_initWithAttributedFormat:(NSAttributedString *)attributedFormat, ... __attribute__((objc_method_family(init)));

/**
 *  Returns an NSAttributedString object initialized with a given attributed format and list of arguments.
 *
 *  @param attributedFormat Object that represents string format with attributes.
 *                          Behaviour is undefined if format is wrong.
 *                          Raises an NSInvalidArgumentException if 'attributedFormat' is nil.
 *
 *  @param arguments        A list of arguments to substitute into 'attributedFormat'.
 *                          Behaviour is undefined if arguments don't satisfy format.
 *
 *  @return An attributed string created by using 'attributedFormat' as a template
 *          into which the remaining 'arguments' values are substituted.
 */
- (instancetype)vp_initWithAttributedFormat:(NSAttributedString *)attributedFormat
                                  arguments:(va_list)arguments __attribute__((objc_method_family(init)));

@end
NS_ASSUME_NONNULL_END
