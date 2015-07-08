//
//  TaskDetailNameCellFrame.h
//  MyAssistant
//
//  Created by taomojingato on 15/7/1.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"


@interface MessageFrame : NSObject

@property (nonatomic , assign)CGFloat                describeHeight ;
@property (nonatomic , retain)NSMutableArray            *commentHeightArr ;

@property (nonatomic , retain)Task                        *task ;



@end
