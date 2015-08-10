//
//  UIButton+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 8/4/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  This category provides methods for building and setting attributed string based on
 *  attributed format that is result of 'attributedTitleForState:' UIButton method
 *  and arguments that should satisfy this format.
 */
@interface UIButton (VPAttributedFormat)

/**
 *  Builds and sets attributed string to button title for specified state.
 *  It uses current or previously saved result of 'attributedTitleForState:' method and list of arguments for building string.
 *  Correct attributed format has to be set to title for specified state before calling this method.
 *  Usually you can initialize attributed title for specified state by configuring UIButton object in Interface Builder.
 *
 *  @param state      The state that uses the specified attributed title.
 *                    The possible values are described in UIControlState.
 *  @param keepFormat Specify YES to keep format.
 *                    "Keep format" means that attributed format will be kept between
 *                    multiple calls of this method. It allows change arguments for the same format.
 *                    Specify NO if you are going to call this method only once.
 *                    Less memory is used when format isn't kept.
 *                    Behaviour is undefined if this method called multiple times with NO parameter.
 *  @param ...        A comma-separated list of arguments required by format.
 *                    Behaviour is undefined if arguments don't satisfy format.
 */
- (void)vp_setAttributedTitleFormatArgumentsForState:(UIControlState)state
                                          keepFormat:(BOOL)keepFormat, ...;

/**
 *  Builds and sets attributed string to button title for specified state.
 *  It uses current or previously saved result of 'attributedTitleForState:' method and list of arguments for building string.
 *  Correct attributed format has to be set to title for specified state before calling this method.
 *  Usually you can initialize attributed title for specified state by configuring UIButton object in Interface Builder.
 *
 *  @param arguments  A comma-separated list of arguments required by format.
 *                    Behaviour is undefined if arguments don't satisfy format.
 *  @param state      The state that uses the specified attributed title.
 *                    The possible values are described in UIControlState.
 *  @param keepFormat Specify YES to keep format.
 *                    "Keep format" means that attributed format will be kept between
 *                    multiple calls of this method. It allows change arguments for the same format.
 *                    Specify NO if you are going to call this method only once.
 *                    Less memory is used when format isn't kept.
 *                    Behaviour is undefined if this method called multiple times with NO parameter.
 */
- (void)vp_setAttributedTitleFormatArguments:(va_list)arguments
                                    forState:(UIControlState)state
                                  keepFormat:(BOOL)keepFormat;


@end
