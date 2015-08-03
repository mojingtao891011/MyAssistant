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


@interface AppDelegate ()<UIAlertViewDelegate>

@property (nonatomic , retain)NSManagedObjectContext          *context ;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   
    self.window.backgroundColor = [UIColor whiteColor];
    
    [self.window makeKeyAndVisible];
    
    self.context = [CoreDataStack shareManaged].managedObjectContext ;
    
    
    [self autoLogin];
    
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
        
        NSArray *names = @[@"alin",@"abya",@"alin",@"BB",@"里湖",@"怕虎",@"roskin",@"niuniu"];
        NSArray *imgs = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg",@"7.jpg",@"3.jpg"];
        NSMutableArray *friends = [NSMutableArray arrayWithCapacity:10];
        for (int i = 0; i < names.count; i++) {
            NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
            User *user = [[User alloc]initWithEntity:entity insertIntoManagedObjectContext:[CoreDataStack shareManaged].managedObjectContext];
            
            user.userName = names[i] ;
            user.userMobile = @"18682470426";
            user.userMail = @"mojt@lierda.com";
            
            UIImage *images = [UIImage imageNamed:imgs[i ]];
            user.userImg = UIImageJPEGRepresentation(images, 0.2);
            [friends addObject:user];
        }
        user.friends = [NSSet setWithArray:friends];
        
        [[CoreDataStack shareManaged].managedObjectContext save:nil];
        
    }

}
- (void)autoLogin
{
    
    if (!USER_ID ||!USER_PWD) {
        return ;
    }
    
    // 初始化請求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"http://qztank.gicp.net:8800/bosman/main.php"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60.0];
    NSDictionary *parmDict =@ {@"publickey":PUBLICKEY,@"command":@"102",@"mobile":USER_ID,@"passwd":USER_PWD};
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:parmDict options:NSJSONWritingPrettyPrinted error:nil]];
    // 发送同步请求
    NSError *error = nil ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request
                                         returningResponse:nil error:&error];
    if (error ) {
        return ;
    }
    else{
        NSError *error = nil ;
        id json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (!error) {
            
            if ([json isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary*)json ;
                if ([dict[@"result"] integerValue]== 0 ) {
                    //保存私有key
                    [[NSUserDefaults standardUserDefaults]setObject:dict[@"privatekey"] forKey:@"privatekey"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    
                    //
                    UIStoryboard *storuboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    UIViewController *tabBarCtl = [storuboard instantiateViewControllerWithIdentifier:@"TabBarCtl"];
                    self.window.rootViewController = tabBarCtl ;
                }
            }
        }
    }
    

}
- (void)sendBeatHead
{
    
}
@end
