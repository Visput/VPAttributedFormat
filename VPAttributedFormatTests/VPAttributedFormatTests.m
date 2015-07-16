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

- (void)testFormat:(NSString *)format, ... {
    NSAttributedString *attributedFormat = [[NSAttributedString alloc] initWithString:format];
    
    va_list arguments;
    va_start(arguments, format);
    NSString *string = [[NSString alloc] initWithFormat:format arguments:arguments];
    va_end(arguments);
    
    va_start(arguments, format);
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithAttributedFormat:attributedFormat arguments:arguments];
    va_end(arguments);
    
    XCTAssertEqualObjects(string, attributedString.string);
    
    NSLog(@"%@", string);
}

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
    char value = 'a';
    [self testFormat:@"%hhn", &value];
}

- (void)testSignedCharPointerFormat {
    signed char value = 'a';
    [self testFormat:@"%s", &value];
}

- (void)testUnsignedCharFormat {
    unsigned char value = 'a';
    [self testFormat:@"%hho", value];
    [self testFormat:@"%hhO", value];
    [self testFormat:@"%hhu", value];
    [self testFormat:@"%hhU", value];
    [self testFormat:@"%hhx", value];
    [self testFormat:@"%hhX", value];
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

- (void)testIntFormat {
    int numberOfValues = 5;
    int values[] = {1, INT_MIN, INT_MIN - 1, INT_MAX, INT_MAX + 1};
    
    for (int i = 0; i < numberOfValues; i++) {
        int value = values[i];
        [self testFormat:@"%d", value];
    }
}

- (void)testEmptyFormat {
    [self testFormat:@"Empty Format"];
    [self testFormat:@""];
}

- (void)testNilFormat {
    XCTAssertThrows([[NSAttributedString alloc] initWithAttributedFormat:nil arguments:NULL]);
    XCTAssertThrows([[NSAttributedString alloc] initWithAttributedFormat:nil]);
    XCTAssertThrows([NSAttributedString attributedStringWithAttributedFormat:nil]);
}

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

@end
