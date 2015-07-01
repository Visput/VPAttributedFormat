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

@end

@implementation VPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", [NSString stringWithFormat:@"%1$*2$.*3$g", 1.0, 1, 1]);
    NSLog(@"%@", [NSString stringWithFormat:@"%*.*g", 1, 1, 1.0]);
   
    NSAttributedString *format = [[NSAttributedString alloc] initWithString:@"Hi, I am Vova, I am 26 years old"];
    NSAttributedString *string = [NSAttributedString attributedStringWithAttributedFormat:format];
    NSLog(@"%@", string);
}

@end
