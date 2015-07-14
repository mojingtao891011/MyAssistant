//
//  FriendListController.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/13.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseController.h"

@interface FriendListController : BaseController

@property (nonatomic , assign)BOOL isExecutor ;
@property (nonatomic , retain)NSMutableArray        *colletionDataSources ;
@property (nonatomic , copy)void(^selectedFriendBlock)(NSMutableArray  *arr);

@end
