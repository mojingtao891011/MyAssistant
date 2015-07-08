//
//  BaseViewController.m
//  SmartClock
//
//  Created by taomojingato on 15/5/6.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"
#import "UIView+firstResponder.h"
#import "BaseNavgationController.h"

@interface BaseController ()

@end

@implementation BaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self customBackAction];
    
    
    
    //[[UIApplication sharedApplication] setStatusBarStyle: UIStatusBarStyleLightContent  ];
    
    
    //监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //监听键盘隐藏事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.view.backgroundColor = BACKGOUNDVIEW_COLOR;

}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


#pragma mark - 键盘即将弹出事件处理

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *keyBoardInfo = notification.userInfo;
    UIView *firstResponder = [self.view firstResponder];
    if(firstResponder){
        CGRect frame = firstResponder.frame;
        CGFloat viewY  ;
        if(firstResponder.superview != self.view){
            frame = [firstResponder convertRect:frame toView:self.view];
            viewY = CGRectGetMaxY(frame) - CGRectGetMaxY(firstResponder.frame) + CGRectGetHeight(firstResponder.superview.frame);
        }
        else{
            viewY = CGRectGetMaxY(frame) - CGRectGetMaxY(firstResponder.frame) ;
        }
        
        CGFloat keyBoardY = [keyBoardInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue].origin.y;
        CGFloat delta = keyBoardY - viewY ;
        if(delta < 0){
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformMakeTranslation(0, delta);
            } completion:nil];
        }
    }
}

#pragma mark - 键盘即将隐藏事件
- (void)keyboardWillHide:(NSNotification *)notification
{
    [UIView animateWithDuration:0.5 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
    } completion:nil];
}

#pragma mark- private-fun

//返回按钮
- (void)customBackAction
{
    if (self.navigationController.viewControllers.count > 1 ) {
    
        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backButton setFrame:CGRectMake(0, 0, 50, 44)];
        backButton.backgroundColor = [UIColor clearColor];
        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        UIEdgeInsets edgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        backButton.imageEdgeInsets = edgeInsets;
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barBrttonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        self.navigationItem.leftBarButtonItem = barBrttonItem ;
    }

}

- (id)fetchViewControllerByIdentifier:(NSString*)Identifier
{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    id viewCtl = [mainStoryboard instantiateViewControllerWithIdentifier:Identifier];
    
    return viewCtl ;
}

#pragma mark - UI Action

//返回事件
- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
