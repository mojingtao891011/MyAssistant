//
//  BaseTableView.m
//  SmartClock
//
//  Created by taomojingato on 15/5/13.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        
        [self coustomActiom];
    }
    return self ;
}
- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    if (self = [super initWithFrame:frame style:style]) {
         [self coustomActiom];
    }
    
    return self ;
}

- (void)coustomActiom
{
    self.backgroundColor = BACKGOUNDVIEW_COLOR ;
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:view];
    
    if (self.style == UITableViewStyleGrouped) {
        self.contentInset = UIEdgeInsetsMake(-22, 0, 0, 0);
    }
    
}

@end
