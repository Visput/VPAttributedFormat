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
#import "VPSpecifiersProvider.h"

@interface VPAttributedStringFormatter ()

@property (nonatomic, strong) VPSpecifiersProvider *specifiersProvider;

@end

@implementation VPAttributedStringFormatter

- (instancetype)init {
    self = [super init];
    if (self) {
        self.specifiersProvider = [VPSpecifiersProvider new];
    }
    return self;
}

- (NSAttributedString *)stringWithFormat:(NSAttributedString *)attributedFormat
                               arguments:(va_list)arguments {
    if (attributedFormat == nil) {
        // This parameter can't be nil.
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Parameter 'attributedFormat' can't be nil"
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
    
    VPSubstringsContainer *substringsContainer = [VPSubstringsContainer new];
    VPSubstring *ordinarySubstring = [VPSubstring new];
    VPConversionSubstring *conversionSubstring = [[VPConversionSubstring alloc] initWithSpecifiersProvider:self.specifiersProvider];
    
    for (NSUInteger characterIndex = 0; characterIndex < formatString.length; ++characterIndex) {
        unichar formatCharacter = [formatString characterAtIndex:characterIndex];
        
        if (!conversionSubstring.isEmpty) { // Character is part of conversion substring or percent "%%" symbol.
            
            [conversionSubstring appendCharacter:formatCharacter
                          positionInParentString:characterIndex];
            
            if ([conversionSubstring.value isEqualToString:VPPercentSymbol]) { // Character is part of percent "%%" symbol.
                
                // Reset conversion substring because '%' was added by mistake.
                [conversionSubstring makeEmpty];
                
                // "%" is ordinary character, append it to ordinary substring.
                [ordinarySubstring appendCharacter:formatCharacter
                            positionInParentString:characterIndex];
                
            } else { // Character is part of conversion substring.
                
                if (conversionSubstring.isComplete) {
                    [substringsContainer addSubstring:conversionSubstring];
                    
                    // Create new object for next conversion substring.
                    conversionSubstring = [[VPConversionSubstring alloc] initWithSpecifiersProvider:self.specifiersProvider];
                }
            }
            
        } else {
            if (formatCharacter == VPConversionIndicator) { // Character is part of conversion substring or percent "%%" symbol.
                if (!ordinarySubstring.isEmpty) {
                    
                    // Ordinary string is ended.
                    // Add to container.
                    [substringsContainer addSubstring:ordinarySubstring];
                    
                    // Create new object for next ordinary substring.
                    ordinarySubstring = [VPSubstring new];
                }
                
                // Append character to conversion substring.
                // If character is part of percent "%%" symbol then it will be fixed in next iteration of cycle.
                [conversionSubstring appendCharacter:formatCharacter
                              positionInParentString:characterIndex];
                
            } else { // Character is part of ordinary substring
                
                [ordinarySubstring appendCharacter:formatCharacter
                            positionInParentString:characterIndex];
            }
        }
    }
    
    // If attributed format ends with ordinary substring then it has to be added to container.
    if (!ordinarySubstring.isEmpty) {
        [substringsContainer addSubstring:ordinarySubstring];
    }
    
    // If attributed format ends with convesion substring then it has to be added to container.
    if (!conversionSubstring.isEmpty) {
        if (conversionSubstring.isComplete) {
            [substringsContainer addSubstring:conversionSubstring];
            
        } else {
            // Conversion substring is incomplete.
            // It means that attributedFormat is invalid.
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
    NSMutableAttributedString *resultAttributedString = [NSMutableAttributedString new];
    
    NSArray<VPConversionArgument *> *conversionArguments = substringsContainer.conversionArgumentsSortedByIndex;
    NSInteger conversionArgumentsIndex = 0;
    NSMutableArray<VPConversionArgument *> *sameIndexArguments = [NSMutableArray array];
    
    for (NSInteger i = 0; i <= substringsContainer.conversionArgumentMaxIndex; i++) {
        
        VPConversionArgument *conversionArgument = conversionArguments[conversionArgumentsIndex];
        
        // Clean array before executing new iteration.
        [sameIndexArguments removeAllObjects];
        
        ++conversionArgumentsIndex;
        if (conversionArgument.index != NSNotFound) { // Few arguments can have the same index only if indexes are obviously set.
            BOOL needsStop = NO;
            while (!needsStop) {
                if (conversionArgumentsIndex < conversionArguments.count) {
                    VPConversionArgument *sameIndexArgument = conversionArguments[conversionArgumentsIndex];
                    if (sameIndexArgument.index == i) {
                        [sameIndexArguments addObject:sameIndexArgument];
                        ++conversionArgumentsIndex;
                    } else {
                        needsStop = YES;
                    }
                } else {
                    needsStop = YES;
                }
            }
        }
        
#if TARGET_IPHONE_SIMULATOR
#ifdef __LP64__
        // Simulator | 64-bit processor architecture.
        // 'va_list' parameters are passed by reference.
        [conversionArgument.valueWrapper setValueByArgumentsValue:arguments];
#else
        // Simulator | 32-bit processor architecture.
        // 'va_list' parameters are passed by value.
        [conversionArgument.valueWrapper setValueByArgumentsPointer:&arguments];
#endif
#else
        // Device | 32-bit or 64-bit processor architecture.
        // 'va_list' parameters are passed by value.
        [conversionArgument.valueWrapper setValueByArgumentsPointer:&arguments];
#endif
        
        for (VPConversionArgument *sameIndexArgument in sameIndexArguments) {
            sameIndexArgument.valueWrapper = conversionArgument.valueWrapper.copy;
        }
    }
    
    for (VPSubstring *substring in substringsContainer.substrings) {
        if ([substring isKindOfClass:[VPConversionSubstring class]]) {
            
            // Add conversion substring.
            VPConversionSubstring *conversionSubstring = (VPConversionSubstring *)substring;
            NSAttributedString *builtAttributedSubstring = conversionSubstring.buildAttributedSubstring;
            NSMutableAttributedString *attributedSubstring = [[NSMutableAttributedString alloc] initWithAttributedString:builtAttributedSubstring];
            [attributedFormat enumerateAttributesInRange:substring.range options:0 usingBlock:^(NSDictionary *attributes, NSRange range, BOOL *stop) {
                [attributedSubstring addAttributes:attributes range:NSMakeRange(0, builtAttributedSubstring.length)];
            }];
            [resultAttributedString appendAttributedString:attributedSubstring];
            
        } else {
            
            // Add ordinary substring.
            NSAttributedString *attributedSubstring = [attributedFormat attributedSubstringFromRange:substring.range];
            [resultAttributedString appendAttributedString:attributedSubstring];
        }
    }
    
    return resultAttributedString.copy;
}

@end
