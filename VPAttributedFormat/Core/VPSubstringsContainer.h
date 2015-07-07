//
//  VPSubstringsContainer.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPSubstring;
@class VPConversionArgument;

@interface VPSubstringsContainer : NSObject

/// Array of VPSubstring.
@property (nonatomic, readonly, strong) NSArray *substrings;
@property (nonatomic, readonly, assign) NSUInteger conversionArgumentMaxIndex;

- (void)addSubstring:(VPSubstring *)substring;

/// Returns array of VPConversionArgument.
- (NSArray *)conversionArgumentsSortedByIndex;

@end
