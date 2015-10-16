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
#import "VPSpecifiersProvider.h"

@interface VPConversionSubstring ()

@property (nonatomic, strong) NSMutableArray<VPConversionArgument *> *mutableArguments;
@property (nonatomic, assign) BOOL isComplete;

@property (nonatomic, strong) VPSpecifiersProvider *provider;
@property (nonatomic, assign) NSInteger valueArgumentIndex;
@property (nonatomic, strong) VPSubstring *argumentIndexSubstring;
@property (nonatomic, strong) VPSubstring *argumentSpecifierSubstring;

@end

@implementation VPConversionSubstring

@dynamic arguments;

- (instancetype)init {
    NSAssert(0, @"'initWithSpecifiersProvider:' has to be called instead of 'init'");
    self = [super init];
    return self;
}

- (instancetype)initWithSpecifiersProvider:(VPSpecifiersProvider *)provider {
    self = [super init];
    if (self) {
        self.provider = provider;
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

- (NSAttributedString *)buildAttributedSubstring {
    NSAttributedString *attributedSubstring = nil;
    
    id<VPValueWrapper> conversionWrapper = [self.arguments.lastObject valueWrapper];
    
    if (self.arguments.count == 1) { // Format contains only value argument.
        attributedSubstring = [conversionWrapper attributedStringWithSingleFormat:self.value];
        
    } else if (self.arguments.count == 2) { // Format contains value and (width or precision) arguments.
        VPIntValueWrapper *widthOrPrecisionWrapper = (VPIntValueWrapper *)[self.arguments[0] valueWrapper];
        attributedSubstring = [conversionWrapper attributedStringWithSingleFormat:self.value
                                                          widthOrPrecisionWrapper:widthOrPrecisionWrapper];
        
    } else if (self.arguments.count == 3) { // Format contains value and width and precision arguments.
        VPIntValueWrapper *widthWrapper = (VPIntValueWrapper *)[self.arguments[0] valueWrapper];
        VPIntValueWrapper *precisionWrapper = (VPIntValueWrapper *)[self.arguments[1] valueWrapper];
        attributedSubstring = [conversionWrapper attributedStringWithSingleFormat:self.value
                                                                     widthWrapper:widthWrapper
                                                                 precisionWrapper:precisionWrapper];
    }
    
    return attributedSubstring;
}

#pragma mark -
#pragma mark Property

- (NSArray<VPConversionArgument *> *)arguments {
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
        if ([self.provider.conversionSpecifiers containsObject: @(character)]) { // Conversion specifier with length modifier is finished.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            Class wrapperClass = [self wrapperClassForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithValueWrapper:[wrapperClass new]
                                                                                          index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.provider.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is continued.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
        }
        
    } else if (!self.argumentIndexSubstring.isEmpty) {
        if ([self.provider.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width.
            [self.argumentIndexSubstring appendCharacter:character
                                  positionInParentString:position];
            
        } else if (character == VPArgumentIndexIndicator) { // Found argument index substring.
            
            // Originally argument index starts from 1 (1$, 2$, 3$ and etc.).
            // When argument index is determined its value stored starting from 0 (0, 1, 2 and etc.).
            NSInteger argumentIndex = @([self.argumentIndexSubstring.value longLongValue]).integerValue - 1;
            
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
        if ([self.provider.conversionSpecifiers containsObject: @(character)]) { // Conversion substring is complete.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            Class wrapperClass = [self wrapperClassForArgumentSpecifier:self.argumentSpecifierSubstring.value];
            VPConversionArgument *argument = [[VPConversionArgument alloc] initWithValueWrapper:[wrapperClass new]
                                                                                          index:self.valueArgumentIndex];
            [self.mutableArguments addObject:argument];
            
            [self.argumentIndexSubstring makeEmpty];
            [self.argumentSpecifierSubstring makeEmpty];
            
            self.isComplete = YES;
            
        } else if ([self.provider.lengthModifiers containsObject:@(character)]) { // Conversion specifier with length modifier is started.
            [self.argumentSpecifierSubstring appendCharacter:character
                                      positionInParentString:position];
            
            [self.argumentIndexSubstring makeEmpty];
            
        } else if ([self.provider.digits containsObject:@(character)]) { // Character is part of argument index substring or precision or width.
            
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

    for (NSString *wrapperClassString in self.provider.wrapperClassSpecifiers) {
        NSSet<NSString *> *specifiersSet = self.provider.wrapperClassSpecifiers[wrapperClassString];
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

@end
