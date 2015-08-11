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
#define SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(class_name, value_type, argument_type)                    \
                                                                                                                   \
@interface class_name ()                                                                                           \
                                                                                                                   \
@property (nonatomic, assign) value_type value;                                                                    \
                                                                                                                   \
@end                                                                                                               \
                                                                                                                   \
@implementation class_name                                                                                         \
                                                                                                                   \
- (void)setValueByArgumentsValue:(va_list)arguments {                                                              \
    self.value = va_arg(arguments, argument_type);                                                                 \
}                                                                                                                  \
                                                                                                                   \
- (void)setValueByArgumentsPointer:(va_list *)arguments {                                                          \
    self.value = va_arg(*arguments, argument_type);                                                                \
}                                                                                                                  \
                                                                                                                   \
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format {                                      \
    NSString *string = [NSString stringWithFormat:format, self.value];                                             \
    return [[NSAttributedString alloc] initWithString:string];                                                     \
}                                                                                                                  \
                                                                                                                   \
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format                                        \
                                 widthOrPrecisionWrapper:(VPIntValueWrapper *)widthOrPrecisionWrapper {            \
    NSString *string = [NSString stringWithFormat:format, widthOrPrecisionWrapper.value, self.value];              \
    return [[NSAttributedString alloc] initWithString:string];                                                     \
}                                                                                                                  \
                                                                                                                   \
- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format                                        \
                                            widthWrapper:(VPIntValueWrapper *)widthWrapper                         \
                                        precisionWrapper:(VPIntValueWrapper *)precisionWrapper {                   \
    NSString *string = [NSString stringWithFormat:format, widthWrapper.value, precisionWrapper.value, self.value]; \
    return [[NSAttributedString alloc] initWithString:string];                                                     \
}                                                                                                                  \
                                                                                                                   \
- (id)copyWithZone:(NSZone *)zone {                                                                                \
    class_name *copy = [[[self class] allocWithZone:zone] init];                                                   \
    copy.value = self.value;                                                                                       \
    return copy;                                                                                                   \
}                                                                                                                  \
                                                                                                                   \
@end                                                                                                               \

#define SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION(class_name, value_type)              \
SYNTHESIZE_VALUE_WRAPPER_IMPLEMENTATION_EXTENDED(class_name, value_type, value_type) \

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

/**
 *  VPIdValueWrapper is implemented separately from other kinds of wrappers because
 *  values that are instances of NSAttributedString and its subclasses have to be
 *  handled in special manner.
 *  It's handled in such way:
 *  1. 'string' property is used for bulding formated string.
 *  2. All attributes are migrated to result formated string.
 *  Such logic allows to use NSAttributedString objects as format arguments.
 */
@interface VPIdValueWrapper ()

@property (nonatomic, assign) id value;

@end                                                                                                               

@implementation VPIdValueWrapper

- (void)setValueByArgumentsValue:(va_list)arguments {                                                              
    self.value = va_arg(arguments, id);
}                                                                                                                  

- (void)setValueByArgumentsPointer:(va_list *)arguments {                                                          
    self.value = va_arg(*arguments, id);
}                                                                                                                  

- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format {                                      
    NSString *string = [NSString stringWithFormat:format, self.valueForFormat];
    return [self attributedStringWithString:string];
}                                                                                                                  

- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format                                        
                                 widthOrPrecisionWrapper:(VPIntValueWrapper *)widthOrPrecisionWrapper {
    NSString *string = [NSString stringWithFormat:format, widthOrPrecisionWrapper.value, self.valueForFormat];
    return [self attributedStringWithString:string];
}                                                                                                                  

- (NSAttributedString *)attributedStringWithSingleFormat:(NSString *)format                                        
                                            widthWrapper:(VPIntValueWrapper *)widthWrapper
                                        precisionWrapper:(VPIntValueWrapper *)precisionWrapper {
    NSString *string = [NSString stringWithFormat:format, widthWrapper.value, precisionWrapper.value, self.valueForFormat];
    return [self attributedStringWithString:string];
}

- (id)copyWithZone:(NSZone *)zone {                                                                                
    VPIdValueWrapper *copy = [[[self class] allocWithZone:zone] init];
    copy.value = self.value;                                                                                       
    return copy;                                                                                                   
}

#pragma mark -
#pragma mark Private

- (NSAttributedString *)attributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    if ([self.value isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *attributedValue = self.value;
        
        [attributedValue enumerateAttributesInRange:NSMakeRange(0, attributedValue.length)
                                            options:0
                                         usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
                                             [attributedString addAttributes:attributes range:range];
                                         }];
    }
    
    return attributedString.copy;
}

- (id)valueForFormat {
    id value = nil;
    if ([self.value isKindOfClass:[NSAttributedString class]]) {
        value = [self.value string];
    } else {
        value = self.value;
    }
    return value;
}

@end
