//
//  VPConversionArgument.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPValueWrapper.h"

@interface VPConversionArgument : NSObject

@property (nonatomic, strong) NSObject<VPValueWrapper> *valueWrapper; // See VPValueWrapper.h for full list of wrapper classes
@property (nonatomic, readonly, assign) NSUInteger index;

- (instancetype)initWithValueWrapper:(NSObject<VPValueWrapper> *)valueWrapper
                               index:(NSUInteger)index;

@end
