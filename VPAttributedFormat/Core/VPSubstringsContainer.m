//
//  VPSubstringsContainer.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSubstringsContainer.h"
#import "VPConversionSubstring.h"
#import "VPConversionArgument.h"

@interface VPSubstringsContainer ()

@property (nonatomic, strong) NSMutableArray<VPSubstring *> *mutableSubstrings;
@property (nonatomic, strong) NSMutableArray<VPConversionSubstring *> *mutableConversionSubstrings;
@property (nonatomic, strong) NSMutableArray<VPConversionArgument *> *mutableConversionArguments;
@property (nonatomic, assign) NSInteger conversionArgumentMaxIndex;

@end

@implementation VPSubstringsContainer

@dynamic substrings;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableSubstrings = [NSMutableArray array];
        self.mutableConversionSubstrings = [NSMutableArray array];
        self.mutableConversionArguments = [NSMutableArray array];
        self.conversionArgumentMaxIndex = -1;
    }
    return self;
}

- (void)addSubstring:(VPSubstring *)substring {
    [self.mutableSubstrings addObject:substring];
    
    if ([substring isKindOfClass:[VPConversionSubstring class]]) {
        [self addConversionSubstring:(VPConversionSubstring *)substring];
    }
}

- (NSArray<VPConversionArgument *> *)conversionArgumentsSortedByIndex {
    return [self.mutableConversionArguments sortedArrayUsingComparator:^NSComparisonResult(VPConversionArgument *argument1, VPConversionArgument *argument2) {
        return argument1.index > argument2.index;
    }];
}

#pragma mark -
#pragma mark Property

- (NSArray<VPSubstring *> *)substrings {
    // Return mutable value instead of immutable copy for memory usage optimization.
    return self.mutableSubstrings;
}

#pragma mark -
#pragma mark Private

- (void)addConversionSubstring:(VPConversionSubstring *)conversionSubstring {
    [self.mutableConversionSubstrings addObject:conversionSubstring];
    for (VPConversionArgument *argument in conversionSubstring.arguments) {
        [self addConversionAgument:argument];
    }
}

- (void)addConversionAgument:(VPConversionArgument *)conversionArgument {
    [self.mutableConversionArguments addObject:conversionArgument];
    
    if (conversionArgument.index == NSNotFound) { // Arguments have natural order.
        self.conversionArgumentMaxIndex = self.mutableConversionArguments.count - 1;
    } else {
        self.conversionArgumentMaxIndex = MAX(self.conversionArgumentMaxIndex, conversionArgument.index);
    }
}

@end
