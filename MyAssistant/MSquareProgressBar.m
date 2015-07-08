//
//  MSquareProgressBar.m
//  JindutiaoDemo
//
//  Created by taomojingato on 15/7/8.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MSquareProgressBar.h"


@interface MSquareProgressBar ()

@property (nonatomic ,retain)CALayer        *MLayer;
@property (nonatomic ,retain)UILabel           *MLabel;

@end

@implementation MSquareProgressBar
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:217/255.0 green:223/255.0 blue:229/255.0 alpha:1];
        self.layer.cornerRadius = 1.0;
        self.clipsToBounds = YES ;
        [self _initDefaultUI];
    }
    return self ;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor colorWithRed:217/255.0 green:223/255.0 blue:229/255.0 alpha:1];
        self.layer.cornerRadius = 1.0;
        self.clipsToBounds = YES ;
        [self _initDefaultUI];
    }
    return self ;
}
- (void)_initDefaultUI
{
   
    //1
    self.MLayer = [CALayer layer];
    self.MLayer.frame = CGRectMake(0, 0, 50, self.height);
    self.MLayer.backgroundColor = [UIColor colorWithRed:239/255.0 green:103/255.0 blue:60/255.0 alpha:0.5].CGColor ;
    [self.layer addSublayer:self.MLayer];
    
    
    //2
    CGFloat Mlayer_w = self.MLayer.frame.size.width ;
    CGFloat Mlabel_x = 0 ;
    if ( Mlayer_w < 30) {
        Mlabel_x = Mlayer_w ;
    }
    else{
        Mlabel_x = Mlayer_w - 30 ;
    }
    
    self.MLabel = [[UILabel alloc]initWithFrame:CGRectMake(Mlabel_x, 0, 30, self.height)];
    self.MLabel.textColor = [UIColor blackColor];
    self.MLabel.font = [UIFont systemFontOfSize:10.0];
    self.MLabel.text = @"0%";
    [self addSubview:self.MLabel];
    
    if (Mlayer_w < 30) {
        self.MLabel.textAlignment = NSTextAlignmentLeft ;
    }
    else{
        self.MLabel.textAlignment = NSTextAlignmentRight ;
    }
    
}
#pragma mark - 用户自定义
@synthesize progressValue = _progressValue ;

- (void)setProgressValue:(CGFloat)progressValue
{
    if (_progressValue != progressValue) {
        _progressValue = progressValue ;
    }
    
    if (_progressValue > self.width) {
        _progressValue = self.width ;
    }
    else if(_progressValue < 0){
        _progressValue = 0.0 ;
    }
    //1
    self.MLayer.frame = CGRectMake(0, 0, _progressValue, self.height);
    
    //2
    CGFloat Mlayer_w = self.MLayer.frame.size.width ;
    CGFloat Mlabel_x = 0 ;
    if ( Mlayer_w < 30) {
        Mlabel_x = Mlayer_w ;
    }
    else{
        Mlabel_x = Mlayer_w - 30 ;
    }
    
    if (Mlayer_w < 30) {
        self.MLabel.textAlignment = NSTextAlignmentLeft ;
    }
    else{
        self.MLabel.textAlignment = NSTextAlignmentRight ;
    }

    self.MLabel.frame =CGRectMake(Mlabel_x, 0, 30, self.height);
    self.MLabel.text = [NSString stringWithFormat:@"%0.0f%@",Mlayer_w/self.width *100 , @"%"] ;
    
}

@end
