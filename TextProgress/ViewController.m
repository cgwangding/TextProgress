//
//  ViewController.m
//  TextProgress
//
//  Created by AD-iOS on 15/7/21.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import "ViewController.h"

#import "TextProgressView.h"

@interface ViewController ()

@property (nonatomic, strong)CAGradientLayer *gradientLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    TextProgressView *view = [[TextProgressView alloc]initWithFrame:self.view.bounds number:@"90"];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    [view setDisplayNumber:@"50"];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
