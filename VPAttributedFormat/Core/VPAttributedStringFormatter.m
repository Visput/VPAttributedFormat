//
//  VPAttributedStringFormatter.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPAttributedStringFormatter.h"
#import "VPSubstring.h"
#import "VPConversionSubstring.h"
#import "VPSubstringsContainer.h"
#import "VPConversionArgument.h"
#import "VPValueWrapper.h"

@implementation VPAttributedStringFormatter

- (NSAttributedString *)stringWithFormat:(NSAttributedString *)attributedFormat
                               arguments:(va_list)arguments {
    if (attributedFormat == nil) {
        // This parameter can't be nil
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter \"attributedFormat\" can't be nil"
                                     userInfo:nil];
    }

    VPSubstringsContainer *substringsContainer = [self parseFormat:attributedFormat.string];
    NSAttributedString *attributedString = [self buildStringWithContainer:substringsContainer
                                                         attributedFormat:attributedFormat
                                                                arguments:arguments];
    
    return attributedString;
}

#pragma mark -
#pragma mark Private

- (VPSubstringsContainer *)parseFormat:(NSString *)formatString {
    static unichar const VPConversionIndicator = '%';
    static NSString *const VPPercentSymbol = @"%%";
    
    VPSubstringsContainer *substringsContainer = [[VPSubstringsContainer alloc] init];
    VPSubstring *ordinarySubstring = [[VPSubstring alloc] init];
    VPConversionSubstring *conversionSubstring = [[VPConversionSubstring alloc] init];
    
    for (int characterIndex = 0; characterIndex < formatString.length; ++characterIndex) {
        unichar formatCharacter = [formatString characterAtIndex:characterIndex];
        
        if (!conversionSubstring.isEmpty) { // Character is part of conversion substring or percent "%%" symbol
            
            [conversionSubstring appendCharacter:formatCharacter
                          positionInParentString:characterIndex];
            
            if ([conversionSubstring.value isEqualToString:VPPercentSymbol]) { // Character is part of percent "%%" symbol
                
                // Reset conversion substring because '%' was added by mistake
                [conversionSubstring makeEmpty];
                
                // "%" is ordinary character, append it to ordinary substring
                [ordinarySubstring appendCharacter:formatCharacter
                            positionInParentString:characterIndex];
                
            } else { // Character is part of conversion substring
                
                if (conversionSubstring.isComplete) {
                    [substringsContainer addSubstring:conversionSubstring];
                    
                    // Create new object for next conversion substring
                    conversionSubstring = [[VPConversionSubstring alloc] init];
                }
            }
            
        } else {
            if (formatCharacter == VPConversionIndicator) { // Character is part of conversion substring or percent "%%" symbol
                if (!ordinarySubstring.isEmpty) {
                    
                    // Ordinary string is ended
                    // Add to container
                    [substringsContainer addSubstring:ordinarySubstring];
                    
                    // Create new object for next ordinary substring
                    ordinarySubstring = [[VPSubstring alloc] init];
                }
                
                // Append character to conversion substring
                // If character is part of percent "%%" symbol then it will be fixed in next iteration of cycle
                [conversionSubstring appendCharacter:formatCharacter
                              positionInParentString:characterIndex];
                
            } else { // Character is part of ordinary substring
                
                [ordinarySubstring appendCharacter:formatCharacter
                            positionInParentString:characterIndex];
            }
        }
    }
    
    // If attributed format ends with ordinary substring then it has to be added to container
    if (!ordinarySubstring.isEmpty) {
        [substringsContainer addSubstring:ordinarySubstring];
    }
    
    // If attributed format ends with convesion substring then it has to be added to container
    if (!conversionSubstring.isEmpty) {
        if (conversionSubstring.isComplete) {
            [substringsContainer addSubstring:conversionSubstring];
            
        } else {
            // Conversion substring is incomplete
            // It means that attributedFormat is invalid
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:[NSString stringWithFormat:@"Wrong format specifier is used in \"attributedFormat\" substring: %@", conversionSubstring]
                                         userInfo:nil];
        }
    }
    
    return substringsContainer;
}

- (NSAttributedString *)buildStringWithContainer:(VPSubstringsContainer *)substringsContainer
                                attributedFormat:(NSAttributedString *)attributedFormat
                                       arguments:(va_list)arguments {
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSArray *conversionArguments = substringsContainer.conversionArgumentsSortedByIndex;
    NSUInteger conversionArgumentsIndex = 0;
    NSMutableArray *sameIndexArguments = [NSMutableArray array];
    
    for (NSUInteger i = 0; i <= substringsContainer.conversionArgumentMaxIndex; i++) {
        
        VPConversionArgument *conversionArgument = conversionArguments[conversionArgumentsIndex];
        [sameIndexArguments removeAllObjects]; // Clean array before executing new iteration
        [sameIndexArguments addObject:conversionArgument];
        ++conversionArgumentsIndex;
        if (conversionArgument.index != NSNotFound) { // Few arguments can have the same index only if indexes are obviously set
            BOOL needsStop = NO;
            while (!needsStop) {
                conversionArgument = conversionArguments[conversionArgumentsIndex];
                if (conversionArgument.index == i) {
                    [sameIndexArguments addObject:conversionArgument];
                    ++conversionArgumentsIndex;
                } else {
                    needsStop = YES;
                }
            }
        }
        
        switch (conversionArgument.type) {
            case VPTypeUnknown: {
                NSAssert(0, @"Wrong type for argument %@", conversionArgument);
                break;
            }
            case VPTypeId: {
                id value = va_arg(arguments, id);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPIdValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeVoidPointer: {
                void *value = va_arg(arguments, void *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPVoidPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeChar: {
                char value = va_arg(arguments, int); // int is required by compiler
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPCharValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeCharPointer: {
                char *value = va_arg(arguments, char *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPCharPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeSignedCharPointer: {
                signed char *value = va_arg(arguments, signed char *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPSignedCharPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnsignedChar: {
                unsigned char value = va_arg(arguments, int); // int is required by compiler
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnsignedCharValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnichar: {
                unichar value = va_arg(arguments, int); // int is required by compiler
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnicharValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnicharPointer: {
                unichar *value = va_arg(arguments, unichar *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnicharPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeShort: {
                short value = va_arg(arguments, int); // int is required by compiler
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPShortValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeShortPointer: {
                short *value = va_arg(arguments, short *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPShortPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnsignedShort: {
                unsigned short value = va_arg(arguments, int); // int is required by compiler
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnsignedShortValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeInt: {
                int value = va_arg(arguments, int);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPIntValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeIntPointer: {
                int *value = va_arg(arguments, int *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPIntPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnsignedInt: {
                unsigned int value = va_arg(arguments, unsigned int);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnsignedIntValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeWint_t: {
                wint_t value = va_arg(arguments, wint_t);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPWint_tValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeIntmax_t: {
                intmax_t value = va_arg(arguments, intmax_t);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPIntmax_tValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeIntmax_tPointer: {
                intmax_t *value = va_arg(arguments, intmax_t *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPIntmax_tPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUintmax_t: {
                uintmax_t value = va_arg(arguments, uintmax_t);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUintmax_tValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeSize_t: {
                size_t value = va_arg(arguments, size_t);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPSize_tValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeSize_tPointer: {
                size_t *value = va_arg(arguments, size_t *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPSize_tPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypePtrdiff_t: {
                ptrdiff_t value = va_arg(arguments, ptrdiff_t);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPPtrdiff_tValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypePtrdiff_tPointer: {
                ptrdiff_t *value = va_arg(arguments, ptrdiff_t *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPPtrdiff_tPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeLong: {
                long value = va_arg(arguments, long);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPLongValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeLongPointer: {
                long *value = va_arg(arguments, long *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPLongPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnsignedLong: {
                unsigned long value = va_arg(arguments, unsigned long);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnsignedLongValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeLongLong: {
                long long value = va_arg(arguments, long long);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPLongLongValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeLongLongPointer: {
                long long *value = va_arg(arguments, long long *);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPLongLongPointerValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeUnsignedLongLong: {
                unsigned long long value = va_arg(arguments, unsigned long long);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPUnsignedLongLongValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeDouble: {
                double value = va_arg(arguments, double);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPDoubleValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            case VPTypeLongDouble: {
                long double value = va_arg(arguments, long double);
                for (VPConversionArgument *argument in sameIndexArguments) {
                    argument.valueWrapper = [[VPLongDoubleValueWrapper alloc] initWithValue:value];
                }
                break;
            }
            default: {
                break;
            }
        }
    }
    
    for (VPSubstring *substring in substringsContainer.substrings) {
        if ([substring isKindOfClass:[VPConversionSubstring class]]) {
            
            // Add conversion substring
            VPConversionSubstring *conversionSubstring = (VPConversionSubstring *)substring;
            NSString *builtSubstring = conversionSubstring.builtSubstring;
            NSMutableAttributedString *attributedSubstring = [[NSMutableAttributedString alloc] initWithString:builtSubstring];
            [attributedFormat enumerateAttributesInRange:substring.range options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
                [attributedSubstring addAttributes:attributes range:NSMakeRange(0, builtSubstring.length)];
            }];
            [resultAttributedString appendAttributedString:attributedSubstring];
            
        } else {
            
            // Add ordinary substring
            NSAttributedString *attributedSubstring = [attributedFormat attributedSubstringFromRange:substring.range];
            [resultAttributedString appendAttributedString:attributedSubstring];
        }
    }
    
    return resultAttributedString.copy;
}

@end
