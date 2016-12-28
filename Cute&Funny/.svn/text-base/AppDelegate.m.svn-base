//
//  AppDelegate.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-16.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "AppDelegate.h"
#import "Defines.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];
    
    [InMobi initialize:@"c5db50e7ee8b4ee19de957a3e1462ce0"];
    
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
//    AW_LOG(@"%@", [UIFont familyNames]);
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    HomeViewController* hvc = [[[HomeViewController alloc] init] autorelease];
//    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:hvc] autorelease];
    
//    if ( AWOSVersionIsLower(7.0) ) {
//        [[UINavigationBar appearance] setTintColor:RGB(225, 15, 52)];
//    } else {
//        [[UINavigationBar appearance] setBarTintColor:RGB(225, 15, 52)];
//    }
    
//    nav.navigationBarHidden = YES;
    
    self.window.rootViewController = hvc;
    
    [self.window makeKeyAndVisible];
    
    isLoad = NO;
    
    [[AdsPopupManager sharedManager] setViewController:self.window.rootViewController];
    [[AdsPopupManager sharedManager] preloadAllAds];
    
    [[AdsPopupManager sharedManager] setDelegate:self];
    
    [[AdsPopupManager sharedManager] showNewsBlast];
    
    
    [Flurry startSession:FLURRY_KEY];
    
    [[AnalyticsTool sharedTool] StartSessionWithSentFile:YES];
    
    if ( [[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)] ) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    if ( launchOptions != nil ) {
        NSDictionary* userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self handleNotiMessage:userInfo];
    }
    
    application.applicationIconBadgeNumber = 0;
    
    AW_LOG(@"%@,\n%@",[UIFont familyNames],[UIFont fontNamesForFamilyName:@"Abadi MT Condensed Extra Bold"]);
    
    return YES;
}

- (void)bannerAdDidLoad
{
    if ( !isLoad ) {
        isLoad = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"bannerAdDidLoad" object:nil];
    }
}

#pragma mark - UIApplicationDelegate Methods

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)dToken
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasRegistered"];
    
    NSString *token = [NSString stringWithFormat:@"%@",dToken];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if([token length] > 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"deviceToken"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //        NSString *bundleID = [[NSBundle mainBundle] bundleIdentifier];
        NSString *url = [NSString stringWithFormat:@"http://laugh-origin.sniperstudio.com/pocket/funny1/register?token=%@", token];
        //        NSString *url = [NSString stringWithFormat:@"http://services.%@.com/push_gateway/register?token=%@&app=%@",[[bundleID componentsSeparatedByString:@"."] objectAtIndex:1],token,[[bundleID componentsSeparatedByString:@"."] lastObject]];
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if ( connectionError ) {
                                       NSLog(@"send token error: %@", connectionError);
                                   } else {
                                       NSLog(@"send token success");
                                   }
                               }];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self handleNotiMessage:userInfo];
}

- (void)handleNotiMessage:(NSDictionary *)userInfo
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[[userInfo objectForKey:@"badge"] integerValue]];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"hasRegistered"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kHasRegisteredFailureNotification" object:nil];
    
    NSLog(@"Error in registration. Error: %@", err);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    application.applicationIconBadgeNumber = 0;
    
//    [[AdsPopupManager sharedManager] showInterstitial];
    
//    [ORMObject establishDBConnection:@"data.sqlite"];
    
    application.applicationIconBadgeNumber = 0;
    
    NSString* deviceToken = !![[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"] : @"";
    NSString *url = [NSString stringWithFormat:@"http://laugh-origin.sniperstudio.com/pocket/funny1/register?token=%@", deviceToken];
    //[NSString stringWithFormat:@"http://services.%@.com/push_gateway/register?token=%@&app=%@",[[bundleID componentsSeparatedByString:@"."] objectAtIndex:1],token,[[bundleID componentsSeparatedByString:@"."] lastObject]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ( connectionError ) {
                                   NSLog(@"send token error: %@", connectionError);
                               } else {
                                   NSLog(@"send token success");
                               }
                           }];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
