//
//  VPSubstringsContainer.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstringsContainer.h"

@interface VPSubstringsContainer ()

@property (nonatomic, strong) NSMutableArray *mutableSubstrings;

@end

@implementation VPSubstringsContainer

@dynamic substrings;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableSubstrings = [NSMutableArray array];
    }
    return self;
}

- (void)addSubstring:(VPSubstring *)substring {
    [self.mutableSubstrings addObject:substring];
}

#pragma mark -
#pragma mark Property

- (NSArray *)substrings {
    // Return mutable value instead of immutable copy for memory usage optimization
    return self.mutableSubstrings;
}


@end
