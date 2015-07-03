//
//  VPConversionSubstring.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPConversionSubstring.h"
#import "VPSubstring_Protected.h"
#import "VPConversionArgument.h"

@interface VPConversionSubstring ()

@property (nonatomic, strong) NSMutableArray *mutableArguments;
@property (nonatomic, assign) BOOL isComplete;

@property (nonatomic, assign) NSUInteger valueArgumentIndex;
@property (nonatomic, strong) VPSubstring *argumentIndexSubstring;
@property (nonatomic, strong) VPSubstring *argumentSpecifierSubstring;

@end

@implementation VPConversionSubstring

@dynamic arguments;

- (instancetype)init {
    self = [super init];
    if (self) {
        self.mutableArguments = [NSMutableArray array];
        
        self.valueArgumentIndex = NSNotFound;
        self.argumentIndexSubstring = [[VPSubstring alloc] init];
        self.argumentSpecifierSubstring = [[VPSubstring alloc] init];
    }
    return self;
}

- (void)appendCharacter:(unichar)character
 positionInParentString:(NSUInteger)position {
    NSAssert(!self.isComplete, @"Conversion substring \"%@\" is complete. Character %c can't be added", self.mutableValue, character);
    
    [super appendCharacter:character
    positionInParentString:position];
    
    [self parseCharacter:character
                position:self.mutableValue.length - 1];
}

- (void)makeEmpty {
    [super makeEmpty];
    [self.mutableArguments removeAllObjects];
    self.isComplete = NO;
    
    self.valueArgumentIndex = NSNotFound;
    [self.argumentIndexSubstring makeEmpty];
    [self.argumentSpecifierSubstring makeEmpty];
}

- (NSString *)builtSubstring {
    for (VPConversionArgument *argument in self.mutableArguments) {
        NSAssert(argument.valueWrapper != nil, @"\"builtSubstring\" method is called for conversion substring with nil value for argument: %@", argument);
    }
    
    NSString *builtSubstring = nil;
    
    if (self.arguments.count == 1) {
        builtSubstring = [NSString stringWithFormat:self.value,
                          [[self.arguments[0] valueWrapper] value]];
        
    } else if (self.arguments.count == 2) {
        builtSubstring = [NSString stringWithFormat:self.value,
                          [[self.arguments[0] valueWrapper] value],
                          [[self.arguments[1] valueWrapper] value]];
        
    } else if (self.arguments.count == 3) {
        builtSubstring = [NSString stringWithFormat:self.value,
                          [[self.arguments[0] valueWrapper] value],
                          [[self.arguments[1] valueWrapper] value],
                          [[self.arguments[2] valueWrapper] value]];
    }
    
    return builtSubstring;
}

#pragma mark -
#pragma mark Property

- (NSArray *)arguments {
    // Return mutable value instead of immutable copy for memory usage optimization
    return self.mutableArguments;
}

#pragma mark -
#pragma mark Private

- (void)parseCharacter:(unichar)character
              position:(NSUInteger)position {
    
    static unichar const VPPrecisionOrWidthArgumentIndicator = '*';
    static unichar const VPArgumentIndexIndicator = '$';
    
    if (character == VPPrecisionOrWidthArgumentIndicator) { // Found precision or width argument indicator
        VPConversionArgument *argument = [[VPConversionArgument alloc] initWithType:VPTypeInt // Precision and width arguments have "int" type
                                                                              index:NSNotFound];
        [self.mutableArguments addObject:argument];
        
        [self.argumentIndexSubstring makeEmpty];
        [self.argumentSpecifierSubstring makeEmpty];
        
    } else if (!self.argumentSpecifierSubstring.isEmpty) {
        if ([self.conversionSpecifiers containsObject: @(character)]) { // Conversion specifier with length modifier is finished
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            VPType argumentType = [self typeForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithType:argumentType
                                                                                  index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is continued
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
        }
        
    } else if (!self.argumentIndexSubstring.isEmpty) {
        if ([self.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            
        } else if (character == VPArgumentIndexIndicator) { // Found argument index substring
            
            NSUInteger argumentIndex = @([self.argumentIndexSubstring.value longLongValue]).unsignedIntegerValue;
            
            // Example: [NSString stringWithFormat:@"%1$*2$.*3$g", 1.0, 1, 1]);
            if (self.mutableArguments.count != 0) { // Argument index is related to width or precision
                
                // Update argument index
                VPConversionArgument *oldArgument = self.mutableArguments.lastObject;
                VPConversionArgument *newArgument = [[VPConversionArgument alloc] initWithType:oldArgument.type
                                                                                         index:argumentIndex];
                [self.mutableArguments replaceObjectAtIndex:self.mutableArguments.count - 1
                                                 withObject:newArgument];
                
            } else { // Argument index is related to value
                
                // Put this index to conversion argument later when value argument will be parsed
                self.valueArgumentIndex = argumentIndex;
            }
            
            // Remove argument index substring from conversion substring
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            [self.mutableValue replaceCharactersInRange:self.argumentIndexSubstring.range withString:@""];
            [self.argumentIndexSubstring makeEmpty];
        }
        
    } else {
        if ([self.conversionSpecifiers containsObject: @(character)]) { // Conversion substring is complete
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            VPType argumentType = [self typeForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithType:argumentType
                                                                                  index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentIndexSubstring makeEmpty];
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is started
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            [self.argumentIndexSubstring makeEmpty];
            
        } else if ([self.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width
            
            // Append character to argument index substring
            // If character is part of precision or width then it will be fixed in next iterations of cycle
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            
            [self.argumentSpecifierSubstring makeEmpty];
            
        } else {
            [self.argumentIndexSubstring makeEmpty];
            [self.argumentSpecifierSubstring makeEmpty];
        }
    }
    
    if (self.isComplete) {
        
        // Check if arguments types and count are valid
        [self validateArguments];
        
        if (self.valueArgumentIndex != NSNotFound) { // Originally conversion substring contained arguments indexes
            
            // Argument indexes substrings were removed
            // Example: Was: [NSString stringWithFormat:@"%1$*2$.*3$g", 1.0, 1, 1]);
            //       Became: [NSString stringWithFormats:@"%*.*g", 1, 1, 1.0]);
            // Put value argument to the end of array
            VPConversionArgument *valueArgument = self.mutableArguments[0];
            [self.mutableArguments removeObjectAtIndex:0];
            [self.mutableArguments addObject:valueArgument];
        }
    }
}

- (VPType)typeForArgumentSpecifier:(NSString *)argumentSpecifier {
    VPType type = VPTypeUnknown;
    
    NSDictionary *typeSpecifiers = self.typeSpecifiers;
    for (NSNumber *typeNumber in typeSpecifiers) {
        NSSet *specifiersSet = typeSpecifiers[typeNumber];
        if ([specifiersSet containsObject:argumentSpecifier]) {
            type = [typeNumber unsignedIntegerValue];
            break;
        }
    }
    
    return type;
}

- (void)validateArguments {
    static NSUInteger const VPMinNumberOfArgumentsPerConversion = 1; // Value. Example [NSString stringWithFormats:@"%g", 1.0]);
    static NSUInteger const VPMaxNumberOfArgumentsPerConversion = 3; // Width, Precision, Value. Example: [NSString stringWithFormats:@"%*.*g", 1, 1, 1.0]);
    
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                     reason:[NSString stringWithFormat:@"Wrong format specifier is used in \"attributedFormat\" substring: %@", self.mutableValue]
                                                   userInfo:nil];
    
    if (self.mutableArguments.count < VPMinNumberOfArgumentsPerConversion ||
        self.mutableArguments.count > VPMaxNumberOfArgumentsPerConversion) {
        @throw exception;
    }
    
    for (VPConversionArgument *argument in self.mutableArguments) {
        if (argument.type == VPTypeUnknown) {
            @throw exception;
        }
    }
}

/**
 *  Documentation: https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
 *                 http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
 */
- (NSDictionary *)typeSpecifiers {
    static NSDictionary *typeSpecifiers = nil;
    if (typeSpecifiers == nil) {
        typeSpecifiers = @{@(VPTypeId)                : [NSSet setWithObjects:@"@", nil],
                           @(VPTypeVoidPointer)       : [NSSet setWithObjects:@"p", nil],
                           @(VPTypeChar)              : [NSSet setWithObjects:@"hhd", @"hhD", @"hhi", nil],
                           @(VPTypeCharPointer)       : [NSSet setWithObjects:@"hhn", nil],
                           @(VPTypeSignedCharPointer) : [NSSet setWithObjects:@"s", nil],
                           @(VPTypeUnsignedChar)      : [NSSet setWithObjects:@"hho", @"hhO", @"hhu", @"hhU", @"hhx", @"hhX", nil],
                           @(VPTypeUnichar)           : [NSSet setWithObjects:@"C", nil],
                           @(VPTypeUnicharPointer)    : [NSSet setWithObjects:@"S", @"ls", nil],
                           @(VPTypeShort)             : [NSSet setWithObjects:@"hd", @"hD", @"hi",  nil],
                           @(VPTypeShortPointer)      : [NSSet setWithObjects:@"hn", nil],
                           @(VPTypeUnsignedShort)     : [NSSet setWithObjects:@"ho", @"hO", @"hu", @"hU", @"hx", @"hX", nil],
                           @(VPTypeInt)               : [NSSet setWithObjects:@"d", @"D", @"i", nil],
                           @(VPTypeIntPointer)        : [NSSet setWithObjects:@"n", nil],
                           @(VPTypeUnsignedInt)       : [NSSet setWithObjects:@"o", @"O", @"u", @"U", @"x", @"X", @"c", nil],
                           @(VPTypeWint_t)            : [NSSet setWithObjects:@"lc", nil],
                           @(VPTypeIntmax_t)          : [NSSet setWithObjects:@"jd", @"jD", @"ji", nil],
                           @(VPTypeIntmax_tPointer)   : [NSSet setWithObjects:@"jn", nil],
                           @(VPTypeUintmax_t)         : [NSSet setWithObjects:@"jo", @"jO", @"ju", @"jU", @"jx", @"jX", nil],
                           @(VPTypeSize_t)            : [NSSet setWithObjects:@"zd", @"zD", @"zo", @"zO", @"zu", @"zU", @"zx", @"zX", @"zi", nil],
                           @(VPTypeSize_tPointer)     : [NSSet setWithObjects:@"zn", nil],
                           @(VPTypePtrdiff_t)         : [NSSet setWithObjects:@"td", @"tD", @"to", @"tO", @"tu", @"tU", @"tx", @"tX", @"ti", nil],
                           @(VPTypePtrdiff_tPointer)  : [NSSet setWithObjects:@"tn", nil],
                           @(VPTypeLong)              : [NSSet setWithObjects:@"ld", @"lD", @"li", nil],
                           @(VPTypeLongPointer)       : [NSSet setWithObjects:@"ln", nil],
                           @(VPTypeUnsignedLong)      : [NSSet setWithObjects:@"lo", @"lO", @"lu", @"lU", @"lx", @"lX", nil],
                           @(VPTypeLongLong)          : [NSSet setWithObjects:@"lld", @"llD", @"lli", nil],
                           @(VPTypeLongLongPointer)   : [NSSet setWithObjects:@"lln", nil],
                           @(VPTypeUnsignedLongLong)  : [NSSet setWithObjects:@"llo", @"llO", @"llu", @"llU", @"llx", @"llX", nil],
                           @(VPTypeDouble)            : [NSSet setWithObjects:@"f", @"F", @"e", @"E", @"g", @"G", @"a", @"A", @"la", @"lA", @"le", @"lE", @"lf", @"lF", @"lg", @"lG", nil],
                           @(VPTypeLongDouble)        : [NSSet setWithObjects:@"La", @"LA", @"Le", @"LE", @"Lf", @"LF", @"Lg", @"LG", nil]};
    }
    return typeSpecifiers;
}

- (NSSet *)conversionSpecifiers {
    static NSSet *conversionSpecifiers = nil;
    if (conversionSpecifiers == nil) {
        conversionSpecifiers = [NSSet setWithObjects:
                                @'@', @'d', @'D', @'o', @'O', @'u',
                                @'U', @'x', @'X', @'f', @'F', @'e',
                                @'E', @'g', @'G', @'a', @'A', @'c',
                                @'C', @'s', @'S', @'p', @'n', @'i', nil];
    }
    return conversionSpecifiers;
}

- (NSSet *)lengthModifiers {
    static NSSet *lengthModifiers = nil;
    if (lengthModifiers == nil) {
        lengthModifiers = [NSSet setWithObjects: @'l', @'L', @'h', @'j', @'z', @'t', nil];
    }
    return lengthModifiers;
}

- (NSSet *)digits {
    static NSSet *digits = nil;
    if (digits == nil) {
        digits = [NSSet setWithObjects:@'0', @'1', @'2', @'3', @'4', @'5', @'6', @'7', @'8', @'9', nil];
    }
    return digits;
}

@end
