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
@class VPConversionSubstring;

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPSubstringsContainer class provides suitable interface for managing
 *  VPSubstring and VPConversionSubstring objects and their arguments.
 */
@interface VPSubstringsContainer : NSObject

/// Array of VPSubstring and VPConversionSubstring objects.
@property (nonatomic, readonly, strong) NSArray<VPSubstring *> *substrings;

/**
 *  Represents maximum index of arguments that were added as part of VPConversionSubstring objects.
 *  -1 if container doesn't have any arguments.
 */
@property (nonatomic, readonly, assign) NSInteger conversionArgumentMaxIndex;

/// Adds substring to the end of the 'substrings' array property.
- (void)addSubstring:(VPSubstring *)substring;

/// Returns array of VPConversionArgument objects that is sorted in ascending index.
- (NSArray<VPConversionArgument *> *)conversionArgumentsSortedByIndex;

@end
NS_ASSUME_NONNULL_END
