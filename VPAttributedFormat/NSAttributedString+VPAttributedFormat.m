//
//  NSAttributedString+VPAttributedFormat.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "NSAttributedString+VPAttributedFormat.h"

static NSString *const kVPFormatIndicator = @"%";
static NSString *const kVPPrecisionIndicator = @"*";
static NSString *const kVPArgumentPositionIndicator = @"$";

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
    NSString *string = [[NSString alloc] initWithFormat:attributedFormat.string arguments:arguments];
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithString:string];
    self = [self initWithAttributedString:resultString.copy];
    return self;
}

#pragma mark -
#pragma mark Private

/**
 *  Returns array with all possible format specifiers that supported by NSString
 *  Documentation: http://pubs.opengroup.org/onlinepubs/009695399/functions/printf.html
 *
 *  @return Array with strings that represent specifiers
 */
NSArray *VPFormatSpecifiers() {
    static NSArray *formatSpecifiers = nil;
    if (formatSpecifiers == nil) {
        formatSpecifiers = @[
                             // Conversion specifiers
                             @"@", @"d", @"i", @"o", @"u", @"x", @"X",
                             @"f", @"F", @"e", @"E", @"g", @"G", @"a",
                             @"A", @"c", @"s", @"p", @"n", @"C", @"S",
                             
                             // Length modifiers
                             @"hhd", @"hhi", @"hho", @"hhu", @"hhx", @"hhX", @"hhn",        // signed char or unsigned char or pointer to signed char
                             @"hd", @"hi", @"ho", @"hu", @"hx", @"hX", @"hn",               // short or unsigned short or pointer to short
                             @"ld", @"li", @"lo", @"lu", @"lx", @"lX", @"ln", @"lc", @"ls", // long or unsigned long or pointer to long or wint_t or wchar_t
                             @"la", @"lA", @"le", @"lE", @"lf", @"lF", @"lg", @"lG",        // double
                             @"lld", @"lli", @"llo", @"llu", @"llx", @"llX", @"lln",        // long long or unsigned long long or pointer to long long
                             @"jd", @"ji", @"jo", @"ju", @"jx", @"jX", @"jn",               // intmax_t or uintmax_t or pointer to intmax_t
                             @"zd", @"zi", @"zo", @"zu", @"zx", @"zX", @"zn",               // size_t or pointer to size_t
                             @"td", @"ti", @"to", @"tu", @"tx", @"tX", @"tn",               // ptrdiff_t or pointer to ptrdiff_t
                             @"La", @"LA", @"Le", @"LE", @"Lf", @"LF", @"Lg", @"LG"         // long double
                             ];
    }
    return formatSpecifiers;
}

@end
