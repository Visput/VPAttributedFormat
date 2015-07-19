//
//  VPAttributedFormatTests.m
//  VPAttributedFormatTests
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "VPAttributedFormat.h"

@interface VPAttributedFormatTests : XCTestCase

@end

@implementation VPAttributedFormatTests

#pragma mark -
#pragma mark Utility

- (void)testFormat:(NSString *)format, ... {
    NSAttributedString *attributedFormat = [[NSAttributedString alloc] initWithString:format];
    
    va_list arguments;
    va_start(arguments, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    
    va_start(arguments, format);
    NSAttributedString *attributedString = [[NSAttributedString alloc] vp_initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    XCTAssertEqualObjects(string, attributedString.string);
}

#pragma mark -
#pragma mark Simple Formats

- (void)testObjectFormat {
    [self testFormat:@"%@", @"String !@#$%^&*()_ \u1111\u1234\u99999"];
    [self testFormat:@"%@", @1];
    [self testFormat:@"%@", @[@"String1", @"String2"]];
    [self testFormat:@"%@", @{@"Key1" : @"String", @"Key2" : @1}];
    [self testFormat:@"%@", [NSObject new]];
}

- (void)testVoidPointerFormat {
    [self testFormat:@"%p", @1];
    [self testFormat:@"%p", @"String"];
    
    char charValue = 'a';
    [self testFormat:@"%p", &charValue];
    
    int intValue = 1;
    [self testFormat:@"%p", &intValue];
    
    double doubleValue = 1.0;
    [self testFormat:@"%p", &doubleValue];
}

- (void)testCharFormat {
    int numberOfValues = 7;
    char values[] = {'a', 'Z', 1, '\n', CHAR_MIN, CHAR_MAX, CHAR_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        char value = values[i];
        [self testFormat:@"%hhd", value];
        [self testFormat:@"%hhD", value];
        [self testFormat:@"%hhi", value];
    }
}

- (void)testCharPointerFormat {
    int numberOfValues = 7;
    char values[] = {'a', 'Z', 1, '\n', CHAR_MIN, CHAR_MAX, CHAR_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        char value = values[i];
        [self testFormat:@"%hhn", &value];
    }
}

- (void)testSignedCharPointerFormat {
    int numberOfValues = 7;
    signed char values[] = {'a', 'Z', 1, '\n', CHAR_MIN, CHAR_MAX, CHAR_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        signed char value = values[i];
        [self testFormat:@"%s", &value];
    }
}

- (void)testUnsignedCharFormat {
    int numberOfValues = 7;
    unsigned char values[] = {'a', 'Z', 1, '\n', CHAR_MIN, CHAR_MAX, CHAR_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        unsigned char value = values[i];
        [self testFormat:@"%hho", value];
        [self testFormat:@"%hhO", value];
        [self testFormat:@"%hhu", value];
        [self testFormat:@"%hhU", value];
        [self testFormat:@"%hhx", value];
        [self testFormat:@"%hhX", value];
    }
}

- (void)testUnicharFormat {
    NSString *value = @"String !@#$%^&*()_ \u1111\u1234\u99999";
    for (int i = 0; i < value.length; i++) {
        [self testFormat:@"%C", [value characterAtIndex:i]];
    }
}

- (void)testUnicharPointerFormat {
    NSString *value = @"String !@#$%^&*()_ \u1111\u1234\u99999";
    for (int i = 0; i < value.length; i++) {
        const unichar unicharValue = [value characterAtIndex:i];
        [self testFormat:@"%S", &unicharValue];
        [self testFormat:@"%ls", &unicharValue];
    }
}

- (void)testShortFormat {
    int numberOfValues = 4;
    short values[] = {1, SHRT_MIN, SHRT_MAX, SHRT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        short value = values[i];
        [self testFormat:@"%hd", value];
        [self testFormat:@"%hD", value];
        [self testFormat:@"%hi", value];
    }
}

- (void)testShortPointerFormat {
    int numberOfValues = 4;
    short values[] = {1, SHRT_MIN, SHRT_MAX, SHRT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        short value = values[i];
        [self testFormat:@"%hn", &value];
    }
}

- (void)testUnsignedShortFormat {
    int numberOfValues = 3;
    unsigned short values[] = {1, SHRT_MIN, USHRT_MAX};
    
    for (int i = 0; i < numberOfValues; i++) {
        unsigned short value = values[i];
        [self testFormat:@"%ho", value];
        [self testFormat:@"%hO", value];
        [self testFormat:@"%hu", value];
        [self testFormat:@"%hU", value];
        [self testFormat:@"%hx", value];
        [self testFormat:@"%hX", value];
    }
}

- (void)testIntFormat {
    int numberOfValues = 5;
    int values[] = {1, INT_MIN, INT_MIN - 1, INT_MAX, INT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        int value = values[i];
        [self testFormat:@"%d", value];
        [self testFormat:@"%D", value];
        [self testFormat:@"%i", value];
    }
}

- (void)testIntPointerFormat {
    int numberOfValues = 5;
    int values[] = {1, INT_MIN, INT_MIN - 1, INT_MAX, INT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        int value = values[i];
        [self testFormat:@"%n", &value];
    }
}

- (void)testUnsignedIntFormat {
    int numberOfValues = 5;
    unsigned int values[] = {1, INT_MIN, INT_MIN - 1, INT_MAX, INT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        unsigned int value = values[i];
        [self testFormat:@"%o", value];
        [self testFormat:@"%O", value];
        [self testFormat:@"%u", value];
        [self testFormat:@"%U", value];
        [self testFormat:@"%x", value];
        [self testFormat:@"%X", value];
        [self testFormat:@"%c", value];
    }
}

- (void)testWint_tFormat {
    int numberOfValues = 5;
    wint_t values[] = {1, WINT_MIN, WINT_MIN - 1, WINT_MAX, WINT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        wint_t value = values[i];
        [self testFormat:@"%lc", value];
    }
}

- (void)testIntmax_tFormat {
    int numberOfValues = 5;
    intmax_t values[] = {1, INTMAX_MIN, INTMAX_MIN - 1, INTMAX_MAX, INTMAX_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        intmax_t value = values[i];
        [self testFormat:@"%jd", value];
        [self testFormat:@"%jD", value];
        [self testFormat:@"%ji", value];
    }
}

- (void)testIntmax_tPointerFormat {
    int numberOfValues = 5;
    intmax_t values[] = {1, INTMAX_MIN, INTMAX_MIN - 1, INTMAX_MAX, INTMAX_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        intmax_t value = values[i];
        [self testFormat:@"%jn", &value];
    }
}

- (void)testUintmax_tFormat {
    int numberOfValues = 5;
    uintmax_t values[] = {1, INTMAX_MIN, INTMAX_MIN - 1, UINTMAX_MAX, UINTMAX_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        uintmax_t value = values[i];
        [self testFormat:@"%jo", value];
        [self testFormat:@"%jO", value];
        [self testFormat:@"%ju", value];
        [self testFormat:@"%jU", value];
        [self testFormat:@"%jx", value];
        [self testFormat:@"%jX", value];
    }
}

- (void)testSize_tFormat {
    int numberOfValues = 3;
    size_t values[] = {1, SIZE_T_MAX, SIZE_T_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        size_t value = values[i];
        [self testFormat:@"%zd", value];
        [self testFormat:@"%zD", value];
        [self testFormat:@"%zo", value];
        [self testFormat:@"%zO", value];
        [self testFormat:@"%zu", value];
        [self testFormat:@"%zU", value];
        [self testFormat:@"%zx", value];
        [self testFormat:@"%zX", value];
        [self testFormat:@"%zi", value];
    }
}

- (void)testSize_tPointerFormat {
    int numberOfValues = 3;
    size_t values[] = {1, SIZE_T_MAX, SIZE_T_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        size_t value = values[i];
        [self testFormat:@"%zn", &value];
    }
}

- (void)testPtrdiff_tFormat {
    int numberOfValues = 5;
    ptrdiff_t values[] = {1, PTRDIFF_MIN, PTRDIFF_MIN - 1, PTRDIFF_MAX, PTRDIFF_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        ptrdiff_t value = values[i];
        [self testFormat:@"%td", value];
        [self testFormat:@"%tD", value];
        [self testFormat:@"%to", value];
        [self testFormat:@"%tO", value];
        [self testFormat:@"%tu", value];
        [self testFormat:@"%tU", value];
        [self testFormat:@"%tx", value];
        [self testFormat:@"%tX", value];
        [self testFormat:@"%ti", value];
    }
}

- (void)testPtrdiff_tPointerFormat {
    int numberOfValues = 5;
    ptrdiff_t values[] = {1, PTRDIFF_MIN, PTRDIFF_MIN - 1, PTRDIFF_MAX, PTRDIFF_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        ptrdiff_t value = values[i];
        [self testFormat:@"%tn", &value];
    }
}

- (void)testLongFormat {
    int numberOfValues = 5;
    long values[] = {1L, LONG_MIN, LONG_MIN - 1, LONG_MAX, LONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        long value = values[i];
        [self testFormat:@"%ld", value];
        [self testFormat:@"%lD", value];
        [self testFormat:@"%li", value];
    }
}

- (void)testLongPointerFormat {
    int numberOfValues = 5;
    long values[] = {1L, LONG_MIN, LONG_MIN - 1, LONG_MAX, LONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        long value = values[i];
        [self testFormat:@"%ln", &value];
    }
}

- (void)testUnsignedLongFormat {
    int numberOfValues = 4;
    unsigned long values[] = {1LU, LONG_MIN, ULONG_MAX, ULONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        unsigned long value = values[i];
        [self testFormat:@"%lo", value];
        [self testFormat:@"%lO", value];
        [self testFormat:@"%lu", value];
        [self testFormat:@"%lU", value];
        [self testFormat:@"%lx", value];
        [self testFormat:@"%lX", value];
    }
}

- (void)testLongLongFormat {
    int numberOfValues = 5;
    long long values[] = {1LL, LONG_LONG_MIN, LONG_LONG_MIN - 1, LONG_LONG_MAX, LONG_LONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        long long value = values[i];
        [self testFormat:@"%lld", value];
        [self testFormat:@"%llD", value];
        [self testFormat:@"%lli", value];
    }
}

- (void)testLongLongPointerFormat {
    int numberOfValues = 5;
    long long values[] = {1LL, LONG_LONG_MIN, LONG_LONG_MIN - 1, LONG_LONG_MAX, LONG_LONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        long long value = values[i];
        [self testFormat:@"%lln", &value];
    }
}

- (void)testUnsignedLongLongFormat {
    int numberOfValues = 4;
    unsigned long long values[] = {1LL, LONG_LONG_MIN, ULONG_LONG_MAX, ULONG_LONG_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        unsigned long long value = values[i];
        [self testFormat:@"%llo", value];
        [self testFormat:@"%llO", value];
        [self testFormat:@"%llu", value];
        [self testFormat:@"%llU", value];
        [self testFormat:@"%llx", value];
        [self testFormat:@"%llX", value];
    }
}

- (void)testDoubleFormat {
    int numberOfValues = 6;
    double values[] = {1.0, -1.0f, DBL_MIN, DBL_MIN - 1, DBL_MAX, DBL_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        double value = values[i];
        [self testFormat:@"%f", value];
        [self testFormat:@"%F", value];
        [self testFormat:@"%e", value];
        [self testFormat:@"%E", value];
        [self testFormat:@"%g", value];
        [self testFormat:@"%G", value];
        [self testFormat:@"%a", value];
        [self testFormat:@"%A", value];
        [self testFormat:@"%la", value];
        [self testFormat:@"%lA", value];
        [self testFormat:@"%le", value];
        [self testFormat:@"%lE", value];
        [self testFormat:@"%lf", value];
        [self testFormat:@"%lF", value];
        [self testFormat:@"%lg", value];
        [self testFormat:@"%lG", value];
    }
}

- (void)testLongDoubleFormat {
    int numberOfValues = 6;
    long double values[] = {1.0, -1.0f, LDBL_MIN, LDBL_MIN - 1, LDBL_MAX, LDBL_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        long double value = values[i];
        [self testFormat:@"%La", value];
        [self testFormat:@"%LA", value];
        [self testFormat:@"%Le", value];
        [self testFormat:@"%LE", value];
        [self testFormat:@"%Lf", value];
        [self testFormat:@"%LF", value];
        [self testFormat:@"%Lg", value];
        [self testFormat:@"%LG", value];
    }
}

- (void)testEmptyFormat {
    [self testFormat:@"Empty Format"];
    [self testFormat:@""];
}

- (void)testNilFormat {
    XCTAssertThrows([[NSAttributedString alloc] vp_initWithAttributedFormat:nil arguments:NULL]);
    XCTAssertThrows([[NSAttributedString alloc] vp_initWithAttributedFormat:nil]);
    XCTAssertThrows([NSAttributedString vp_attributedStringWithAttributedFormat:nil arguments:NULL]);
    XCTAssertThrows([NSAttributedString vp_attributedStringWithAttributedFormat:nil]);
}

#pragma mark -
#pragma mark Complex Formats

- (void)testComplexFormat1 {
    [self testFormat:@"%@ %@", @"1", @"2"];
}

- (void)testComplexFormat2 {
    [self testFormat:@"%@ water is hotter than %@", @"Hot", @"Cold"];
}

- (void)testComplexFormat3 {
    [self testFormat:@"%d mile is %g kilometers", 1, 1.61];
}

- (void)testComplexFormat4 {
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar getHour:&hour minute:&minute second:&second nanosecond:NULL fromDate:[NSDate date]];
    int width = 2;
    
    [self testFormat:@"Current time is %.*ld:%.*ld:%.*ld", width, (long)hour, width, (long)minute, width, (long)second];
}

- (void)testComplexFormat5 {
    int number = 50;
    int percent = 20;
    int result = number * percent / 100;
    
    [self testFormat:@"%3$d is %2$d%% of %1$d", number, percent, result];
}

- (void)testComplexFormat6 {
    long long value = 123;
    
    [self testFormat:@"%2$p is address for value %1$lld", value, &value];
}

- (void)testComplexFormat7 {
    double value1 = 12.34;
    double value2 = 43.21;
    double result = value1 + value2;
    int width = 6;
    int precision = 3;
    
    [self testFormat:@"%1$*4$.*5$lf + %2$*4$.*5$lf = %3$*4$lg", value1, value2, result, width, precision];
}

- (void)testComplexFormat8 {
    long double value = 12345.6789;
    int width = 15;
    int precision = 7;
    
    [self testFormat:@"%#-+*.*LE has unusual format", width, precision, value];
}

- (void)testComplexFormat9 {
    float value1 = 123.45f;
    int value2 = 12345;
    
    [self testFormat:@"Just two numbers: %+0#10.2f and % -10d", value1, value2];
}

- (void)testComplexFormat10 {
    [self testFormat:@"%%%%%@%%%d%%%@%%", @"This string contains ", 5, @" percent symbols"];
}

#pragma mark -
#pragma mark Attributed Formats

- (void)testAttributedFormat1 {
    UIColor *color1 = [UIColor greenColor];
    UIColor *color2 = [UIColor redColor];
    NSString *value1 = @"String1";
    NSString *value2 = @"String2";
    NSString *format = @"%@ %@";

    NSString *string = [NSString stringWithFormat:format, value1, value2];
    
    NSMutableAttributedString *attributedFormat = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedFormat addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(3, 2)];
    NSAttributedString *attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value1, value2];
    
    XCTAssertEqualObjects(string, attributedString.string);
    
    [attributedString enumerateAttributesInRange:[attributedString.string rangeOfString:value1] options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIColor *aColor1 = attrs[NSForegroundColorAttributeName];
        XCTAssertEqualObjects(color1, aColor1);
    }];
    [attributedString enumerateAttributesInRange:[attributedString.string rangeOfString:value2] options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIColor *aColor2 = attrs[NSForegroundColorAttributeName];
        XCTAssertEqualObjects(color2, aColor2);
    }];
}

- (void)testAttributedFormat2 {
    UIColor *color1 = [UIColor greenColor];
    UIColor *color2 = [UIColor redColor];
    UIColor *color3 = [UIColor blueColor];
    NSString *value = @"String";
    NSString *format = @"%@StringString%@";
    
    NSString *string = [NSString stringWithFormat:format, value, value];
    
    NSMutableAttributedString *attributedFormat = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedFormat addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(2, 12)];
    [attributedFormat addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(14, 2)];
    NSAttributedString *attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value, value];
    
    XCTAssertEqualObjects(string, attributedString.string);
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, 6) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIColor *aColor1 = attrs[NSForegroundColorAttributeName];
        XCTAssertEqualObjects(color1, aColor1);
    }];
    [attributedString enumerateAttributesInRange:NSMakeRange(6, 12) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIColor *aColor2 = attrs[NSForegroundColorAttributeName];
        XCTAssertEqualObjects(color2, aColor2);
    }];
    [attributedString enumerateAttributesInRange:NSMakeRange(18, 6) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIColor *aColor3 = attrs[NSForegroundColorAttributeName];
        XCTAssertEqualObjects(color3, aColor3);
    }];
}

- (void)testAttributedFormat3 {
    UIFont *font = [UIFont systemFontOfSize:12.0f];
    int value1 = 10;
    double value2 = 10.10;
    NSString *format = @"%d is not equal to %g";
    
    NSString *string = [NSString stringWithFormat:format, value1, value2];
    
    NSMutableAttributedString *attributedFormat = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedFormat addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, format.length)];
    NSAttributedString *attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value1, value2];
    
    XCTAssertEqualObjects(string, attributedString.string);
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, string.length) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont *aFont = attrs[NSFontAttributeName];
        XCTAssertEqualObjects(font, aFont);
    }];
}

- (void)testAttributedFormat4 {
    UIFont *font1 = [UIFont systemFontOfSize:12.0f];
    UIFont *font2 = [UIFont boldSystemFontOfSize:12.0f];
    NSArray *fonts = @[font1, font2];
    NSString *value = @"percent";
    NSString *format = @"%% is %@ symbol";
    
    NSString *string = [NSString stringWithFormat:format, value, value];
    
    NSMutableAttributedString *attributedFormat = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedFormat addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 2)];
    [attributedFormat addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(0, format.length)];
    NSAttributedString *attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value, value];
    
    XCTAssertEqualObjects(string, attributedString.string);
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, 1) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSFont *font = attrs[NSFontAttributeName];
        XCTAssertTrue([fonts containsObject:font]);
    }];
    [attributedString enumerateAttributesInRange:NSMakeRange(1, string.length - 1) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSFont *aFont2 = attrs[NSFontAttributeName];
        XCTAssertEqualObjects(font2, aFont2);
    }];
}

- (void)testAttributedFormat5 {
    UIFont *font1 = [UIFont systemFontOfSize:12.0f];
    UIFont *font2 = [UIFont boldSystemFontOfSize:12.0f];
    NSString *format = @"Simple string";
    
    NSMutableAttributedString *attributedFormat = [[NSMutableAttributedString alloc] initWithString:format];
    [attributedFormat addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 7)];
    [attributedFormat addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(7, 6)];
    NSAttributedString *attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat];
    
    XCTAssertEqualObjects(attributedString.string, format);
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, 7) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSFont *aFont1 = attrs[NSFontAttributeName];
        XCTAssertEqualObjects(font1, aFont1);
    }];
    [attributedString enumerateAttributesInRange:NSMakeRange(7, 6) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        NSFont *aFont2 = attrs[NSFontAttributeName];
        XCTAssertEqualObjects(font2, aFont2);
    }];
}

@end
