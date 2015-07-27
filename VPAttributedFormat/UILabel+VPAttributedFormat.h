//
//  UILabel+VPAttributedFormat.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (VPAttributedFormat)

- (void)vp_setAttributedFormatArguments:(id)nilValue, ...;
- (void)vp_setAttributedFormatArgumentsList:(va_list)arguments;

@end
