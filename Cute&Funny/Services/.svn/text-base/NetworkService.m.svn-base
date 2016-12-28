//
//  NetworkService.m
//  Cute&Funny
//
//  Created by tangwei1 on 15-4-27.
//  Copyright (c) 2015年 tangwei1. All rights reserved.
//

#import "NetworkService.h"
#import "Defines.h"

@implementation NetworkService

+ (void)socialReqestForURI:(NSString *)uri completion:( void (^)(BOOL succeed, NSError* connectionError) )completion
{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@?version=1.0&user=%@", kDomainURL, uri, [OpenUDID value]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if ( connectionError ) {
                                   if ( completion ) {
                                       completion( NO, connectionError );
                                   }
                               } else {
                                   if ( completion ) {
                                       completion( YES, nil );
                                   }
                               }
                           }];
}

@end
