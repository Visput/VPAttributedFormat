//
//  VPSubstring.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstring.h"
#import "VPSubstring_Protected.h"

@implementation VPSubstring

@dynamic value;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableValue = [NSMutableString string];
        self.range = NSMakeRange(NSNotFound, 0);
    }
    return self;
}

- (void)appendCharacter:(unichar)character
 positionInParentString:(NSUInteger)position {
    [self.mutableValue appendFormat:@"%c", character];
    
    if (self.range.location == NSNotFound) {
        _range.location = position;
    }
    _range.length += 1;
}

- (void)makeEmpty {
    [self.mutableValue setString:@""];
    self.range = NSMakeRange(NSNotFound, 0);
}

- (BOOL)isEmpty {
    return self.mutableValue.length == 0;
}

- (NSString *)builtSubstring {
    return self.value;
}

#pragma mark -
#pragma mark Property

- (NSString *)value {
    // Return mutable value instead of immutable copy for memory usage optimization
    return self.mutableValue;
}

@end
