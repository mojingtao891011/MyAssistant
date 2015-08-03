//
//  RegisterController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/22.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@interface RegisterController : BaseController

@property (nonatomic , assign)BOOL isForgetBttonPushSegue;
@property (nonatomic , copy)void(^moblieBlock)(NSString *moblie);

@end
