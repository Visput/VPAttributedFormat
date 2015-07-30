//
//  VPAttributedTextControlHelper.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPAttributedTextControl;

/**
 *  The VPAttributedTextControlHelper provides ability to build
 *  attributed string for ui controls that have 'attributedText' property.
 *  Currently 3 standard controls satisfy this condition: UILabel, UITextField, UITextView.
 */
@interface VPAttributedTextControlHelper : NSObject

/**
 *  Creates instance of VPAttributedTextControlHelper class that is associated with 'textControl' object.
 *  Method returns the same instance if it's called multiple times for the same 'textControl' object,
 *  Returned instance keeps weak reference to 'textControl' object.
 *
 *  @param textControl Object that have 'attributedText' property.
 *
 *  @return An instance of VPAttributedTextControlHelper class.
 */
+ (instancetype)helperForTextControl:(NSObject<VPAttributedTextControl> *)textControl;

/**
 *  Builds and sets attributed string to associated text control.
 *  It uses 'attributedText' property and 'arguments' parameter for building string.
 *  Correct attributed format has to be set to 'attributedText' property before calling this method.
 *  In other case behaviour is undefined.
 *
 *  @param arguments  List of arguments required by format.
 *                    Behaviour is undefined if arguments don't satisfy format.
 *  @param keepFormat Specify YES to keep format.
 *                    "Keep format" means that attributed format will be kept between
 *                    multiple calls of this method. It allows change arguments for
 *                    the same format.
 *                    Specify NO if you are going to call this method only once.
 *                    Less memory is used when format isn't kept.
 *                    Behaviour is undefined if this method called
 *                    multiple times with NO parameter.
 */
- (void)setAttributedFormatArguments:(va_list)arguments
                          keepFormat:(BOOL)keepFormat;

@end

/**
 *  The VPAttributedTextControl protocol declares 'attributedText' property. 
 *  It provides universal access to text controls that are instances of different classes,
 *  but all of them have such property.
 */
@protocol VPAttributedTextControl <NSObject>

/**
 *  Property that provides universal access to different text controls.
 */
@property (nonatomic, copy) NSAttributedString *attributedText;

@end