//
//  TextView.h
//  TextProgress
//
//  Created by AD-iOS on 15/7/21.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

//需要添加CoreText.framework

#import <UIKit/UIKit.h>

@interface TextProgressView : UIView

/**
 *  使用以下两个属性来设置字体
 */
@property (nonatomic, copy) NSString *customFontName;
@property (nonatomic, assign) NSInteger fontSize;

/**
 *  边界的颜色，默认灰色
 */
@property (nonatomic, strong) UIColor *strokeColor;
/**
 *  边界的宽度，默认1
 */
@property (nonatomic, assign) CGFloat strokeWidth;
/**
 *  下半部分填充的颜色，可自行设置，默认绿色
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 *  上半部分填充的颜色，默认白色
 */
@property (nonatomic, strong) UIColor *upperFillColor;

/**
 *  是否使用水波动画，默认不开启
 */
@property (nonatomic, assign) BOOL waveAnimation;

/**
 *  使用数字初始化
 *
 *  @param frame    frame，数字的绘制区域
 *  @param nuberStr 需要绘制的数字
 *
 *  @return TextProgressView的对象
 */
- (instancetype)initWithFrame:(CGRect)frame number:(NSString*)nuberStr;

/**
 *  设置需要显示的数字
 *
 *  @param numberStr 数字字符串，数字内容0-100
 */
- (void)setDisplayNumber:(NSString*)numberStr;

/**
 *  使timer失效，当开启水波动画时请在页面消失时手动调用该方法
 */
- (void)invalidateTimer;


@end
