//
//  NSAttributedString+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (VPAttributedFormat)

+ (instancetype)attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat, ...;
- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat, ...;
- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat arguments:(va_list)arguments;

@end
