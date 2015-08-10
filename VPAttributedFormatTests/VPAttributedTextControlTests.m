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
#import "UIButton+VPAttributedFormat.h"
#import "NSAttributedString+VPAttributedFormat.h"

@interface VPAttributedTextControlTests : XCTestCase

@property (nonatomic, strong) NSAttributedString *attributedFormat1;
@property (nonatomic, strong) NSAttributedString *attributedFormat2;
@property (nonatomic, strong) NSString *value1;
@property (nonatomic, strong) NSString *value2;

@end

@implementation VPAttributedTextControlTests

- (void)setUp {
    [super setUp];
    
    UIColor *color1 = [UIColor greenColor];
    UIColor *color2 = [UIColor redColor];
    UIColor *color3 = [UIColor blueColor];
    
    NSString *format1 = @"%@StringString%@";
    NSMutableAttributedString *attributedFormat1 = [[NSMutableAttributedString alloc] initWithString:format1];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(2, 12)];
    [attributedFormat1 addAttribute:NSForegroundColorAttributeName value:color3 range:NSMakeRange(14, 2)];
    self.attributedFormat1 = attributedFormat1.copy;
    
    NSString *format2 = @"%@ %@";
    NSMutableAttributedString *attributedFormat2 = [[NSMutableAttributedString alloc] initWithString:format2];
    [attributedFormat2 addAttribute:NSForegroundColorAttributeName value:color1 range:NSMakeRange(0, 2)];
    [attributedFormat2 addAttribute:NSForegroundColorAttributeName value:color2 range:NSMakeRange(3, 2)];
    self.attributedFormat2 = attributedFormat2.copy;
    
    self.value1 = @"String";
    self.value2 = @"Another String";
}

#pragma mark -
#pragma mark Utility

- (void)testSetAttributedTextFormatArgumentsByKeepingFormat:(BOOL)keepFormat
                                            forControlClass:(Class)controlClass {
    NSAttributedString *attributedFormat = nil;
    NSAttributedString *attributedString = nil;
    
    id control = [controlClass new];
    [control setAttributedText:self.attributedFormat1];
    attributedFormat = [control attributedText];
    
    [control vp_setAttributedTextFormatArguments:keepFormat, self.value1, self.value2];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value2];
    XCTAssertEqualObjects([control attributedText], attributedString);
    
    [control vp_setAttributedTextFormatArguments:keepFormat, self.value2, self.value1];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value1];
    if (keepFormat) {
        XCTAssertEqualObjects([control attributedText], attributedString);
    } else {
        XCTAssertNotEqualObjects([control attributedText], attributedString);
    }
    
    [control setAttributedText:self.attributedFormat2];
    attributedFormat = [control attributedText];
    
    [control vp_setAttributedTextFormatArguments:keepFormat, self.value1, self.value1];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value1];
    XCTAssertEqualObjects([control attributedText], attributedString);
    
    [control vp_setAttributedTextFormatArguments:keepFormat, self.value2, self.value2];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value2];
    if (keepFormat) {
        XCTAssertEqualObjects([control attributedText], attributedString);
    } else {
        XCTAssertNotEqualObjects([control attributedText], attributedString);
    }
}

- (void)testUITextFieldSetAttributedPlaceholderFormatArgumentsByKeepingFormat:(BOOL)keepFormat {
    NSAttributedString *attributedFormat = nil;
    NSAttributedString *attributedString = nil;
    
    UITextField *control = [UITextField new];
    [control setAttributedPlaceholder:self.attributedFormat1];
    attributedFormat = [control attributedPlaceholder];
    
    [control vp_setAttributedPlaceholderFormatArguments:keepFormat, self.value1, self.value2];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value2];
    XCTAssertEqualObjects([control attributedPlaceholder], attributedString);
    
    [control vp_setAttributedPlaceholderFormatArguments:keepFormat, self.value2, self.value1];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value1];
    if (keepFormat) {
        XCTAssertEqualObjects([control attributedPlaceholder], attributedString);
    } else {
        XCTAssertNotEqualObjects([control attributedPlaceholder], attributedString);
    }
    
    [control setAttributedPlaceholder:self.attributedFormat2];
    attributedFormat = [control attributedPlaceholder];
    
    [control vp_setAttributedPlaceholderFormatArguments:keepFormat, self.value1, self.value1];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value1];
    XCTAssertEqualObjects([control attributedPlaceholder], attributedString);
    
    [control vp_setAttributedPlaceholderFormatArguments:keepFormat, self.value2, self.value2];
    attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value2];
    if (keepFormat) {
        XCTAssertEqualObjects([control attributedPlaceholder], attributedString);
    } else {
        XCTAssertNotEqualObjects([control attributedPlaceholder], attributedString);
    }
}

- (void)testUIButtonSetAttributedTitleFormatArgumentsByKeepingFormat:(BOOL)keepFormat {
    int statesCount = 6;
    UIControlState states[] = {
        UIControlStateNormal,
        UIControlStateDisabled,
        UIControlStateSelected,
        UIControlStateHighlighted,
        UIControlStateReserved,
        UIControlStateApplication};
    
    NSAttributedString *attributedFormat = nil;
    NSAttributedString *attributedString = nil;
    
    UIButton *control = [UIButton new];
    
    for (int i = 0; i < statesCount; i++) {
        UIControlState state = states[i];
        
        [control setAttributedTitle:self.attributedFormat1 forState:state];
        attributedFormat = [control attributedTitleForState:state];
        
        [control vp_setAttributedTitleFormatArgumentsForState:state keepFormat:keepFormat, self.value1, self.value2];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value2];
        XCTAssertEqualObjects([control attributedTitleForState:state], attributedString);
        
        [control vp_setAttributedTitleFormatArgumentsForState:state keepFormat:keepFormat, self.value2, self.value1];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value1];
        if (keepFormat) {
            XCTAssertEqualObjects([control attributedTitleForState:state], attributedString);
        } else {
            XCTAssertNotEqualObjects([control attributedTitleForState:state], attributedString);
        }
        
        [control setAttributedTitle:self.attributedFormat2 forState:state];
        attributedFormat = [control attributedTitleForState:state];
        
        [control vp_setAttributedTitleFormatArgumentsForState:state keepFormat:keepFormat, self.value1, self.value1];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value1, self.value1];
        XCTAssertEqualObjects([control attributedTitleForState:state], attributedString);
        
        [control vp_setAttributedTitleFormatArgumentsForState:state keepFormat:keepFormat, self.value2, self.value2];
        attributedString = [NSAttributedString vp_attributedStringWithAttributedFormat:attributedFormat, self.value2, self.value2];
        if (keepFormat) {
            XCTAssertEqualObjects([control attributedTitleForState:state], attributedString);
        } else {
            XCTAssertNotEqualObjects([control attributedTitleForState:state], attributedString);
        }
    }
}

#pragma mark -
#pragma mark Tests

- (void)testUILabelSetAttributedTextFormatArguments {
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:YES
                                              forControlClass:[UILabel class]];
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:NO
                                              forControlClass:[UILabel class]];
}

- (void)testUITextFieldSetAttributedTextFormatArguments {
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:YES
                                              forControlClass:[UITextField class]];
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:NO
                                              forControlClass:[UITextField class]];
}

- (void)testUITextViewSetAttributedTextFormatArguments {
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:YES
                                              forControlClass:[UITextView class]];
    [self testSetAttributedTextFormatArgumentsByKeepingFormat:NO
                                              forControlClass:[UITextView class]];
}

- (void)testUITextFieldSetAttributedPlaceholderFormatArguments {
    [self testUITextFieldSetAttributedPlaceholderFormatArgumentsByKeepingFormat:YES];
    [self testUITextFieldSetAttributedPlaceholderFormatArgumentsByKeepingFormat:NO];
}

- (void)testUIButtonSetAttributedTitleFormatArguments {
    [self testUIButtonSetAttributedTitleFormatArgumentsByKeepingFormat:YES];
    [self testUIButtonSetAttributedTitleFormatArgumentsByKeepingFormat:NO];
}

- (void)testUIButtonWithDifferentStates {
    UIButton *control = [UIButton new];
    
    [control setAttributedTitle:self.attributedFormat1 forState:UIControlStateNormal];
    [control vp_setAttributedTitleFormatArgumentsForState:UIControlStateNormal keepFormat:YES, self.value1, self.value2];
    NSAttributedString *titleForNormalState = [control attributedTitleForState:UIControlStateNormal];
    
    [control setAttributedTitle:self.attributedFormat2 forState:UIControlStateSelected];
    [control vp_setAttributedTitleFormatArgumentsForState:UIControlStateSelected keepFormat:YES, self.value2, self.value1];
    NSAttributedString *titleForSelectedState = [control attributedTitleForState:UIControlStateSelected];
    
    XCTAssertEqualObjects([control attributedTitleForState:UIControlStateNormal], titleForNormalState);
    XCTAssertEqualObjects([control attributedTitleForState:UIControlStateSelected], titleForSelectedState);
}

- (void)testUIButtonWithInvalidState {
    static int const VPControlStateInvalid = 100;
    UIButton *control = [UIButton new];
    
    [control setAttributedTitle:self.attributedFormat1 forState:UIControlStateNormal];
    XCTAssertThrows([control vp_setAttributedTitleFormatArgumentsForState:VPControlStateInvalid keepFormat:YES]);
}

@end
