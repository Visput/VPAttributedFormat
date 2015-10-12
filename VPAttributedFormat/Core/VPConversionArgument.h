//
//  VPConversionArgument.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VPValueWrapper.h"

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPConversionArgument class represents conversion argument in string format.
 *  For example, format '%d %g' has two arguments:
 *  int value with index '0' and double value with index '1'.
 */
@interface VPConversionArgument : NSObject

/// See VPValueWrapper.h for full list of wrapper classes.
@property (nonatomic, strong) NSObject<VPValueWrapper> *valueWrapper;

/// Argument position in the format.
@property (nonatomic, readonly, assign) NSInteger index;

/// Creates instance of VPConversionArgument class that is initalized with value wrapper and argument index.
- (instancetype)initWithValueWrapper:(NSObject<VPValueWrapper> *)valueWrapper
                               index:(NSInteger)index;

@end
NS_ASSUME_NONNULL_END