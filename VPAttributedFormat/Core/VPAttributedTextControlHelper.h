//
//  VPAttributedTextControlHelper.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VPAttributedTextControl;

@interface VPAttributedTextControlHelper : NSObject

+ (instancetype)helperForTextControl:(NSObject<VPAttributedTextControl> *)textControl;

- (void)setAttributedFormatArguments:(va_list)arguments;

@end

@protocol VPAttributedTextControl <NSObject>

@property (nonatomic, copy) NSAttributedString *attributedText;

@end