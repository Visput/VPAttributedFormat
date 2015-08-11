//
//  ViewController.m
//  VPAttributedFormatExample
//
//  Created by Uladzimir Papko on 6/26/15.
//  Copyright (c) 2015 Visput. All rights reserved.
//

#import "VPViewController.h"

@import VPAttributedFormat;

@interface VPViewController ()

@property (nonatomic, strong) NSTimer *timer;

// Basic.
@property (nonatomic, weak) IBOutlet UIView *basicFormatsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *basicFormatsViewTrailingSpace;
@property (nonatomic, weak) IBOutlet UIButton *basicFormatButton1;
@property (nonatomic, weak) IBOutlet UITextField *basicFormatTextField2;;
@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel3;
@property (nonatomic, weak) IBOutlet UITextView *basicFormatTextView4;

// Pro.
@property (nonatomic, weak) IBOutlet UIView *proFormatsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *proFormatsViewLeadingSpace;
@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel1;
@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel2;
@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel3;
@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel4;

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Basic.
    [self.view bringSubviewToFront:self.basicFormatsView];
    self.basicFormatsViewTrailingSpace.constant = 0;
    [self fillBasicFormat1]; // Demonstrates "UIButton+VPAttributedFormat" category.
    [self fillBasicFormat2]; // Demonstrates "UITextField+VPAttributedFormat" category.
    [self fillBasicFormat3]; // Demonstrates "UILabel+VPAttributedFormat" category.
    [self fillBasicFormat4]; // Demonstrates "UITextView+VPAttributedFormat" category.
    
    // Pro.
    self.proFormatsViewLeadingSpace.constant = 0;
    [self fillProFormat1]; // Demonstrates "NSAttributedString+VPAttributedFormat" category.
    [self fillProFormat2]; // Demonstrates "NSAttributedString+VPAttributedFormat" category.
    [self fillProFormat3]; // Demonstrates "NSAttributedString+VPAttributedFormat" category.
    [self fillProFormat4]; // Demonstrates "NSAttributedString+VPAttributedFormat" category.
}

- (IBAction)onSegmentControlValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        [self.view bringSubviewToFront:self.basicFormatsView];
    } else {
        [self.view bringSubviewToFront:self.proFormatsView];
    }
}

#pragma mark -
#pragma mark Basic

- (void)fillBasicFormat1 {
    NSString *hot = @"Hot";
    NSString *cold = @"Cold";
    
    [self.basicFormatButton1 vp_setAttributedTitleFormatArgumentsForState:UIControlStateNormal
                                                               keepFormat:YES, hot, cold];
    
    [self.basicFormatButton1 vp_setAttributedTitleFormatArgumentsForState:UIControlStateHighlighted
                                                               keepFormat:YES, hot, cold];
}

- (void)fillBasicFormat2 {
    int mile = 1;
    double kilometer = 1.61;
    
    self.basicFormatTextField2.attributedPlaceholder = self.basicFormatTextField2.attributedText;
    
    [self.basicFormatTextField2 vp_setAttributedPlaceholderFormatArguments:YES, mile, kilometer];
    [self.basicFormatTextField2 vp_setAttributedTextFormatArguments:YES, mile, kilometer];
    
}

- (void)fillBasicFormat3 {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(fillBasicFormat3)
                                                    userInfo:nil
                                                     repeats:YES];
    }
    
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar getHour:&hour minute:&minute second:&second nanosecond:NULL fromDate:[NSDate date]];
    int width = 2;
    
    [self.basicFormatLabel3 vp_setAttributedTextFormatArguments:YES, width, (long)hour, width, (long)minute, width, (long)second];
}

- (void)fillBasicFormat4 {
    int number = 50;
    int percent = 20;
    int result = number * percent / 100;
    
    [self.basicFormatTextView4 vp_setAttributedTextFormatArguments:YES, number, percent, result];
}

#pragma mark -
#pragma mark Pro

- (void)fillProFormat1 {
    long long value = 123;
    
    self.proFormatLabel1.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.proFormatLabel1.attributedText,
                                          value,
                                          &value];
}

- (void)fillProFormat2 {
    double value1 = 12.34;
    double value2 = 43.21;
    double result = value1 + value2;
    int width = 6;
    int precision = 3;
    
    self.proFormatLabel2.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.proFormatLabel2.attributedText,
                                          value1,
                                          value2,
                                          result,
                                          width,
                                          precision];
}

- (void)fillProFormat3 {
    long double value = 12345.6789;
    int width = 15;
    int precision = 7;
    
    self.proFormatLabel3.attributedText = [[NSAttributedString alloc] vp_initWithAttributedFormat:self.proFormatLabel3.attributedText,
                                           width,
                                           precision,
                                           value];
}

- (void)fillProFormat4 {
    float value1 = 123.45;
    int value2 = 12345;
    
    self.proFormatLabel4.attributedText = [[NSAttributedString alloc] vp_initWithAttributedFormat:self.proFormatLabel4.attributedText,
                                           value1,
                                           value2];
}

@end
