//
//  UILabel+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VPAttributedFormat)

- (void)vp_setAttributedFormatArguments:(BOOL)keepFormat, ...;

- (void)vp_setAttributedFormatArguments:(va_list)arguments
                             keepFormat:(BOOL)keepFormat;

@end
