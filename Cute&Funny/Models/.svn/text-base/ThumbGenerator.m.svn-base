//
//  ThumbGenerator.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-27.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "ThumbGenerator.h"

@implementation ThumbGenerator

AW_SINGLETON_IMPL(ThumbGenerator)

- (NSString *)createThumbnailsDir
{
    NSString* thumbnails = AWPathForCachesResource(@"Thumbnails");
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:thumbnails] ) {
        [[NSFileManager defaultManager] createDirectoryAtPath:thumbnails
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return thumbnails;
}

- (UIImage *)generateThumbnailForMedia:(Media *)aMedia forType:(NSString *)type
{
    NSString* thumbnails = [self createThumbnailsDir];
    
    if ( [aMedia.mp4Url hasPrefix:@"http://"] ) {
        NSString* thumbImageFile = [[[aMedia.mp4Url componentsSeparatedByString:@"/"] lastObject] stringByDeletingPathExtension];
        thumbImageFile = [NSString stringWithFormat:@"%@/%@_%@.png", thumbnails, type, thumbImageFile];
        
        UIImage* image = [UIImage imageWithContentsOfFile:thumbImageFile];
        if ( image ) {
            return image;
        }
        
        NSURL *fileURL = [[MediaCache sharedCache] cachedFileURLForMediaURLString:aMedia.mp4Url];
        AVAsset* asset = [AVAsset assetWithURL:fileURL];
        AVAssetImageGenerator* imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        CGImageRef cgImage = [imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil];
        image = [UIImage imageWithCGImage:cgImage];
        AW_RELEASE_CF_SAFELY(cgImage);
        
        [UIImagePNGRepresentation(image) writeToFile:thumbImageFile atomically:YES];
        
        return image;
    } else {
        // image
        
        NSString* fileName = [[aMedia.gifUrl componentsSeparatedByString:@"/"] lastObject];
        NSURL *destURL = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@_%@", thumbnails, type, fileName]];
        
        UIImage* image = [UIImage imageWithData:[NSData dataWithContentsOfURL:destURL]];
        if ( image ) {
            return image;
        }
        
        NSURL *fileURL = [[MediaCache sharedCache] cachedFileURLForMediaURLString:aMedia.gifUrl];
        
        [[NSFileManager defaultManager] copyItemAtURL:fileURL
                                                toURL:destURL
                                                error:nil];
        
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:destURL]];
    }
}

- (void)removeThumbnailForMedia:(Media *)aMedia forType:(NSString *)type
{
    NSString* filePath = nil;
    NSString* thumbnails = [self createThumbnailsDir];
    if ( [aMedia.mp4Url hasPrefix:@"http://"] ) {
        NSString* thumbImageFile = [[[aMedia.mp4Url componentsSeparatedByString:@"/"] lastObject] stringByDeletingPathExtension];
        filePath = [NSString stringWithFormat:@"%@/%@_%@.png", thumbnails, type, thumbImageFile];
    } else {
        NSString* fileName = [[aMedia.gifUrl componentsSeparatedByString:@"/"] lastObject];
        filePath = [NSString stringWithFormat:@"%@/%@_%@", thumbnails, type, fileName];
    }
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

@end
