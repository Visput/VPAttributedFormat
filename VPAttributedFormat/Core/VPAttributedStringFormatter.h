//
//  VPAttributedStringFormatter.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPAttributedStringFormatter class builds attributed string
 *  based on attributed format and list of arguments.
 */
@interface VPAttributedStringFormatter : NSObject

/**
 *  Builds formatted attributed string.
 *
 *  For example: 
 *  if 'attributedFormat' contains string "1 + 1 = %d",
 *      where substring "%d" has bold font attribute and
 *     'arguments' contains int value 2,
 *  then result of this method will be attributed string
 *       that contains string "1 + 1 = 2",
 *       where substring "2" has bold font attribute.
 *
 *  NSAttributedString objects can be used as attributed format arguments.
 *  If format attributes have conflict with argument attributes then format attributes used with higher priority.
 *
 *  @param attributedFormat Object that represents string format with attributes.
 *                          Behaviour is undefined if format is wrong.
 *                          Raises an NSInvalidArgumentException if 'attributedFormat' is nil.
 *  @param arguments        List of arguments required by format.
 *                          Behaviour is undefined if arguments don't satisfy format.
 *
 *  @return An attributed string created by using 'attributedFormat' as a template
 *          into which the remaining 'arguments' values are substituted.
 */
- (NSAttributedString *)stringWithFormat:(NSAttributedString *)attributedFormat
                               arguments:(va_list)arguments;

@end
NS_ASSUME_NONNULL_END
