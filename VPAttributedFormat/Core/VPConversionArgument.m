//
//  VPConversionArgument.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPConversionArgument.h"

@interface VPConversionArgument ()

@property (nonatomic, assign) NSInteger index;

@end

@implementation VPConversionArgument

- (instancetype)initWithValueWrapper:(NSObject<VPValueWrapper> *)valueWrapper
                               index:(NSInteger)index {
    self = [super init];
    if (self) {
        self.valueWrapper = valueWrapper;
        self.index = index;
    }
    return self;
}

@end
