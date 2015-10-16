//
//  VPValueWrapper.h
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/29/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <Foundation/Foundation.h>

@class VPIntValueWrapper;

NS_ASSUME_NONNULL_BEGIN
/**
 *  The VPValueWrapper protocol declares methods for providing
 *  universal access to different value wrappers classes.
 *  See VPValueWrapper.h for full list of such classes.
 */
@protocol VPValueWrapper <NSObject, NSCopying>

/**
 *  Initializes wrapped value by reading next argument in 'arguments' variable.
 *  Class that implements this method has to internally decide value with which type
 *  has to be read from 'arguments' variable.
 *
 *  @attention This method has to be called only on @b simulators with @b 64-bit processor architecture.
 *             In other case behaviour is undefined.
 *             On simulators with 64-bit processor architecture 'va_list' parameters are passed by reference.
 *
 *  @param arguments Object of 'va_list' type that contains value that has to be wrapped.
 */
- (void)setValueByArgumentsValue:(va_list)arguments;

/**
 *  Initializes wrapped value by reading next argument in 'arguments' variable.
 *  Class that implements this method has to internally decide value with which type
 *  has to be read from 'arguments' variable.
 *
 *  @attention This method has to be called only on @b simulators with @b 32-bit processor architecture and
 *             @b devices with @b any processor architecture.
 *             In other case behaviour is undefined.
 *             On simulators with 32-bit processor architecture and devices with any processor architecture
 *             'va_list' parameters are passed by value.
 *
 *  @param arguments Pointer to object of 'va_list' type that contains value that has to be wrapped.
 */
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnullability-completeness"
- (void)setValueByArgumentsPointer:(va_list *)arguments;
#pragma clang diagnostic pop

/**
 *  Builds and returns formatted string by using 'format' variable and self wrapped value
 *  that was read by calling 'setValueByArguments:' method.
 *  Single argument format has to be passed as parameter for this method.
 *  Example of such format is "%g". Such format can be used in class that wraps 'double' value.
 *  Returned object contains attributes only if format argument is instance of NSAttributedString or its subclasses.
 *  In this case argument attributes are migrated to result string.
 *
 *  @param format String format that is usually used in [NSString stringWithFormat:] call.
 *
 *  @return A formatted attributed string.
 */
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format;

/**
 *  Builds and returns formatted string by using 'format' variable, self wrapped value and
 *  value that is wrapped by 'widthOrPrecisionWrapper' variable.
 *  Format with two arguments has to be passed as parameter for this method.
 *  Examples of such format are "%*g" or "%.*g". Such formats can be used in class that wraps 'double' value.
 *  Returned object contains attributes only if format argument is instance of NSAttributedString or its subclasses.
 *  In this case argument attributes are migrated to result string.
 *
 *  @param format                  String format that is usually used in [NSString stringWithFormat:] call.
 *  @param widthOrPrecisionWrapper Int wrapper that represents argument width or precision.
 *
 *  @return A formatted attributed string.
 */
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format
                                 widthOrPrecisionWrapper:(VPIntValueWrapper *)widthOrPrecisionWrapper;

/**
 *  Builds and returns formatted string by using 'format' variable, self wrapped value and
 *  values that are wrapped by 'widthWrapper' and 'precisionWrapper' variables.
 *  Format with three arguments has to be passed as parameter for this method.
 *  Example of such format is "%*.*g". Such format can be used in class that wraps 'double' value.
 *  Returned object contains attributes only if format argument is instance of NSAttributedString or its subclasses.
 *  In this case argument attributes are migrated to result string.
 *
 *  @param format           String format that is usually used in [NSString stringWithFormat:] call.
 *  @param widthWrapper     Int wrapper that represents argument width.
 *  @param precisionWrapper Int wrapper that represents argument precision.
 *
 *  @return A formatted attributed string.
 */
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format
                                            widthWrapper:(VPIntValueWrapper *)widthWrapper
                                        precisionWrapper:(VPIntValueWrapper *)precisionWrapper;

@end

/**
 *  This macro represents code for value wrapper interface generation.
 *  It makes easy to generate interfaces for value wrappers classes that wrap values with different types.
 *  The reason of generating these classes is ability to store values with different primitive types
 *  as property in other object.
 *
 *  Class-wrappers allow to avoid using multiple if-else / switch-case constructions.
 *
 *  @param class_name Name of class that has to be generated.
 *  @param value_type Type of value that has to be wrapped.
 */
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
NS_ASSUME_NONNULL_END
