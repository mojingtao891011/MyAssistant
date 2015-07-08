//
//  SetTagController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/23.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableController.h"


typedef enum
{
    OrdinaryType = 0,               //一般
    UrgentType =1,                         //紧急
    ImportantType = 2,                  //重要
    VeryUrgentType = 3,                //非常紧急
    
}TaskTagType;

@protocol SetTagControllerDelegate <NSObject>

- (void)setTaskTag:(TaskTagType)taskTagType ;

@end

@interface SetTagController : BaseTableController

@property (nonatomic , assign)TaskTagType           curTaskTagType ;
@property (nonatomic , assign)id<SetTagControllerDelegate> setTagControllerDelegate ;
@property (nonatomic ,copy)void(^selectedTaskTagBlock)(NSInteger taskTag ) ;

@end
