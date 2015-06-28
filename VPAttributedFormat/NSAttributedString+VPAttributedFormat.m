//
//  NSAttributedString+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "NSAttributedString+VPAttributedFormat.h"

@interface NSAttributedString ()

@end

@implementation NSAttributedString (VPAttributedFormat)

+ (instancetype)attributedStringWithAttributedFormat:(NSAttributedString *)attributedFormat, ... {
    va_list arguments;
    va_start(arguments, attributedFormat);
    NSAttributedString *attributedString = [[[self class] alloc] initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    return attributedString;
}

- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat, ... {
    va_list arguments;
    va_start(arguments, attributedFormat);
    self = [self initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    return self;
}

- (instancetype)initWithAttributedFormat:(NSAttributedString *)attributedFormat arguments:(va_list)arguments {
    self = [self initWithAttributedString:VPAttributedStringWithAttributedFormat(attributedFormat, arguments)];
    return self;
}

#pragma mark -
#pragma mark Private

static inline NSAttributedString *VPAttributedStringWithAttributedFormat(NSAttributedString *attributedFormat, va_list arguments) {
    static unichar const kVPConversionIndicator = '%';
    static NSString *const kVPPercentSymbol = @"%%";
    
    if (attributedFormat == nil) {
        // This parameter can't be nil
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter \"attributedFormat\" can't be nil"
                                     userInfo:nil];
    }
    
    NSMutableAttributedString *resultAttributedString = [[NSMutableAttributedString alloc] init];
    
    NSMutableString *conversionSubstring = [NSMutableString string];
    NSRange conversionSubstringRange = NSMakeRange(NSNotFound, 0);
    NSUInteger conversionIndex = 0;
    
    NSRange simpleSubstringRange = NSMakeRange(NSNotFound, 0);
    
    NSString *formatString = attributedFormat.string;
    for (int characterIndex = 0; characterIndex < formatString.length; ++characterIndex) {
        unichar formatCharacter = [formatString characterAtIndex:characterIndex];
        
        if (conversionSubstring.length != 0) { // Character is part of conversion substring or percent "%%" symbol
            VPAppendCharToSubstring(formatCharacter, characterIndex, conversionSubstring, &conversionSubstringRange);
            
            if ([conversionSubstring isEqualToString:kVPPercentSymbol]) { // Character is part of percent "%%" symbol
                
                // Reset conversion substring because '%' was added by mistake
                VPResetSubstring(conversionSubstring, &conversionSubstringRange);
                
                // "%" is simple character, append it to simple substring
                VPIncreaseRange(&simpleSubstringRange, characterIndex);
                
            } else { // Character is part of conversion substring
                
                if (VPIsCompleteConversionSubstring(conversionSubstring)) {
                    VPAppendConversionSubstringToResultString(conversionSubstring,
                                                              &conversionSubstringRange,
                                                              &conversionIndex,
                                                              arguments,
                                                              attributedFormat,
                                                              resultAttributedString);
                }
            }
            
        } else {
            if (formatCharacter == kVPConversionIndicator) { // Character is part of simple substring or percent "%%" symbol
                
                // Append simple substring with attributes to result attributed string
                VPAppendSimpleSubstringToResultString(&simpleSubstringRange, attributedFormat, resultAttributedString);
                
                // Append character to conversion substring
                // If character is part of percent "%%" symbol then it will be fixed in next iteration of cycle
                VPAppendCharToSubstring(formatCharacter, characterIndex, conversionSubstring, &conversionSubstringRange);
                
            } else { // Character is part of simple substring
                
                // Increase range for simple substring
                VPIncreaseRange(&simpleSubstringRange, characterIndex);
            }
        }
    }
    
    // If attributed format ends with simple substring then it has to be appended to result attributed string
    VPAppendSimpleSubstringToResultString(&simpleSubstringRange, attributedFormat, resultAttributedString);
    
    // If attributed format ends with convesion substring then it has to be built and appended to result attributed string
    if (conversionSubstring.length != 0) {
        if (VPIsCompleteConversionSubstring(conversionSubstring)) {
            VPAppendConversionSubstringToResultString(conversionSubstring,
                                                      &conversionSubstringRange,
                                                      &conversionIndex,
                                                      arguments,
                                                      attributedFormat,
                                                      resultAttributedString);
        } else {
            
            // Conversion substring is incomplete
            // It means that attributedFormat is invalid
            @throw [NSException exceptionWithName:NSInvalidArgumentException
                                           reason:[NSString stringWithFormat:@"Wrong format specifier is used in \"attributedFormat\" substring: %@", conversionSubstring]
                                         userInfo:nil];
        }
    }
    
    
    return resultAttributedString.copy;
}

static inline void VPAppendSimpleSubstringToResultString(NSRange *simpleSubstringRange,
                                                         NSAttributedString *attributedFormat,
                                                         NSMutableAttributedString *attributedString) {
    if ((*simpleSubstringRange).location != NSNotFound) {
        NSAttributedString *attributedSubstring = [attributedFormat attributedSubstringFromRange:*simpleSubstringRange];
        [attributedString appendAttributedString:attributedSubstring];
        
        // Reset range because it already used for result attributed string
        *simpleSubstringRange = NSMakeRange(NSNotFound, 0);
    }
}

static inline void VPAppendConversionSubstringToResultString(NSMutableString *conversionSubstring,
                                                             NSRange *conversionSubstringRange,
                                                             NSUInteger *conversionIndex,
                                                             va_list conversionArguments,
                                                             NSAttributedString *attributedFormat,
                                                             NSMutableAttributedString *attributedString) {
    NSString *builtSubstring = VPBuildSubstringByConversion(conversionSubstring, conversionIndex, conversionArguments);
    
    NSMutableAttributedString *attributedSubstring = [[NSMutableAttributedString alloc] initWithString:builtSubstring];
    [attributedFormat enumerateAttributesInRange:*conversionSubstringRange options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
        [attributedSubstring addAttributes:attributes range:NSMakeRange(0, builtSubstring.length)];
    }];
    [attributedString appendAttributedString:attributedSubstring];
    
    // Reset substring because it already used for result attributed string
    VPResetSubstring(conversionSubstring, conversionSubstringRange);
}

static inline NSString *VPBuildSubstringByConversion(NSString *conversionSubstring,
                                                     NSUInteger *conversionIndex,
                                                     va_list conversionArguments) {
    static unichar const kVPPrecisionArgumentIndicator = '*';
    static unichar const kVPArgumentPositionIndicator = '$';
    static NSUInteger const kVPMaxNumberOfArgumentsPerConversion = 2;
    static NSSet *digitsSet = nil;
    if (digitsSet == nil) {
        digitsSet = [NSSet setWithArray:@[@'0', @'1', @'2', @'3', @'4', @'5', @'6', @'7', @'8', @'9']];
    }
    
    // Conversion has to contain at least one argument.
    // It will be equal 2 if conversion contains '*' symbol
    NSUInteger numberOfArguments = 1;
    
    va_list updatedConversionArguments;
    NSMutableString *updatedConversionSubstring = [NSMutableString string];
    NSMutableString *arugmentIndexSubstring = [NSMutableString string];
    NSRange argumentIndexSubstringRange = NSMakeRange(NSNotFound, 0);
    
    for (int characterIndex = 0; characterIndex < conversionSubstring.length; ++characterIndex) {
        unichar conversionCharacter = [conversionSubstring characterAtIndex:characterIndex];
        
        VPAppendCharToSubstring(conversionCharacter, characterIndex, updatedConversionSubstring, NULL);
        
        if (arugmentIndexSubstring.length != 0) {
            if ([digitsSet containsObject:@(conversionCharacter)]) { // Character is part of argument index substring or precision
                VPAppendCharToSubstring(conversionCharacter, characterIndex, arugmentIndexSubstring, &argumentIndexSubstringRange);
                
            } else if (conversionCharacter == kVPArgumentPositionIndicator) { // Found argument index substring
                
                // Tracking conversion index is not required because it's determined by argument index substrings
                *conversionIndex = NSNotFound;
                
            } else { // Characters are not part of argument index substring
                VPResetSubstring(arugmentIndexSubstring, &argumentIndexSubstringRange);
            }
        } else {
            if ([digitsSet containsObject:@(conversionCharacter)]) { // Character is part of argument index substring or precision
                
                // Append character to argument index substring
                // If character is part of precision then it will be fixed in next iterations of cycle
                VPAppendCharToSubstring(conversionCharacter, characterIndex, arugmentIndexSubstring, &argumentIndexSubstringRange);
                
            } else if (conversionCharacter == kVPPrecisionArgumentIndicator) {
                
                // Number of arguments has to be tracked only if conversion indexes are not determined by argument index substrings
                if (*conversionIndex != NSNotFound) {
                    ++numberOfArguments;
                    
                    if (numberOfArguments > kVPMaxNumberOfArgumentsPerConversion) {
                        // Conversion substring has wrong format
                        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                                       reason:[NSString stringWithFormat:@"Wrong format specifier is used in \"attributedFormat\" substring: %@", conversionSubstring]
                                                     userInfo:nil];
                    }
                }
            }
        }
    }
    
    if (*conversionIndex != NSNotFound) {
        
    }
    
    NSString *builtSubstring = [[NSString alloc] initWithFormat:updatedConversionSubstring arguments:updatedConversionArguments];
    return builtSubstring;
}

static inline void VPResetSubstring(NSMutableString *substring,
                                    NSRange *substringRange) {
    [substring setString:@""];
    if (substringRange != NULL) {
        *substringRange = NSMakeRange(NSNotFound, 0);
    }
}

static inline void VPAppendCharToSubstring(unichar character,
                                           int characterIndex,
                                           NSMutableString *substring,
                                           NSRange *substringRange) {
    VPIncreaseRange(substringRange, characterIndex);
    
    [substring appendFormat:@"%c", character];
}

static inline void VPIncreaseRange(NSRange *rangeToIncrease,
                                   NSUInteger rangeLocation) {
    if (rangeToIncrease != NULL) {
        if ((*rangeToIncrease).location == NSNotFound) {
            (*rangeToIncrease).location = rangeLocation;
        }
        (*rangeToIncrease).length += 1;
    }
}

static inline BOOL VPIsCompleteConversionSubstring(NSString *conversionSubstring) {
    // Array with all possible conversion specifiers that supported by NSString
    // Documentation: https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
    //                http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
    static NSArray *conversionSpecifiers = nil;
    if (conversionSpecifiers == nil) {
        conversionSpecifiers = @[@"@", @"d", @"D", @"o", @"O", @"u", @"U", @"x", @"X", @"f", @"F", @"e",
                                 @"E", @"g", @"G", @"a", @"A", @"c", @"C", @"s", @"S", @"p", @"n", @"i"];
    }
    
    BOOL isComplete = NO;
    for (NSString *specifier in conversionSpecifiers) {
        if ([conversionSubstring containsString:specifier]) {
            isComplete = YES;
            break;
        }
    }
    return isComplete;
}

@end
