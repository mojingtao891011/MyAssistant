//
//  ExecutorController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/21.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@class User , Task;


@interface ExecutorController : BaseController


@property (nonatomic , retain)User      *executorUser ;
@property (nonatomic , retain)NSMutableArray        *follows ;

@property (nonatomic , copy)void(^selectExecutorBlock)(User*user) ;
@property (nonatomic , copy)void(^selectFollowersBlock)(NSMutableArray* followers);

@end
