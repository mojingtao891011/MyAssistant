//
//  Example8ViewController.m
//  ZLAssetsPickerDemo
//
//  Created by 张磊 on 15/5/28.
//  Copyright (c) 2015年 com.zixue101.www. All rights reserved.
//

#import "PhtotoController.h"
#import "ZLPhoto.h"
#import "PhotoCell.h"
#import "Annex.h"

@interface PhtotoController () <ZLPhotoPickerViewControllerDelegate,UITableViewDataSource,UITableViewDelegate,ZLPhotoPickerBrowserViewControllerDataSource,ZLPhotoPickerBrowserViewControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate , NSFetchedResultsControllerDelegate>

@property (weak,nonatomic) UITableView *tableView;

@property (nonatomic ,retain)NSFetchedResultsController         *fetchedResultsController ;
@property (nonatomic , retain)NSManagedObjectContext        *context ;

@end

@implementation PhtotoController

#pragma mark Get View
- (UITableView *)tableView{
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor whiteColor];
        tableView.dataSource = self;
        tableView.delegate = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
        [tableView registerNib:[UINib nibWithNibName:@"PhotoCell" bundle:nil] forCellReuseIdentifier:@"cell"];
        
        tableView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSString *vfl = @"V:|-0-[tableView]-20-|";
        NSDictionary *views = NSDictionaryOfVariableBindings(tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl options:0 metrics:nil views:views]];
        NSString *vfl2 = @"H:|-0-[tableView]-0-|";
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vfl2 options:0 metrics:nil views:views]];
    }
    return _tableView;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
    //self.view.backgroundColor = [UIColor whiteColor];
    
    // 初始化RightBarButtonItem
    if (!_isHideRight) {
        [self setupButtons];
    }
    
    
    [self tableView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.annexUploadCountBlock) {
        self.annexUploadCountBlock([self.tableView numberOfRowsInSection:0]);
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self scrollViewToBottom];
}
- (void) setupButtons{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择照片" style:UIBarButtonItemStyleDone target:self action:@selector(selectPhotos)];
}

#pragma mark - 选择相册
- (void)selectPhotos {
    // 创建控制器
    ZLPhotoPickerViewController *pickerVc = [[ZLPhotoPickerViewController alloc] init];
    // 默认显示相册里面的内容SavePhotos
    // 最多能选9张图片
    pickerVc.topShowPhotoPicker = YES;
    pickerVc.minCount = 20;
    pickerVc.status = PickerViewShowStatusCameraRoll;
    pickerVc.delegate = self;
    [pickerVc show];
    /**
     *
     传值可以用代理，或者用block来接收，以下是block的传值
     __weak typeof(self) weakSelf = self;
     pickerVc.callBack = ^(NSArray *assets){
     weakSelf.assets = assets;
     [weakSelf.tableView reloadData];
     };
     */
}
#pragma mark - 保存相片到CoreData
- (void)saveImgage:(NSArray*)assets
{
    
    
    for (id asset in assets) {
       // ZLPhotoAssets *
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Annex" inManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
        Annex *annexImage = [[Annex alloc]initWithEntity:entity insertIntoManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
        annexImage.annexType = [NSNumber numberWithInt:1] ;//1代表图片
        
        if ([asset isKindOfClass:[ZLPhotoAssets class]]) {
            
            ZLPhotoAssets *photoAsset = (ZLPhotoAssets*)asset ;
            annexImage.annexOriginImage = photoAsset.originImage ;
            annexImage.annexThumbImage = photoAsset.thumbImage ;
        }
        else if ([asset isKindOfClass:[UIImage class]]){
            annexImage.annexOriginImage = asset ;
        }
        
        if (_taskModel) {
            annexImage.task = _taskModel ;
        }
        if (_scheduleModel) {
            annexImage.schedule = _scheduleModel ;
        }
        annexImage.annexUploadTime = [NSDate date];
        
        if (![[CoreDataStack shareManaged].managedObjectContext save:nil]) {
            debugLog(@"save photo fail");
        }
        
    }
}

#pragma mark - 相册回调
- (void)pickerViewControllerDoneAsstes:(NSArray *)assets{
    
   
    [self saveImgage:assets];
    
     //[self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count ;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"cell";
    PhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    [self configurePhotoCell:cell indexPath:indexPath];

    return cell;
}
- (void)configurePhotoCell:(PhotoCell*)cell indexPath:(NSIndexPath*)indexPath
{
    Annex *annex = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.imageview1.image = annex.annexOriginImage;

}
- (void)scrollViewToBottom
{
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][0];
    if ([sectionInfo numberOfObjects]!= 0) {
        
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[sectionInfo numberOfObjects] - 1 inSection:0 ] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
}
#pragma mark - <UITableViewDelegate>
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 点击cell 放大缩小图片
    PhotoCell *cell = (PhotoCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self setupPhotoBrowser:cell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 95;
}

#pragma mark - setupCell click ZLPhotoPickerBrowserViewController
- (void) setupPhotoBrowser:(PhotoCell *) cell{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // 图片游览器
    ZLPhotoPickerBrowserViewController *pickerBrowser = [[ZLPhotoPickerBrowserViewController alloc] init];
    // 动画方式
     pickerBrowser.status = UIViewAnimationAnimationStatusZoom;
    // 数据源/delegate
    pickerBrowser.delegate = self;
    pickerBrowser.dataSource = self;
    // 是否可以删除照片
    pickerBrowser.editing = YES;

    // 当前选中的值
    pickerBrowser.currentIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    // 展示控制器
    //    [pickerBrowser show];
    [self presentViewController:pickerBrowser animated:NO completion:nil];
}

#pragma mark - <ZLPhotoPickerBrowserViewControllerDataSource>
- (NSInteger)numberOfSectionInPhotosInPickerBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser{
    return 1;
}

- (NSInteger)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser numberOfItemsInSection:(NSUInteger)section{
    
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
    //return self.assets.count;
}

#pragma mark - 点击Cell通知拍照代理
- (void)pickerCollectionViewSelectCamera:(ZLPhotoPickerViewController *)pickerVc{
    UIImagePickerController *ctrl = [[UIImagePickerController alloc] init];
    ctrl.delegate = self;
    ctrl.sourceType = UIImagePickerControllerSourceTypeCamera;
    [pickerVc presentViewController:ctrl animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // 处理
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
//        [self.assets addObject:image];
//        [self.tableView reloadData];
        [self saveImgage:@[image]];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else{
        NSLog(@"请在真机使用!");
    }
}

#pragma mark - 每个组展示什么图片,需要包装下ZLPhotoPickerBrowserPhoto
- (ZLPhotoPickerBrowserPhoto *) photoBrowser:(ZLPhotoPickerBrowserViewController *)pickerBrowser photoAtIndexPath:(NSIndexPath *)indexPath{
    
    
    Annex *annex = [self.fetchedResultsController objectAtIndexPath:indexPath];
    // 包装下imageObj 成 ZLPhotoPickerBrowserPhoto 传给数据源
    ZLPhotoPickerBrowserPhoto *photo = [ZLPhotoPickerBrowserPhoto photoAnyImageObjWith:annex.annexOriginImage];
    PhotoCell *cell = (PhotoCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    // 缩略图
    photo.toView = cell.imageview1;
    photo.thumbImage = cell.imageview1.image;
    return photo;
    
    }

#pragma mark - <ZLPhotoPickerBrowserViewControllerDelegate>
#pragma mark 删除调用
- (void)photoBrowser:(ZLPhotoPickerBrowserViewController *)photoBrowser removePhotoAtIndexPath:(NSIndexPath *)indexPath{
    // 删除照片时调用
    id<NSFetchedResultsSectionInfo>sectionInfo = [self.fetchedResultsController sections][indexPath.section];
    if (indexPath.row > [sectionInfo numberOfObjects]) return;
    Annex *annex = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.context deleteObject:annex];
    
    if (![self.context save:nil]) {
        NSLog(@"dalete annex fail");
    }
    
//    [self.assets removeObjectAtIndex:indexPath.row];
//    [self.tableView reloadData];
}
#pragma mark - NSFetchedResultsControllerDelegate
- (NSFetchedResultsController*)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController ;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Annex"];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"annexUploadTime" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSPredicate  *predicate =nil ;
    if (_taskModel) {
        predicate = [NSPredicate predicateWithFormat:@"task.taskName = %@" , _taskModel.taskName];
    }
    else if (_scheduleModel){
        predicate = [NSPredicate predicateWithFormat:@"schedule.scheduleName = %@" , _scheduleModel.scheduleName];
    }
    [fetchRequest setPredicate:predicate];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:nil cacheName:nil];
    aFetchedResultsController.delegate = self ;
    self.fetchedResultsController = aFetchedResultsController ;
    
    NSError *error = nil ;
    if (![_fetchedResultsController performFetch:&error]) {
        NSLog(@"NSFetchedResultsController alloc fail");
        abort();
    }

    return _fetchedResultsController ;
}
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}
- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            
            break;
        case NSFetchedResultsChangeUpdate:
            
            break;
            
        default:
            break;
    }
    
}
- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            [self.tableView deleteRowsAtIndexPaths:@[newIndexPath] withRowAnimation: UITableViewRowAnimationAutomatic];
            break;
        case NSFetchedResultsChangeUpdate:
        {
            PhotoCell *cell = (PhotoCell*)[self.tableView cellForRowAtIndexPath:indexPath];
            [self configurePhotoCell:cell indexPath:indexPath];
        }
            break;
            
        default:
            break;
    }
    
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
    [self scrollViewToBottom];
}

@end
