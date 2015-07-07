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
#import "VPValueWrapper.h"

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
        self.argumentIndexSubstring = [VPSubstring new];
        self.argumentSpecifierSubstring = [VPSubstring new];
    }
    return self;
}

- (void)appendCharacter:(unichar)character
 positionInParentString:(NSUInteger)position {
    NSAssert(!self.isComplete, @"Conversion substring '%@' is complete. Character '%c' can't be added", self.value, character);
    
    [super appendCharacter:character
    positionInParentString:position];
    
    [self parseCharacter:character
                position:self.value.length - 1];
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
    NSString *builtSubstring = nil;
    
    id<VPValueWrapper> conversionWrapper = [self.arguments.lastObject valueWrapper];
    
    if (self.arguments.count == 1) { // Format contains only value argument.
        builtSubstring = [conversionWrapper stringWithSingleFormat:self.value];
        
    } else if (self.arguments.count == 2) { // Format contains value and (width or precision) arguments.
        VPIntValueWrapper *widthOrPrecisionWrapper = (VPIntValueWrapper *)[self.arguments[0] valueWrapper];
        builtSubstring = [conversionWrapper stringWithSingleFormat:self.value
                                           widthOrPrecisionWrapper:widthOrPrecisionWrapper];
        
    } else if (self.arguments.count == 3) { // Format contains value and width and precision arguments.
        VPIntValueWrapper *widthWrapper = (VPIntValueWrapper *)[self.arguments[0] valueWrapper];
        VPIntValueWrapper *precisionWrapper = (VPIntValueWrapper *)[self.arguments[1] valueWrapper];
        builtSubstring = [conversionWrapper stringWithSingleFormat:self.value
                                                      widthWrapper:widthWrapper
                                                  precisionWrapper:precisionWrapper];
    }
    
    return builtSubstring;
}

#pragma mark -
#pragma mark Property

- (NSArray *)arguments {
    // Return mutable value instead of immutable copy for memory usage optimization.
    return self.mutableArguments;
}

#pragma mark -
#pragma mark Private

- (void)parseCharacter:(unichar)character
              position:(NSUInteger)position {
    static unichar const VPPrecisionOrWidthArgumentIndicator = '*';
    static unichar const VPArgumentIndexIndicator = '$';
    
    if (character == VPPrecisionOrWidthArgumentIndicator) { // Found precision or width argument indicator.
        
        // Precision and width arguments have 'int' type.
        VPConversionArgument *argument = [[VPConversionArgument alloc] initWithValueWrapper:[VPIntValueWrapper new]
                                                                                      index:NSNotFound];
        [self.mutableArguments addObject:argument];
        
        [self.argumentIndexSubstring makeEmpty];
        [self.argumentSpecifierSubstring makeEmpty];
        
    } else if (!self.argumentSpecifierSubstring.isEmpty) {
        if ([self.conversionSpecifiers containsObject: @(character)]) { // Conversion specifier with length modifier is finished.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            Class wrapperClass = [self wrapperClassForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithValueWrapper:[wrapperClass new]
                                                                                          index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is continued.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
        }
        
    } else if (!self.argumentIndexSubstring.isEmpty) {
        if ([self.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width.
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            
        } else if (character == VPArgumentIndexIndicator) { // Found argument index substring.
            
            // Originally argument index starts from 1 (1$, 2$, 3$ and etc.).
            // When argument index is determined its value stored starting from 0 (0, 1, 2 and etc.).
            NSUInteger argumentIndex = @([self.argumentIndexSubstring.value longLongValue]).unsignedIntegerValue - 1;
            
            // Example: [NSString stringWithFormat:@"%1$*2$.*3$g", 1.0, 1, 1]);
            if (self.arguments.count != 0) { // Argument index is related to width or precision.
                
                // Update argument index.
                VPConversionArgument *oldArgument = self.arguments.lastObject;
                VPConversionArgument *newArgument = [[VPConversionArgument alloc] initWithValueWrapper:oldArgument.valueWrapper.copy
                                                                                                 index:argumentIndex];
                [self.mutableArguments replaceObjectAtIndex:self.arguments.count - 1
                                                 withObject:newArgument];
                
            } else { // Argument index is related to value.
                
                // Put this index to conversion argument later when value argument will be parsed.
                self.valueArgumentIndex = argumentIndex;
            }
            
            // Remove argument index substring from conversion substring.
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            [self.mutableValue replaceCharactersInRange:self.argumentIndexSubstring.range withString:@""];
            [self.argumentIndexSubstring makeEmpty];
            
        } else {
            
            // Digits were part of precision or width.
            // Reset argument index substring because digits were added by mistake.
            [self.argumentIndexSubstring makeEmpty];
            
            // Try parse last character again.
            [self parseCharacter:character position:position];
        }
        
    } else {
        if ([self.conversionSpecifiers containsObject: @(character)]) { // Conversion substring is complete.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            Class wrapperClass = [self wrapperClassForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithValueWrapper:[wrapperClass new]
                                                                                          index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentIndexSubstring makeEmpty];
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is started.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            [self.argumentIndexSubstring makeEmpty];
            
        } else if ([self.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width.
            
            // Append character to argument index substring.
            // If character is part of precision or width then it will be fixed in next iterations of cycle.
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            
            [self.argumentSpecifierSubstring makeEmpty];
            
        } else {
            [self.argumentIndexSubstring makeEmpty];
            [self.argumentSpecifierSubstring makeEmpty];
        }
    }
    
    if (self.isComplete) {
        
        // Check if arguments types and count are valid.
        [self validateArguments];
    }
}

- (Class)wrapperClassForArgumentSpecifier:(NSString *)argumentSpecifier {
    Class wrapperClass = Nil;
    
    NSDictionary *wrapperClassSpecifiers = self.wrapperClassSpecifiers;
    for (NSString *wrapperClassString in wrapperClassSpecifiers) {
        NSSet *specifiersSet = wrapperClassSpecifiers[wrapperClassString];
        if ([specifiersSet containsObject:argumentSpecifier]) {
            wrapperClass = NSClassFromString(wrapperClassString);
            break;
        }
    }
    
    return wrapperClass;
}

- (void)validateArguments {
    static NSUInteger const VPMinNumberOfArgumentsPerConversion = 1; // Value. Example: [NSString stringWithFormats:@"%g", 1.0]);
    static NSUInteger const VPMaxNumberOfArgumentsPerConversion = 3; // Width, Precision, Value. Example: [NSString stringWithFormats:@"%*.*g", 1, 1, 1.0]);
    
    NSException *exception = [NSException exceptionWithName:NSInvalidArgumentException
                                                     reason:[NSString stringWithFormat:@"Wrong format specifier is used in 'attributedFormat' substring: %@", self.value]
                                                   userInfo:nil];
    
    if (self.arguments.count < VPMinNumberOfArgumentsPerConversion ||
        self.arguments.count > VPMaxNumberOfArgumentsPerConversion) {
        @throw exception;
    }
    
    for (VPConversionArgument *argument in self.arguments) {
        if (argument.valueWrapper == nil) {
            @throw exception;
        }
    }
}

/**
 *  Documentation: https://developer.apple.com/library/prerelease/mac/documentation/Cocoa/Conceptual/Strings/Articles/formatSpecifiers.html
 *                 http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
 */
- (NSDictionary *)wrapperClassSpecifiers {
    static NSDictionary *wrapperClassSpecifiers = nil;
    if (wrapperClassSpecifiers == nil) {
        wrapperClassSpecifiers = @{NSStringFromClass([VPIdValueWrapper class])                : [NSSet setWithObjects:@"@", nil],
                                   NSStringFromClass([VPVoidPointerValueWrapper class])       : [NSSet setWithObjects:@"p", nil],
                                   NSStringFromClass([VPCharValueWrapper class])              : [NSSet setWithObjects:@"hhd", @"hhD", @"hhi", nil],
                                   NSStringFromClass([VPCharPointerValueWrapper class])       : [NSSet setWithObjects:@"hhn", nil],
                                   NSStringFromClass([VPSignedCharPointerValueWrapper class]) : [NSSet setWithObjects:@"s", nil],
                                   NSStringFromClass([VPUnsignedCharValueWrapper class])      : [NSSet setWithObjects:@"hho", @"hhO", @"hhu", @"hhU", @"hhx", @"hhX", nil],
                                   NSStringFromClass([VPUnicharValueWrapper class])           : [NSSet setWithObjects:@"C", nil],
                                   NSStringFromClass([VPUnicharPointerValueWrapper class])    : [NSSet setWithObjects:@"S", @"ls", nil],
                                   NSStringFromClass([VPShortValueWrapper class])             : [NSSet setWithObjects:@"hd", @"hD", @"hi",  nil],
                                   NSStringFromClass([VPShortPointerValueWrapper class])      : [NSSet setWithObjects:@"hn", nil],
                                   NSStringFromClass([VPUnsignedShortValueWrapper class])     : [NSSet setWithObjects:@"ho", @"hO", @"hu", @"hU", @"hx", @"hX", nil],
                                   NSStringFromClass([VPIntValueWrapper class])               : [NSSet setWithObjects:@"d", @"D", @"i", nil],
                                   NSStringFromClass([VPIntPointerValueWrapper class])        : [NSSet setWithObjects:@"n", nil],
                                   NSStringFromClass([VPUnsignedIntValueWrapper class])       : [NSSet setWithObjects:@"o", @"O", @"u", @"U", @"x", @"X", @"c", nil],
                                   NSStringFromClass([VPWint_tValueWrapper class])            : [NSSet setWithObjects:@"lc", nil],
                                   NSStringFromClass([VPIntmax_tValueWrapper class])          : [NSSet setWithObjects:@"jd", @"jD", @"ji", nil],
                                   NSStringFromClass([VPIntmax_tPointerValueWrapper class])   : [NSSet setWithObjects:@"jn", nil],
                                   NSStringFromClass([VPUintmax_tValueWrapper class])         : [NSSet setWithObjects:@"jo", @"jO", @"ju", @"jU", @"jx", @"jX", nil],
                                   NSStringFromClass([VPSize_tValueWrapper class])            : [NSSet setWithObjects:@"zd", @"zD", @"zo", @"zO", @"zu", @"zU", @"zx", @"zX", @"zi", nil],
                                   NSStringFromClass([VPSize_tPointerValueWrapper class])     : [NSSet setWithObjects:@"zn", nil],
                                   NSStringFromClass([VPPtrdiff_tValueWrapper class])         : [NSSet setWithObjects:@"td", @"tD", @"to", @"tO", @"tu", @"tU", @"tx", @"tX", @"ti", nil],
                                   NSStringFromClass([VPPtrdiff_tPointerValueWrapper class])  : [NSSet setWithObjects:@"tn", nil],
                                   NSStringFromClass([VPLongValueWrapper class])              : [NSSet setWithObjects:@"ld", @"lD", @"li", nil],
                                   NSStringFromClass([VPLongPointerValueWrapper class])       : [NSSet setWithObjects:@"ln", nil],
                                   NSStringFromClass([VPUnsignedLongValueWrapper class])      : [NSSet setWithObjects:@"lo", @"lO", @"lu", @"lU", @"lx", @"lX", nil],
                                   NSStringFromClass([VPLongLongValueWrapper class])          : [NSSet setWithObjects:@"lld", @"llD", @"lli", nil],
                                   NSStringFromClass([VPLongLongPointerValueWrapper class])   : [NSSet setWithObjects:@"lln", nil],
                                   NSStringFromClass([VPUnsignedLongLongValueWrapper class])  : [NSSet setWithObjects:@"llo", @"llO", @"llu", @"llU", @"llx", @"llX", nil],
                                   NSStringFromClass([VPDoubleValueWrapper class])            : [NSSet setWithObjects:@"f", @"F", @"e", @"E", @"g", @"G", @"a", @"A", @"la", @"lA", @"le", @"lE", @"lf", @"lF", @"lg", @"lG", nil],
                                   NSStringFromClass([VPLongDoubleValueWrapper class])        : [NSSet setWithObjects:@"La", @"LA", @"Le", @"LE", @"Lf", @"LF", @"Lg", @"LG", nil]};
    }
    return wrapperClassSpecifiers;
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
