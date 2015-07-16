//
//  MProgressBar.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MRoundProgressBar.h"

@interface MRoundProgressBar ()

@property (nonatomic , retain)CAShapeLayer      *shapeLayer1 ;
@property (nonatomic , retain)CAShapeLayer      *shapeLayer ;
@property (nonatomic , retain)UILabel                      *progressBarLabel ;

@end
@implementation MRoundProgressBar

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
         [self _initDefaultUI];
    }
    return self ;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self _initDefaultUI];
    }
    
    return self ;
}

- (void)_initDefaultUI
{
    self.backgroundColor = [UIColor clearColor];
    
    //shapeLayer1
    self.shapeLayer1 = [CAShapeLayer layer];
    self.shapeLayer1.frame = CGRectMake(0, 0, self.width , self.height);
    //self.shapeLayer1.position = self.center ;
    
    self.shapeLayer1.fillColor = [UIColor clearColor].CGColor ;
    self.shapeLayer1.strokeColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:0.3].CGColor ;
    self.shapeLayer1.lineWidth = 5.f ;
    self.shapeLayer1.strokeStart = 0.f ;
    self.shapeLayer1.strokeEnd = 1.f ;
//    self.shapeLayer1.lineCap = @"square";
//    self.shapeLayer1.lineJoin = @"bevel";
    
    //
    UIBezierPath *bezierPath1 = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.width, self.height)];
    self.shapeLayer1.path = bezierPath1.CGPath ;
    
    [self.layer addSublayer:_shapeLayer1];
    
    //shapeLayer2
    self.shapeLayer = [CAShapeLayer layer];
    self.shapeLayer.frame = CGRectMake(0, 0, self.width , self.height);
    //self.shapeLayer.position = self.center ;
    
    self.shapeLayer.fillColor = [UIColor clearColor].CGColor ;
    self.shapeLayer.strokeColor = [UIColor colorWithRed:239/255.0 green:103/255.0 blue:60/255.0 alpha:0.5].CGColor;
    self.shapeLayer.lineWidth = 5.f ;
    self.shapeLayer.strokeStart =0.f ;
    self.shapeLayer.strokeEnd = 0.f ;
//    self.shapeLayer.lineCap = @"square";
//    self.shapeLayer.lineJoin = @"bevel";
    
    //
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, self.width, self.height)];
    self.shapeLayer.path = bezierPath.CGPath ;
    
    [self.layer addSublayer:_shapeLayer];
    
    //UIlabel
    self.progressBarLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width  , self.height)];
    self.progressBarLabel.font = [UIFont systemFontOfSize:8.0];
    //self.progressBarLabel.center = self.center ;
    self.progressBarLabel.text = @"0%";
    self.progressBarLabel.textAlignment = NSTextAlignmentCenter ;
    self.progressBarLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_progressBarLabel];

}
#pragma mark -
@synthesize strokeStartValues = _strokeStartValues ;
@synthesize strokeEndValues = _strokeEndValues ;
@synthesize strokeColorValues = _strokeColorValues ;
@synthesize labelTitle  = _labelTitle ;
@synthesize labelFontSize = _labelFontSize;

- (void)setStrokeStartValues:(CGFloat)strokeStartValues
{
    if (_strokeStartValues != strokeStartValues) {
        _strokeStartValues = strokeStartValues ;
    }
    self.shapeLayer.strokeStart = strokeStartValues ;
}
- (CGFloat)strokeStartValues
{
    return _strokeStartValues ;
}

- (void)setStrokeEndValues:(CGFloat)strokeEndValues
{
    if (_strokeEndValues != strokeEndValues) {
        _strokeEndValues = strokeEndValues ;
    }
    
    self.shapeLayer.strokeEnd = _strokeEndValues ;
//    NSString *progressValue = [NSString stringWithFormat:@"%0.0f%@" , _strokeEndValues/1.0  *100 , @"%" ];
//    self.progressBarLabel.text = progressValue ;
}
- (CGFloat)strokeEndValues
{
    return _strokeEndValues ;
}


- (void)setStrokeColorValues:(UIColor *)strokeColorValues
{
    if (_strokeColorValues != strokeColorValues) {
        _strokeColorValues = strokeColorValues ;
    }
    
    self.shapeLayer.strokeColor = strokeColorValues.CGColor ;
}
- (UIColor*)strokeColorValues
{
    return _strokeColorValues ;
}

- (void)setLabelTitle:(NSString *)labelTitle
{
    if (_labelTitle != labelTitle) {
        _labelTitle = labelTitle ;
    }
    self.progressBarLabel.text = _labelTitle ;
}
- (void)setLabelFontSize:(CGFloat)labelFontSize
{
    if (_labelFontSize != labelFontSize) {
        _labelFontSize = labelFontSize ;
    }
    
    self.progressBarLabel.font = [UIFont systemFontOfSize:_labelFontSize];
}
@end
