//
//  VPSubstring.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPSubstring : NSObject

@property (nonatomic, readonly, strong) NSString *value;
@property (nonatomic, readonly, assign) NSRange range;

- (void)appendCharacter:(unichar)character
 positionInParentString:(NSUInteger)position;

- (void)makeEmpty;

- (BOOL)isEmpty;

@end
