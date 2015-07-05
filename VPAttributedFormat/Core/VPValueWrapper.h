//
//  VPValueWrapper.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPIntValueWrapper;

@protocol VPValueWrapper <NSObject, NSCopying>

- (void)setValueByArguments:(va_list)arguments;

- (NSString *)stringWithSingleFormat:(NSString *)format;

- (NSString *)stringWithSingleFormat:(NSString *)format
             widthOrPrecisionWrapper:(VPIntValueWrapper *)widthOrPrecisionWrapper;

- (NSString *)stringWithSingleFormat:(NSString *)format
                        widthWrapper:(VPIntValueWrapper *)widthWrapper
                    precisionWrapper:(VPIntValueWrapper *)precisionWrapper;

@end

#define SYNTHESIZE_VALUE_WRAPPER_INTERFACE(class_name, value_type) \
                                                                   \
@interface class_name : NSObject <VPValueWrapper>                  \
                                                                   \
@property (nonatomic, readonly, assign) value_type value;          \
                                                                   \
@end                                                               \

SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPIdValueWrapper, id)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPVoidPointerValueWrapper, void *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPCharValueWrapper, char)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPCharPointerValueWrapper, char *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPSignedCharPointerValueWrapper, signed char *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnsignedCharValueWrapper, unsigned char)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnicharValueWrapper, unichar)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnicharPointerValueWrapper, unichar *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPShortValueWrapper, short)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPShortPointerValueWrapper, short *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnsignedShortValueWrapper, unsigned short)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPIntValueWrapper, int)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPIntPointerValueWrapper, int *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnsignedIntValueWrapper, unsigned int)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPWint_tValueWrapper, wint_t)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPIntmax_tValueWrapper, intmax_t)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPIntmax_tPointerValueWrapper, intmax_t *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUintmax_tValueWrapper, uintmax_t)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPSize_tValueWrapper, size_t)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPSize_tPointerValueWrapper, size_t *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPPtrdiff_tValueWrapper, ptrdiff_t)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPPtrdiff_tPointerValueWrapper, ptrdiff_t *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPLongValueWrapper, long)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPLongPointerValueWrapper, long *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnsignedLongValueWrapper, unsigned long)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPLongLongValueWrapper, long long)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPLongLongPointerValueWrapper, long long *)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPUnsignedLongLongValueWrapper, unsigned long long)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPDoubleValueWrapper, double)
SYNTHESIZE_VALUE_WRAPPER_INTERFACE(VPLongDoubleValueWrapper, long double)

