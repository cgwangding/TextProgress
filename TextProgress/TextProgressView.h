//
//  TextView.h
//  TextProgress
//
//  Created by AD-iOS on 15/7/21.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextProgressView : UIView

@property (nonatomic, copy) NSString *customFontName;
@property (nonatomic, assign) NSInteger fontSize;

@property (nonatomic, strong) UIColor *strokeColor;
@property (nonatomic, strong) UIColor *fillColor;

/**
 *  使用数字初始化
 *
 *  @param frame    frame，数字的绘制区域
 *  @param nuberStr 需要绘制的数字
 *
 *  @return TextProgressView的对象
 */
- (instancetype)initWithFrame:(CGRect)frame number:(NSString*)nuberStr;

- (void)setDisplayNumber:(NSString*)numberStr;


@end
