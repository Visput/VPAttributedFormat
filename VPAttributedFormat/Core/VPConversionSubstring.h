//
//  VPConversionSubstring.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstring.h"

@interface VPConversionSubstring : VPSubstring

/// Array of VPConversionArgument.
@property (nonatomic, readonly, strong) NSArray *arguments;
@property (nonatomic, readonly, assign) BOOL isComplete;

- (NSString *)builtSubstring;

@end
