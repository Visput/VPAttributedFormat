//
//  VPConversionArgument.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPConversionArgument.h"

@interface VPConversionArgument ()

@property (nonatomic, assign) VPType type;
@property (nonatomic, assign) NSUInteger index;

@end

@implementation VPConversionArgument

- (instancetype)initWithType:(VPType)type
                       index:(NSUInteger)index; {
    self = [super init];
    if (self) {
        self.type = type;
        self.index = index;
    }
    return self;
}

@end
