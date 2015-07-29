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

@property (nonatomic, copy) NSString *number;

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
    CGContextFillRect(context, CGRectMake(0, -10, self.frame.size.width, (textBounds.size.height + 10) * ratio));

    
    //填充上半部分的颜色
    CGContextSetFillColorWithColor(context, self.upperFillColor.CGColor);
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    CGContextFillRect(context, CGRectMake(0, (textBounds.size.height  - 10)* ratio , self.frame.size.width, (textBounds.size.height + 10) * (1 - ratio)));
    
}

- (void)setDisplayNumber:(NSString *)numberStr
{
    self.number = numberStr;
    [self setNeedsDisplay];
}

@end
