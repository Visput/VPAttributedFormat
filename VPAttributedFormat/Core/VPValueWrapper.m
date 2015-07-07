//
//  VPValueWrapper.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPValueWrapper.h"

/**
 *  This macro represents code for value wrapper implementation generation.
 *  It makes easy to generate implementations for value wrappers classes that wrap values with different types.
 *  The reason of generating these classes is ability to store values with different primitive types
 *  as property in other object.
 *  Class-wrappers allow to avoid using multiple if-else / switch-case constructions.
 *
 *  @param class_name    Name of class that has to be generated.
 *  @param value_type    Type of value that has to be wrapped.
 *  @param argument_type Type of argument that has to be read from variable argument list.
 */
#define SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(class_name, value_type, argument_type)        \
                                                                                                       \
@interface class_name ()                                                                               \
                                                                                                       \
@property (nonatomic, assign) value_type value;                                                        \
                                                                                                       \
@end                                                                                                   \
                                                                                                       \
@implementation class_name                                                                             \
                                                                                                       \
- (void)setValueByArguments:(va_list)arguments {                                                       \
    self.value = va_arg(arguments, argument_type);                                                     \
}                                                                                                      \
                                                                                                       \
- (NSString *)stringWithSingleFormat:(NSString *)format {                                              \
    return [NSString stringWithFormat:format, self.value];                                             \
}                                                                                                      \
                                                                                                       \
- (NSString *)stringWithSingleFormat:(NSString *)format                                                \
             widthOrPrecisionWrapper:(VPIntValueWrapper *)widthOrPrecisionWrapper {                    \
    return [NSString stringWithFormat:format, widthOrPrecisionWrapper.value, self.value];              \
}                                                                                                      \
                                                                                                       \
- (NSString *)stringWithSingleFormat:(NSString *)format                                                \
                        widthWrapper:(VPIntValueWrapper *)widthWrapper                                 \
                    precisionWrapper:(VPIntValueWrapper *)precisionWrapper {                           \
    return [NSString stringWithFormat:format, widthWrapper.value, precisionWrapper.value, self.value]; \
}                                                                                                      \
                                                                                                       \
- (id)copyWithZone:(NSZone *)zone {                                                                    \
    class_name *copy = [[[self class] allocWithZone:zone] init];                                       \
    copy.value = self.value;                                                                           \
    return copy;                                                                                       \
}                                                                                                      \
                                                                                                       \
@end                                                                                                   \

#define SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(class_name, value_type)              \
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(class_name, value_type, value_type) \

SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPIdValueWrapper, id)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPVoidPointerValueWrapper, void *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPCharPointerValueWrapper, char *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPSignedCharPointerValueWrapper, signed char *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPUnicharPointerValueWrapper, unichar *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPShortPointerValueWrapper, short *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPIntValueWrapper, int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPIntPointerValueWrapper, int *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPUnsignedIntValueWrapper, unsigned int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPWint_tValueWrapper, wint_t)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPIntmax_tValueWrapper, intmax_t)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPIntmax_tPointerValueWrapper, intmax_t *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPUintmax_tValueWrapper, uintmax_t)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPSize_tValueWrapper, size_t)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPSize_tPointerValueWrapper, size_t *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPPtrdiff_tValueWrapper, ptrdiff_t)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPPtrdiff_tPointerValueWrapper, ptrdiff_t *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPLongValueWrapper, long)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPLongPointerValueWrapper, long *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPUnsignedLongValueWrapper, unsigned long)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPLongLongValueWrapper, long long)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPLongLongPointerValueWrapper, long long *)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPUnsignedLongLongValueWrapper, unsigned long long)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPDoubleValueWrapper, double)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(VPLongDoubleValueWrapper, long double)

// Compiler requires 'int' argument type for primitive types that are described below
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(VPUnsignedCharValueWrapper, unsigned char, int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(VPUnicharValueWrapper, unichar, int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(VPCharValueWrapper, char, int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(VPShortValueWrapper, short, int)
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(VPUnsignedShortValueWrapper, unsigned short, int)

