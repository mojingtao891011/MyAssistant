//
//  ViewController.h
//  Demo
//
//  Created by Sebastián Gómez on 25/04/15.
//  Copyright (c) 2015 Sebastián Gómez. All rights reserved.
//

#import "BaseController.h"

@interface AddressBookController : BaseController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic , copy)void(^SelectedTelBlock)(NSMutableArray *telArr);

@end

