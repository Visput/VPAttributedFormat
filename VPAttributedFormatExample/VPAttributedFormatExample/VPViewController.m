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

@property (nonatomic, weak) IBOutlet UILabel *basicLabelFormat1;
@property (nonatomic, weak) IBOutlet UILabel *basicLabelValue1;

@property (nonatomic, weak) IBOutlet UILabel *basicLabelFormat2;
@property (nonatomic, weak) IBOutlet UILabel *basicLabelValue2;

@property (nonatomic, weak) IBOutlet UILabel *basicLabelFormat3;
@property (nonatomic, weak) IBOutlet UILabel *basicLabelValue3;

@property (nonatomic, weak) IBOutlet UILabel *basicLabelFormat4;
@property (nonatomic, weak) IBOutlet UILabel *basicLabelValue4;

// Pro.
@property (nonatomic, weak) IBOutlet UIView *proFormatsView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *proFormatsViewLeadingSpace;

@property (nonatomic, weak) IBOutlet UILabel *proLabelFormat1;
@property (nonatomic, weak) IBOutlet UILabel *proLabelValue1;

@property (nonatomic, weak) IBOutlet UILabel *proLabelFormat2;
@property (nonatomic, weak) IBOutlet UILabel *proLabelValue2;

@property (nonatomic, weak) IBOutlet UILabel *proLabelFormat3;
@property (nonatomic, weak) IBOutlet UILabel *proLabelValue3;

@property (nonatomic, weak) IBOutlet UILabel *proLabelFormat4;
@property (nonatomic, weak) IBOutlet UILabel *proLabelValue4;

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Basic.
    [self.view bringSubviewToFront:self.basicFormatsView];
    self.basicFormatsViewTrailingSpace.constant = 0;
    [self fillBasicLabelValue1];
    [self fillBasicLabelValue2];
    [self fillBasicLabelValue3];
    [self fillBasicLabelValue4];
    
    // Pro.
    self.proFormatsViewLeadingSpace.constant = 0;
    [self fillProLabelValue1];
    [self fillProLabelValue2];
    [self fillProLabelValue3];
    [self fillProLabelValue4];
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

- (void)fillBasicLabelValue1 {
    NSString *hot = @"Hot";
    NSString *cold = @"Cold";
    
    self.basicLabelValue1.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicLabelFormat1.attributedText,
                                            hot,
                                            cold];
}

- (void)fillBasicLabelValue2 {
    int mile = 1;
    double kilometer = 1.61;
    
    self.basicLabelValue2.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicLabelFormat2.attributedText,
                                            mile,
                                            kilometer];
}

- (void)fillBasicLabelValue3 {
    NSInteger hour = 0;
    NSInteger minute = 0;
    NSInteger second = 0;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar getHour:&hour minute:&minute second:&second nanosecond:NULL fromDate:[NSDate date]];
    int width = 2;
    
    self.basicLabelValue3.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicLabelFormat3.attributedText,
                                            width,
                                            (long)hour,
                                            width,
                                            (long)minute,
                                            width,
                                            (long)second];
}

- (void)fillBasicLabelValue4 {
    int number = 50;
    int percent = 20;
    int result = number * percent / 100;
    
    self.basicLabelValue4.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.basicLabelFormat4.attributedText,
                                            number,
                                            percent,
                                            result];
}

#pragma mark -
#pragma mark Pro

- (void)fillProLabelValue1 {
    
}

- (void)fillProLabelValue2 {
    
}

- (void)fillProLabelValue3 {

}

- (void)fillProLabelValue4 {
    
}

@end
