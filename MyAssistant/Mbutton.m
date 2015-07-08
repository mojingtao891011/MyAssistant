//
//  Mbutton.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "Mbutton.h"

@implementation Mbutton

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
@synthesize mTitleColor = _mTitleColor ;
- (void)setMFont:(UIFont *)mFont
{
    if (_mFont != mFont) {
        _mFont = mFont ;
    }
}
- (UIFont*)mFont
{
    return _mFont ;
}
- (void)setMTitleColor:(UIColor *)mTitleColor
{
    if (_mTitleColor != mTitleColor) {
        _mTitleColor = mTitleColor ;
    }
}
- (UIColor*)mTitleColor
{
    return _mTitleColor ;
}
@end
