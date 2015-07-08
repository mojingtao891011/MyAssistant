//
//  UIImage+Stretch.m
//  MyNotes
//
//  Created by 莫景涛 on 15/4/9.
//  Copyright (c) 2015年 莫景涛. All rights reserved.
//

#import "UIImage+Stretch.h"

@implementation UIImage (Stretch)
+ (UIImage*)stretchImage:(UIImage*)oldImg
{
    /*
     *   方法一
     *   1.这个方法在iOS 5.0出来后就过期了
     *   2.这个方法只能拉伸1x1的区域
     */
    // 左端盖宽度
    NSInteger leftCapWidth = oldImg.size.width * 0.5f;
    // 顶端盖高度
    NSInteger topCapHeight =oldImg.size.height * 0.5f;
    // 重新赋值
    UIImage *newImg = [oldImg stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];

    return newImg ;
}
@end
