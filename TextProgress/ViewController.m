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

- (void)showGradientText
{
    // 创建UILabel
    UILabel *label = [[UILabel alloc] init];
    
    label.text = @"小码哥,专注于高级iOS开发工程师的培养";
    
    [label sizeToFit];
    
    label.center = CGPointMake(200, 100);
    
    // 疑问：label只是用来做文字裁剪，能否不添加到view上。
    // 必须要把Label添加到view上，如果不添加到view上，label的图层就不会调用drawRect方法绘制文字，也就没有文字裁剪了。
    // 如何验证，自定义Label,重写drawRect方法，看是否调用,发现不添加上去，就不会调用
    [self.view addSubview:label];
    
    // 创建渐变层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
    
    // 设置渐变层的颜色，随机颜色渐变
    gradientLayer.colors = @[(id)[self randomColor].CGColor, (id)[self randomColor].CGColor,(id)[self randomColor].CGColor];
    
    // 疑问:渐变层能不能加在label上
    // 不能，mask原理：默认会显示mask层底部的内容，如果渐变层放在mask层上，就不会显示了
    
    // 添加渐变层到控制器的view图层上
    [self.view.layer addSublayer:gradientLayer];
    self.gradientLayer = gradientLayer;
    
    // mask层工作原理:按照透明度裁剪，只保留非透明部分，文字就是非透明的，因此除了文字，其他都被裁剪掉，这样就只会显示文字下面渐变层的内容，相当于留了文字的区域，让渐变层去填充文字的颜色。
    // 设置渐变层的裁剪层
    gradientLayer.mask = label.layer;
    
    // 注意:一旦把label层设置为mask层，label层就不能显示了,会直接从父层中移除，然后作为渐变层的mask层，且label层的父层会指向渐变层，这样做的目的：以渐变层为坐标系，方便计算裁剪区域，如果以其他层为坐标系，还需要做点的转换，需要把别的坐标系上的点，转换成自己坐标系上点，判断当前点在不在裁剪范围内，比较麻烦。
    
    
    // 父层改了，坐标系也就改了，需要重新设置label的位置，才能正确的设置裁剪区域。
    label.frame = gradientLayer.bounds;
    
    // 利用定时器，快速的切换渐变颜色，就有文字颜色变化效果
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(textColorChange)];
    
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

// 随机颜色方法
-(UIColor *)randomColor{
    CGFloat r = arc4random_uniform(256) / 255.0;
    CGFloat g = arc4random_uniform(256) / 255.0;
    CGFloat b = arc4random_uniform(256) / 255.0;
    return [UIColor colorWithRed:r green:g blue:b alpha:1];
}

// 定时器触发方法
-(void)textColorChange {
    _gradientLayer.colors = @[(id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor,
                              (id)[self randomColor].CGColor];
}

@end
