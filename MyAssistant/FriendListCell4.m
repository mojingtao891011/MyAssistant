//
//  FriendListCell4.m
//  MyAssistant
//
//  Created by taomojingato on 15/7/29.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "FriendListCell4.h"
#import "FriendListCell3.h"
#import "User.h"

@interface FriendListCell4 ()<UICollectionViewDataSource , UICollectionViewDelegate  >

@end

@implementation FriendListCell4

- (void)awakeFromNib {
   
    [self _initCollectionView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - UI
- (void)_initCollectionView
{
    self.collectionView.delegate = self ;
    self.collectionView.dataSource = self ;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshCollectionView:) name:NOTE_REFRESH_COLLECTIONVIEW object:nil];
    });
}
- (void)refreshCollectionView:(NSNotification*)note
{
    self.colletionDataSources = [note object];
    dispatch_async(dispatch_get_main_queue(), ^{
         [self.collectionView reloadData];
        
        if (self.colletionDataSources.count > 3) {

            
            [self.collectionView scrollRectToVisible:CGRectMake(SCREEN_WIDTH - 250, self.collectionView.top, self.collectionView.width, self.collectionView.height) animated:YES];
        }
        
    });
   
}
#pragma mark -UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1 ;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _colletionDataSources.count + 1 ;
}
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _colletionDataSources.count ) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell2" forIndexPath:indexPath];
        return cell ;
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell1" forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView*)[cell viewWithTag:1];
    imageView.layer.cornerRadius = imageView.width / 2.0 ;
    imageView.clipsToBounds = YES ;
    User *friendModel = self.colletionDataSources[indexPath.row];
    imageView.image = [UIImage imageWithData:friendModel.userImg];
    return cell ;
}
#pragma mark -UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _colletionDataSources.count) {
        return CGSizeMake(200, 50);
    }
    return CGSizeMake(40, 40);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(1, 10, 1, 1);
}

@end
