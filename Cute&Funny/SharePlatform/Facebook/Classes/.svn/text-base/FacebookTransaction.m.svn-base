//
//  FacebookTransaction.m
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FacebookTransaction.h"

@implementation FacebookTransaction
@synthesize transactionKey,transactionSelector,transactionRequest;

+ (FacebookTransaction *)transactionWithKey:(NSString *)key request:(NSMutableURLRequest *)request selector:(SEL)selector{
    FacebookTransaction *transaction = [[[FacebookTransaction alloc] initWithKey:key 
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
