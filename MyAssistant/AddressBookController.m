//
//  ViewController.m
//  Demo
//
//  Created by Sebastián Gómez on 25/04/15.
//  Copyright (c) 2015 Sebastián Gómez. All rights reserved.
//

#import "AddressBookController.h"
#import "KTSContactsManager.h"

@interface AddressBookController () <KTSContactsManagerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *tableData;
@property (strong, nonatomic) KTSContactsManager *contactsManager;
@property (nonatomic , retain)NSMutableArray *telArr ;

@end

@implementation AddressBookController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.telArr = [NSMutableArray arrayWithCapacity:100];
    
    self.contactsManager = [KTSContactsManager sharedManager];
    self.contactsManager.delegate = self;
    self.contactsManager.sortDescriptors = @[ [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES] ];
    [self loadData];
}

#pragma mark - Action
- (void)backAction
{
    if (self.SelectedTelBlock && _telArr.count != 0) {
        self.SelectedTelBlock(_telArr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)loadData
{
    [self.contactsManager importContacts:^(NSArray *contacts)
     {
         self.tableData = contacts;
         [self.tableView reloadData];
        
     }];
}

-(void)addressBookDidChange
{
    
    [self loadData];
}

-(BOOL)filterToContact:(NSDictionary *)contact
{
    return YES;
    return ![contact[@"company"] isEqualToString:@""];
}

#pragma mark - TableView Methods

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell"];
    
    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = (UILabel *)[cell viewWithTag:1];
    NSString *firstName = contact[@"firstName"];
    nameLabel.text = [firstName stringByAppendingString:[NSString stringWithFormat:@" %@", contact[@"lastName"]]];
    
    UILabel *phoneNumber = (UILabel *)[cell viewWithTag:2];
    NSArray *phones = contact[@"phones"];
    
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        phoneNumber.text = phoneItem[@"value"];
    }
    
    UIImageView *cellIconView = (UIImageView *)[cell.contentView viewWithTag:888];
    
    UIImage *image = contact[@"image"];
    
    cellIconView.image = (image != nil) ? image : [UIImage imageNamed:@"user"];
    cellIconView.contentScaleFactor = UIViewContentModeScaleAspectFill;
    cellIconView.layer.cornerRadius = CGRectGetHeight(cellIconView.frame) / 2;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tableData count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *contact = [self.tableData objectAtIndex:indexPath.row];
    NSArray *phones = contact[@"phones"];
    if ([phones count] > 0) {
        NSDictionary *phoneItem = phones[0];
        NSString *tel = phoneItem[@"value"];
        if ([_telArr containsObject:tel]) {
            [_telArr removeObject:tel];
        }
        else{
            [_telArr addObject:tel];
        }
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:3];
      imageView.highlighted = !imageView.highlighted ;
}
@end
