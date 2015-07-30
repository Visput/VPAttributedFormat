//
//  VPAttributedTextControlTests.m
//  VPAttributedFormat
//
//  Created by Uladzimir Papko on 7/28/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "UILabel+VPAttributedFormat.h"
#import "UITextField+VPAttributedFormat.h"
#import "UITextView+VPAttributedFormat.h"
#import "NSAttributedString+VPAttributedFormat.h"

@interface VPAttributedTextControlTests : XCTestCase

@end

@implementation VPAttributedTextControlTests

- (void)testSetAttributedFormatArguments {
    [self testSetAttributedFormatArgumentsByKeepingFormat:YES];
    [self testSetAttributedFormatArgumentsByKeepingFormat:NO];
}

- (void)testSetAttributedFormatArgumentsByKeepingFormat:(BOOL)keepFormat {
    // Data
    NSArray *controlClasses = @[[UILabel class], [UITextField class], [UITextView class]];
    
    UIColor *color1 = [UIColor greenColor];
    UIColor *color2 = [UIColor redColor];
    UIColor *color3 = [UIColor blueColor];
    
    NSString *format1 = @"%@StringString%@";
    NSMutableAttributedString *attributedFormat1 = [[NSMutableAttributedString alloc] initWithString:format1];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(2, 12)];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(14, 2)];
    
    NSString *format2 = @"%@ %@";
    NSMutableAttributedString *attributedFormat2 = [[NSMutableAttributedString alloc] initWithString:format2];
    [attributedFormat2 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(3, 2)];
    
    NSString *value1 = @"String";
    NSString *value2 = @"Another String";
    
    // Test
    NSAttributedString *attributedFormat = nil;
    NSAttributedString *attributedString = nil;
    
    for (Class class  in controlClasses) {
        id control = [class new];
        [control setAttributedText:attributedFormat1];
        attributedFormat = [control attributedText];
        
        [control vp_setAttributedFormatArguments:keepFormat, value1, value2];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value1, value2];
        XCTAssertEqualObjects([control attributedText], attributedString);
        
        [control vp_setAttributedFormatArguments:keepFormat, value2, value1];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value2, value1];
        if (keepFormat) {
            XCTAssertEqualObjects([control attributedText], attributedString);
        } else {
            XCTAssertNotEqualObjects([control attributedText], attributedString);
        }
        
        [control setAttributedText:attributedFormat2];
        attributedFormat = [control attributedText];
        
        [control vp_setAttributedFormatArguments:keepFormat, value1, value1];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value1, value1];
        XCTAssertEqualObjects([control attributedText], attributedString);
        
        [control vp_setAttributedFormatArguments:keepFormat, value2, value2];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, value2, value2];
        if (keepFormat) {
            XCTAssertEqualObjects([control attributedText], attributedString);
        } else {
            XCTAssertNotEqualObjects([control attributedText], attributedString);
        }
    }
}


@end
