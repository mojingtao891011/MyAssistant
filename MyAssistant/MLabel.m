//
//  MLabel.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "MLabel.h"

@implementation MLabel

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        
    }
    return self ;
}
- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
       
    }
    return self ;
}
@synthesize mFont = _mFont ;
@synthesize mTextColor = _mTextColor ;

- (void)setMFont:(UIFont *)mFont
{
    if (_mFont != mFont) {
        _mFont = mFont ;
    }
    self.font = mFont ;
}
- (UIFont*)mFont
{
    return _mFont ;
}
- (void)setMTextColor:(UIColor *)mTextColor
{
    if (_mTextColor != mTextColor ) {
        _mTextColor = mTextColor ;
    }
    
    self.textColor = _mTextColor ;
}
- (UIColor*)mTextColor
{
    return _mTextColor ;
}
@end
