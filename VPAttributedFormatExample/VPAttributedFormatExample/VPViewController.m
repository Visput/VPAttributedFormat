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

@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel1;
@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel2;;
@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel3;
@property (nonatomic, weak) IBOutlet UILabel *basicFormatLabel4;

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
    [self fillBasicFormatLabel1];
    [self fillBasicFormatLabel2];
    [self fillBasicFormatLabel3];
    [self fillBasicFormatLabel4];
    
    // Pro.
    self.proFormatsViewLeadingSpace.constant = 0;
    [self fillProFormatLabel1];
    [self fillProFormatLabel2];
    [self fillProFormatLabel3];
    [self fillProFormatLabel4];
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

- (void)fillBasicFormatLabel1 {
    NSString *hot = @"Hot";
    NSString *cold = @"Cold";
    
    self.basicFormatLabel1.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.basicFormatLabel1.attributedText,
                                            hot,
                                            cold];
}

- (void)fillBasicFormatLabel2 {
    int mile = 1;
    double kilometer = 1.61;
    
    self.basicFormatLabel2.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.basicFormatLabel2.attributedText,
                                            mile,
                                            kilometer];
}

- (void)fillBasicFormatLabel3 {
    if (self.timer == nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                      target:self
                                                    selector:@selector(fillBasicFormatLabel3)
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

- (void)fillBasicFormatLabel4 {
    int number = 50;
    int percent = 20;
    int result = number * percent / 100;
    
    self.basicFormatLabel4.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.basicFormatLabel4.attributedText,
                                            number,
                                            percent,
                                            result];
}

#pragma mark -
#pragma mark Pro

- (void)fillProFormatLabel1 {
    long long value = 123;
    
    self.proFormatLabel1.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.proFormatLabel1.attributedText,
                                          value,
                                          &value];
}

- (void)fillProFormatLabel2 {
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

- (void)fillProFormatLabel3 {
    long double value = 12345.6789;
    int width = 15;
    int precision = 7;
    
    self.proFormatLabel3.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.proFormatLabel3.attributedText,
                                          width,
                                          precision,
                                          value];
}

- (void)fillProFormatLabel4 {
    float value1 = 123.45;
    int value2 = 12345;
    
    self.proFormatLabel4.attributedText = [NSAttributedString vp_attributedStringWithAttributedFormat:self.proFormatLabel4.attributedText,
                                          value1,
                                          value2];
}

@end
