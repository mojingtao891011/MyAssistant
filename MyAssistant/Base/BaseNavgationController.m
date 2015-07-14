//
//  BaseNavgationViewController.m
//  SmartClock
//
//  Created by taomojingato on 15/5/6.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseNavgationController.h"

@interface BaseNavgationController ()

@end

@implementation BaseNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setBarTintColor:NAVIGATIONBAR_COLOR];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    
    
    
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     GREY_FONT_COLOR, NSForegroundColorAttributeName,
                                                                     nil]];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

//自定义导航栏图片
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
#pragma mark - private fun

@end
