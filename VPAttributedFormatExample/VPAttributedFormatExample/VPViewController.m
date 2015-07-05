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

@property (nonatomic, weak) IBOutlet UILabel *labelFormat1;
@property (nonatomic, weak) IBOutlet UILabel *labelValue1;

@property (nonatomic, weak) IBOutlet UILabel *labelFormat2;
@property (nonatomic, weak) IBOutlet UILabel *labelValue2;

@property (nonatomic, weak) IBOutlet UILabel *labelFormat3;
@property (nonatomic, weak) IBOutlet UILabel *labelValue3;

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillLabelValue1];
    [self fillLabelValue2];
    [self fillLabelValue3];
}

- (void)fillLabelValue1 {
    NSString *name = @"Uladzimir Papko";
    int age = 26;
    
    self.labelValue1.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.labelFormat1.attributedText, name, age];
}

- (void)fillLabelValue2 {
    NSString *name = @"Uladzimir Papko";
    int age = 26;
    
    self.labelValue2.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.labelFormat2.attributedText, age, name];
}

- (void)fillLabelValue3 {
    NSString *name = @"Uladzimir Papko";
    long long age = 26;
    int width = 4;
    int precision = 3;
    
    self.labelValue3.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.labelFormat3.attributedText, age, name, precision, width];
}

@end
