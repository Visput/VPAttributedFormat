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
}

- (void)testObjectFormat {
    [self testFormat:@"%@", @"String"];
    [self testFormat:@"%@", @1];
    [self testFormat:@"%@", @[@"String1", @"String2"]];
    [self testFormat:@"%@", @{@"Key1" : @"String", @"Key2" : @1}];
    [self testFormat:@"%@", [NSObject new]];
}

- (void)testIntFormat {
    [self testFormat:@"%d", 1];
    [self testFormat:@"%d", INT_MAX];
    [self testFormat:@"%d", INT_MIN];
}

@end
