//
//  VPSubstring.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPSubstring class provides ability
 *  to store substring of any parent string.
 */
@interface VPSubstring : NSObject

/// String that is a part of parent string.
@property (nonatomic, readonly, strong) NSString *value;

/// Range of substring in parent string.
@property (nonatomic, readonly, assign) NSRange range;

/// Appends character to 'value' property.
- (void)appendCharacter:(unichar)character
 positionInParentString:(NSUInteger)position;

/// Sets 'value' to \@"", 'range' to NSMakeRange(NSNotFound, 0).
- (void)makeEmpty;

/// Checks if 'value' length is equal to 0.
- (BOOL)isEmpty;

@end
NS_ASSUME_NONNULL_END
