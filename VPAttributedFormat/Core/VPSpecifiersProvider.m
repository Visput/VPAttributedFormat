//
//  VPSpecifiersProvider.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/13/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPSpecifiersProvider.h"
#import "VPValueWrapper.h"

@interface VPSpecifiersProvider ()

@property (nonatomic, strong) NSDictionary<NSString *, NSSet<NSString *> *> *wrapperClassSpecifiers;
@property (nonatomic, strong) NSSet<NSNumber *> *conversionSpecifiers;
@property (nonatomic, strong) NSSet<NSNumber *> *lengthModifiers;
@property (nonatomic, strong) NSSet<NSNumber *> *digits;

@end

@implementation VPSpecifiersProvider

- (NSDictionary<NSString *, NSSet<NSString *> *> *)wrapperClassSpecifiers {
    if (_wrapperClassSpecifiers == nil) {
        _wrapperClassSpecifiers = @{NSStringFromClass([VPIdValueWrapper class])                : [NSSet setWithObjects:@"@", nil],
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
    return _wrapperClassSpecifiers;
}

- (NSSet<NSNumber *> *)conversionSpecifiers {
    if (_conversionSpecifiers == nil) {
        _conversionSpecifiers = [NSSet setWithObjects:
                                 @'@', @'d', @'D', @'o', @'O', @'u',
                                 @'U', @'x', @'X', @'f', @'F', @'e',
                                 @'E', @'g', @'G', @'a', @'A', @'c',
                                 @'C', @'s', @'S', @'p', @'n', @'i', nil];
    }
    return _conversionSpecifiers;
}

- (NSSet<NSNumber *> *)lengthModifiers {
    if (_lengthModifiers == nil) {
        _lengthModifiers = [NSSet setWithObjects: @'l', @'L', @'h', @'j', @'z', @'t', nil];
    }
    return _lengthModifiers;
}

- (NSSet<NSNumber *> *)digits {
    if (_digits == nil) {
        _digits = [NSSet setWithObjects:@'0', @'1', @'2', @'3', @'4', @'5', @'6', @'7', @'8', @'9', nil];
    }
    return _digits;
}


@end
