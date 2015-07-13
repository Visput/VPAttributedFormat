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

- (void)testComplexFormat1 {
    [self testFormat:@"%@ %@", @"1", @"2"];
}

@end
