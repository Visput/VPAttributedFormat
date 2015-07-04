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

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillLabelValue1];
}

- (void)fillLabelValue1 {
    NSString *name = @"Uladzimir Papko";
    int age = 26;
    
    self.labelValue1.attributedText = [NSAttributedString attributedStringWithAttributedFormat:self.labelFormat1.attributedText, name, age];
}

@end
