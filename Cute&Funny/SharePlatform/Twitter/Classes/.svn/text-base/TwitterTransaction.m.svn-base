//
//  TwitterTransaction.m
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TwitterTransaction.h"

@implementation TwitterTransaction
@synthesize transactionKey,transactionSelector,transactionRequest;

+ (TwitterTransaction *)transactionWithKey:(NSString *)key request:(NSMutableURLRequest *)request selector:(SEL)selector{
    TwitterTransaction *transaction = [[[TwitterTransaction alloc] initWithKey:key 
                                                                      request:request
                                                                      selector:selector] autorelease];
    return transaction;
}

- (id)initWithKey:(NSString *)key request:(NSMutableURLRequest *)request selector:(SEL)selector{
    if(self = [super init]){
        self.transactionKey = key;
        self.transactionSelector = selector;
        self.transactionRequest = request;
    }
    return self;
}

- (void)dealloc{
    [transactionKey release]; transactionKey = nil;
    [transactionRequest release]; transactionRequest = nil;
    [super dealloc];
}




@end
