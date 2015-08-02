//
//  UILabel+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This category provides methods for building and setting attributed string based on
 *  attributed format that is value of 'attributedText' property of UILabel instance
 *  and arguments that should satisfy this format.
 */
@interface UILabel (VPAttributedFormat)

/**
 *  Builds and sets attributed string to 'attributedText' property.
 *  It uses current or previously saved value of 'attributedText' property and list of arguments for building string.
 *  Correct attributed format has to be set to 'attributedText' property before calling this method.
 *  Usually you can initialize 'attributedText' property by configuring UILabel object in Interface Builder.
 *
 *  @param keepFormat Specify YES to keep format.
 *                    "Keep format" means that attributed format will be kept between
 *                    multiple calls of this method. It allows change arguments for the same format.
 *                    Specify NO if you are going to call this method only once.
 *                    Less memory is used when format isn't kept.
 *                    Behaviour is undefined if this method called multiple times with NO parameter.
 *  @param ...        A comma-separated list of arguments required by format.
 *                    Behaviour is undefined if arguments don't satisfy format.
 */
- (void)vp_setAttributedTextFormatArguments:(BOOL)keepFormat, ...;

/**
 *  Builds and sets attributed string to 'attributedText' property.
 *  It uses current or previously saved value of 'attributedText' property and 'arguments' parameter for building string.
 *  Correct attributed format has to be set to 'attributedText' property before calling this method.
 *  Usually you can initialize 'attributedText' property by configuring UILabel object in Interface Builder.
 *
 *  @param arguments  List of arguments required by format.
 *                    Behaviour is undefined if arguments don't satisfy format.
 *  @param keepFormat Specify YES to keep format.
 *                    "Keep format" means that attributed format will be kept between
 *                    multiple calls of this method. It allows change arguments for the same format.
 *                    Specify NO if you are going to call this method only once.
 *                    Less memory is used when format isn't kept.
 *                    Behaviour is undefined if this method called multiple times with NO parameter.
 */
- (void)vp_setAttributedTextFormatArguments:(va_list)arguments
                                 keepFormat:(BOOL)keepFormat;

@end
