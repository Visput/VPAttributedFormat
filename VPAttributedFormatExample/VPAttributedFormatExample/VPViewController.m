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

// Basic.
@property (nonatomic, weak) IBOutlet UIView *basicFormatsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *basicFormatsViewTrailingSpace;

@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel1;
@property (nonatomic, weak) IBOutlet UILabel *basicValueLabel1;

@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel2;
@property (nonatomic, weak) IBOutlet UILabel *basicValueLabel2;

@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel3;
@property (nonatomic, weak) IBOutlet UILabel *basicValueLabel3;

@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel4;
@property (nonatomic, weak) IBOutlet UILabel *basicValueLabel4;

// Pro.
@property (nonatomic, weak) IBOutlet UIView *proFormatsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *proFormatsViewLeadingSpace;

@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel1;
@property (nonatomic, weak) IBOutlet UILabel *proValueLabel1;

@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel2;
@property (nonatomic, weak) IBOutlet UILabel *proValueLabel2;

@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel3;
@property (nonatomic, weak) IBOutlet UILabel *proValueLabel3;

@property (nonatomic, weak) IBOutlet UILabel *proFormatLabel4;
@property (nonatomic, weak) IBOutlet UILabel *proValueLabel4;

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Basic.
    [self.view bringSubviewToFront:self.basicFormatsView];
    self.basicFormatsViewTrailingSpace.constant = 0;
    [self fillBasicValueLabel1];
    [self fillBasicValueLabel2];
    [self fillBasicValueLabel3];
    [self fillBasicValueLabel4];
    
    // Pro.
    self.proFormatsViewLeadingSpace.constant = 0;
    [self fillProValueLabel1];
    [self fillProValueLabel2];
    [self fillProValueLabel3];
    [self fillProValueLabel4];
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

- (void)fillBasicValueLabel1 {
    NSString *hot = @"Hot";
    NSString *cold = @"Cold";
    
    self.basicValueLabel1.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicFormatLabel1.attributedText,
                                            hot,
                                            cold];
}

- (void)fillBasicValueLabel2 {
    int mile = 1;
    double kilometer = 1.61;
    
    self.basicValueLabel2.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicFormatLabel2.attributedText,
                                            mile,
                                            kilometer];
}

- (void)fillBasicValueLabel3 {
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar getHour:&hour minute:&minute second:&second nanosecond:NULL fromDate:[NSDate date]];
    int width = 2;
    
    self.basicValueLabel3.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicFormatLabel3.attributedText,
                                            width,
                                            (long)hour,
                                            width,
                                            (long)minute,
                                            width,
                                            (long)second];
}

- (void)fillBasicValueLabel4 {
    int number = 50;
    int percent = 20;
    int result = number * percent / 100;
    
    self.basicValueLabel4.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicFormatLabel4.attributedText,
                                            number,
                                            percent,
                                            result];
}

#pragma mark -
#pragma mark Pro

- (void)fillProValueLabel1 {
    long long value = 123;
    
    self.proValueLabel1.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.proFormatLabel1.attributedText,
                                          value,
                                          &value];
}

- (void)fillProValueLabel2 {
    double value1 = 12.34;
    double value2 = 43.21;
    double result = value1 + value2;
    int width = 6;
    int precision = 3;
    
    self.proValueLabel2.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.proFormatLabel2.attributedText,
                                          value1,
                                          value2,
                                          result,
                                          width,
                                          precision];
}

- (void)fillProValueLabel3 {
    long double value = 12345.6789;
    int width = 15;
    int precision = 7;
    
    self.proValueLabel3.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.proFormatLabel3.attributedText,
                                          width,
                                          precision,
                                          value];
}

- (void)fillProValueLabel4 {
    float value1 = 123.45;
    int value2 = 12345;
    
    self.proValueLabel4.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.proFormatLabel4.attributedText,
                                          value1,
                                          value2];
}

@end
