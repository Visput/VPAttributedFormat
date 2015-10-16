//
//  VPSubstring_Protected.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstring.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  This extension provides write access to VPSubstring class properties.
 *  Only VPSubstring subclasses can use this extension.
 */
@interface VPSubstring ()

@property (nonatomic, strong) NSMutableString *mutableValue;
@property (nonatomic, assign) NSRange range;

@end
NS_ASSUME_NONNULL_END
