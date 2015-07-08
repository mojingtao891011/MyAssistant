//
//  BaseTableController.h
//  MyAssistant
//
//  Created by taomojingato on 15/6/26.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableController : UITableViewController

@property (nonatomic , copy)NSString *leftButtonImageName;
@property (nonatomic , copy)NSString *rightButtonImageName;
@property (nonatomic , assign)BOOL      isHidenRightButton ;
@property (nonatomic , assign)BOOL      isHidenLeftButton ;

- (void)leftAction ;
- (void)rightAction;

- (id)fetchViewControllerByIdentifier:(NSString*)Identifier;

@end
