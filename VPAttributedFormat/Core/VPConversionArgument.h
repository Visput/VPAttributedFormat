//
//  VPConversionArgument.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, VPType) {
    VPTypeUnknown = 0,
    VPTypeId,
    VPTypeVoidPointer,
    VPTypeChar,
    VPTypeCharPointer,
    VPTypeSignedCharPointer,
    VPTypeUnsignedChar,
    VPTypeUnichar,
    VPTypeUnicharPointer,
    VPTypeShort,
    VPTypeShortPointer,
    VPTypeUnsignedShort,
    VPTypeInt,
    VPTypeIntPointer,
    VPTypeUnsignedInt,
    VPTypeWint_t,
    VPTypeIntmax_t,
    VPTypeIntmax_tPointer,
    VPTypeUintmax_t,
    VPTypeSize_t,
    VPTypeSize_tPointer,
    VPTypePtrdiff_t,
    VPTypePtrdiff_tPointer,
    VPTypeLong,
    VPTypeLongPointer,
    VPTypeUnsignedLong,
    VPTypeLongLong,
    VPTypeLongLongPointer,
    VPTypeUnsignedLongLong,
    VPTypeDouble,
    VPTypeLongDouble
};

@interface VPConversionArgument : NSObject

@property (nonatomic, readonly, assign) VPType type;
@property (nonatomic, readonly, assign) NSUInteger index;

@property (nonatomic, strong) id valueWrapper; // See VPValueWrapper.h for full list of wrapper classes

- (instancetype)initWithType:(VPType)type
                       index:(NSUInteger)index;

@end
