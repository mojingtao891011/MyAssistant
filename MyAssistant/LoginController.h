//
//  LoginController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@interface LoginController : BaseController

@property (nonatomic , copy)void(^loginControllerBlock)(BOOL isLoginSucceed);

@end
