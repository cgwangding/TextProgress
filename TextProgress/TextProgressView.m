//
//  TextView.m
//  TextProgress
//
//  Created by AD-iOS on 15/7/21.
//  Copyright (c) 2015年 Adinnet. All rights reserved.
//

#import "TextProgressView.h"

#import <CoreText/CoreText.h>

@interface TextProgressView ()
{
    float a;
    BOOL jia;
    
    CGFloat offsetX;
}

@property (nonatomic, copy) NSString *number;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat animationRatio;

@property (nonatomic, assign) CGFloat fillHeight;
@property (nonatomic, assign) CGFloat animateFillHeight;

@end

@implementation TextProgressView

- (instancetype)initWithFrame:(CGRect)frame number:(NSString *)nuberStr
{
    if (self = [super initWithFrame:frame]) {
        self.customFontName = @"Helvetica-Bold";
        self.fontSize = 200;
        self.strokeWidth = 1;
        self.strokeColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
        self.fillColor = [UIColor greenColor];
        self.number = nuberStr;
        self.upperFillColor  = [UIColor whiteColor];
        if (nuberStr == nil) {
            self.number = @"0";
        }
        self.animationRatio = .01;
        self.animateFillHeight = 0;
       [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSDefaultRunLoopMode];
        self.waveAnimation = NO;
        a = 1.5;
        jia = NO;
        offsetX = 0.4 / M_PI;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGMutablePathRef letters = CGPathCreateMutable();
    CFStringRef cString = (__bridge CFStringRef)self.customFontName;
    CTFontRef font = CTFontCreateWithName(cString, self.fontSize, NULL);
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           (__bridge id)font, kCTFontAttributeName,
                           nil];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.number
                                                                     attributes:attrs];
    CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    
    // for each RUN
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++)
    {
        // Get FONT for this run
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        
        // for each GLYPH in run
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++)
        {
            // get Glyph & Glyph-data
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            // Get PATH of outline
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CGPathRelease(letter);
            }
        }
    }
    CFRelease(line);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointZero];
    [path appendPath:[UIBezierPath bezierPathWithCGPath:letters]];
    
    CGPathRelease(letters);
    CFRelease(font);
    
    CGRect textBounds = CGPathGetBoundingBox(path.CGPath);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0,0);
    CGContextScaleCTM(context, -1.0, 1.0);
    CGContextSetShouldAntialias(context, YES);
    CGContextTranslateCTM(context, 0, textBounds.size.height);
    CGContextRotateCTM(context, M_PI);
    CGContextAddPath(context, path.CGPath);
    CGContextSetLineWidth(context, self.strokeWidth);
    CGContextSetStrokeColorWithColor(context, self.strokeColor.CGColor);
    CGContextStrokePath(context);
    
    CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGFloat ratio = 0;
    if ([self.number floatValue]) {
        ratio = [self.number floatValue] / 100;
    }
    self.fillHeight = (textBounds.size.height) * ratio;
    if (self.animateFillHeight > self.fillHeight) {
        self.animateFillHeight = self.fillHeight;
    }
    if (self.waveAnimation == NO) {
        CGContextFillRect(context, CGRectMake(0,textBounds.origin.y, self.frame.size.width, self.animateFillHeight));
    }
    
    
    
    //填充上半部分的颜色
    CGContextSetFillColorWithColor(context, self.upperFillColor.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextFillRect(context, CGRectMake(0, self.animateFillHeight + (textBounds.origin.y >0?-textBounds.origin.y:textBounds.origin.y), self.frame.size.width, textBounds.size.height - self.animateFillHeight));
    
    if (self.waveAnimation) {
        //画水波
        CGMutablePathRef wavePath = CGPathCreateMutable();
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGPathMoveToPoint(wavePath, nil, 0, - 10);
        float y = 0;
        
        for (float x = 0; x <= self.frame.size.width; x++) {
            y = a * 5 * sin(x  * M_PI / self.frame.size.width * 2.5 + offsetX) + self.animateFillHeight - 5;
            CGPathAddLineToPoint(wavePath, nil, x, y);
        }
        CGPathAddLineToPoint(wavePath, nil, self.frame.size.width , -10);
        CGPathAddLineToPoint(wavePath, nil, 0, -10);
        
        CGContextAddPath(context, wavePath);
        CGContextFillPath(context);
        CGPathRelease(wavePath);
        
        //画水波背后的阴影
        CGMutablePathRef shadoWavePath = CGPathCreateMutable();
        CGContextSetFillColorWithColor(context, [self.fillColor  colorWithAlphaComponent:.25].CGColor);
        CGPathMoveToPoint(shadoWavePath, nil, 0, -10);
        for (float x = 0; x <= self.frame.size.width; x++) {
            y = a * 5 * cos(x  * M_PI / self.frame.size.width * 2.5 + offsetX) + self.animateFillHeight - 5;
            CGPathAddLineToPoint(shadoWavePath, nil, x, y);
        }
        CGContextAddPath(context, shadoWavePath);
        CGContextFillPath(context);
        CGPathRelease(shadoWavePath);
        
    }
}

- (void)setDisplayNumber:(NSString *)numberStr
{
    self.number = numberStr;
    [self setNeedsDisplay];
}

- (NSTimer *)timer
{
    if (_timer == nil) {
        _timer = [NSTimer timerWithTimeInterval:.05 target:self selector:@selector(timeAnimation) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (void)timeAnimation
{
    //    if (self.animationRatio <= 1) {
    
    self.animateFillHeight = self.fillHeight * self.animationRatio;
    if (self.animationRatio < 1) {
        self.animationRatio += 0.05;
    }else{
        if (self.waveAnimation == NO) {
            [self invalidateTimer];
        }
    }
    if (jia) {
        a += 0.01;
    }else{
        a -= 0.01;
    }
    
    if (a <= 1) {
        jia = YES;
        
    }
    
    if (a>=1.6) {
        jia = NO;
    }
    offsetX += 0.5/M_PI;
    
    [self setNeedsDisplay];
}


- (void)invalidateTimer
{
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }else{
        self.timer = nil;
    }

}


@end
