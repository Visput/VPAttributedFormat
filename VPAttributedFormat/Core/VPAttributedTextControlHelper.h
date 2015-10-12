//
//  VPAttributedTextControlHelper.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPAttributedTextControlHelper provides ability to build
 *  attributed string for ui controls that support NSAttributedString values.
 *  Currently 4 standard controls satisfy this condition: UILabel, UITextField, UITextView, UIButton.
 */
@interface VPAttributedTextControlHelper : NSObject

/**
 *  Creates instance of VPAttributedTextControlHelper class that is associated with 'textControl' object.
 *  Method returns the same instance if it's called multiple times for the same 'textControl' object and
 *  the same `attributedTextKey` value.
 *  Returned instance keeps weak reference to 'textControl' object.
 *
 *  @param textControl       Any object that represents text control.
 *                           This parameter can't be nil.
 *  @param attributedTextKey Const pointer that is used as a key for association with `textControl` object.
 *                           This parameter can't be NULL.
 *
 *  @return An instance of VPAttributedTextControlHelper class.
 */
+ (instancetype)helperForTextControl:(id)textControl
                   attributedTextKey:(const void *)attributedTextKey;

/**
 *  Builds and sets attributed string to associated text control.
 *  It uses 'attributedTextGetter', 'attributedTextSetter' and 'arguments' parameters for building string.
 *  Correct attributed format has to be returned by calling 'attributedTextGetter' block.
 *  In other case behaviour is undefined.
 *
 *  @param arguments            List of arguments required by format.
 *                              Behaviour is undefined if arguments don't satisfy format.
 *  @param keepFormat           Specify YES to keep format.
 *                              "Keep format" means that attributed format will be kept between
 *                              multiple calls of this method. It allows change arguments for
 *                              the same format.
 *                              Specify NO if you are going to call this method only once.
 *                              Less memory is used when format isn't kept.
 *                              Behaviour is undefined if this method called
 *                              multiple times with NO parameter.
 *  @param attributedTextGetter Block object that has to return valid attributed string.
 *                              This parameter can't be NULL.
 *  @param attributedTextSetter Block object that has to use 'attributedText' parameter 
 *                              for setting attributed text in control.
 *                              This parameter can't be NULL.
 *
 */
- (void)setAttributedTextFormatArguments:(va_list)arguments
                              keepFormat:(BOOL)keepFormat
                    attributedTextGetter:(NSAttributedString *(^)(void))attributedTextGetter
                    attributedTextSetter:(void(^)(NSAttributedString *attributedText))attributedTextSetter;

@end
NS_ASSUME_NONNULL_END