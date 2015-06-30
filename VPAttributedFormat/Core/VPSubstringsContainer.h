//
//  VPSubstringsContainer.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPSubstring;

@interface VPSubstringsContainer : NSObject

@property (nonatomic, readonly, strong) NSArray *substrings; // Array VPSubstring

- (void)addSubstring:(VPSubstring *)substring;

@end
