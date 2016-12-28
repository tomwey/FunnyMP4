//
//  SaveCommand.m
//  iFunnyGif
//
//  Created by tangwei1 on 14-7-29.
//  Copyright (c) 2014年 tangwei1. All rights reserved.
//

#import "SaveCommand.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MediaCache.h"
#import "Media.h"
#import "MBProgressHUD.h"
#import "ModalAlert.h"
#import "Toast.h"
#import "UIImageView+AFNetworking.h"

@implementation SaveCommand

- (void)execute
{
    Media* aMedia = (Media *)[self.userData objectForKey:kUserDataEntityKey];
    
    if ( [aMedia.mp4Url rangeOfString:@"http://"].location != NSNotFound ) {
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [MBProgressHUD showHUDAddedTo:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
        [library writeVideoAtPathToSavedPhotosAlbum:[[MediaCache sharedCache] cachedFileURLForMediaURLString:aMedia.mp4Url]
                                    completionBlock:^(NSURL     *assetURL, NSError *error) {
//                                        NSLog(@"error:%@",error);
                                        dispatch_async(dispatch_get_main_queue(), ^{
                                            [MBProgressHUD hideHUDForView:[[[UIApplication sharedApplication] windows] objectAtIndex:0] animated:YES];
                                            if ( error ) {
                                                [ModalAlert say:@"No Privacy Saved."];
                                                
                                            } else {
                                                if ( [self.userData objectForKey:@"success"] ) {
                                                    //                     [Toast showText:];
                                                    [ModalAlert say:[self.userData objectForKey:@"success"] message:@""];
                                                } else {
                                                    [Toast showText:@"Gif saved"];
                                                }
                                            }
                                        });
                                        
                                    }];
        [library release];
    } else {
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:aMedia.gifUrl]];
        UIImage* image = [UIImage imageWithData:[[MediaCache sharedCache] cachedDataForRequest:request]];
        
        if ( image ) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
        } else {
            [Toast showText:@"Image not Found"];
        }
        
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if ( error ) {
        [ModalAlert say:@"No Privacy Saved."];
    } else {
        [Toast showText:@"Gif saved"];
    }
}

- (void)dealloc
{
    self.media = nil;
    [super dealloc];
}

@end
