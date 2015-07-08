//
//  BaseViewController.h
//  SmartClock
//
//  Created by taomojingato on 15/5/6.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>


@class BaseNavgationController;

@interface BaseController : UIViewController

- (id)fetchViewControllerByIdentifier:(NSString*)Identifier;

@end
