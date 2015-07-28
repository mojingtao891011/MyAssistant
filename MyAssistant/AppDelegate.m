//
//  AppDelegate.m
//  MyAssistant
//
//  Created by taomojingato on 15/6/18.
//  Copyright (c) 2015年 mojingato. All rights reserved.
//

#import "AppDelegate.h"
#import "CoreDataStack.h"
#import "User.h"
#import "CoreDataModelService.h"
#import "Task.h"
#import "Schedule.h"
#import "SVProgressHUD.h"
#import "Friends.h"


@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic , retain)NSManagedObjectContext          *context ;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    [self creatUserTest];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[CoreDataStack shareManaged] saveContext];
}
#pragma mark -
- (void)creatUserTest
{
    
    [[NSUserDefaults standardUserDefaults]setObject:[UIDevice currentDevice].name forKey:@"deviceName"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    User *user = [CoreDataModelService fetchUserByName:[UIDevice currentDevice].name];
    if (user) {
        return ;
    }
    
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    
    NSError *error = nil ;
    NSArray *results = [[CoreDataStack shareManaged].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results.count == 0) {
        
        //创建默认任务
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
        User *user = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
       
        user.userName = [UIDevice currentDevice].name ;
        user.userMobile = @"18682470426";
        user.userMail = @"mojt@lierda.com";
        
        [[CoreDataStack shareManaged].managedObjectContext save:nil];
        
        [self creatUserFriends];
        
    }

}
- (void)creatUserFriends
{
    NSEntityDescription *entity = [NSEntityDescription insertNewObjectForEntityForName:@"Friends" inManagedObjectContext:self.context];
    Friends *friendModel = [[Friends alloc]initWithEntity:entity insertIntoManagedObjectContext:self.context];
    
  
    UIImage *friendImage = [UIImage imageNamed:@"datouxiang"];
    friendModel.image = UIImagePNGRepresentation(friendImage);
    friendModel.nick = @"rick";
    friendModel.sex = [NSNumber numberWithInteger:1];
    friendModel.account = @"10086";
    friendModel.address = @"深圳市南山区";
    friendModel.curScheduleCount = [NSNumber numberWithInteger:12];
    friendModel.curCompleteScheduleCount = [NSNumber numberWithInteger:4];
    friendModel.curTaskCount = [NSNumber numberWithInteger:15];
    friendModel.curCompleteTaskCount = [NSNumber numberWithInteger:5];
    
    if ([self.context save:nil]) {
        NSLog(@"add friends ok");
    }
    
}
@end
