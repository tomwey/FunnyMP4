//
//  Twitter.m
//
//  Created by yanglei on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Twitter.h"
#import "SRHttpFetcher.h"
#import "TwitterTransaction.h"

@interface Twitter(PrivateMethods)

/*弹出顶端事务*/
- (void)popTransaction;

/*废弃顶端事务*/
- (void)deprecatedTopTransaction;

/*立刻执行事务*/
- (void)commitTransaction:(TwitterTransaction *)transaction;

@end

static Twitter  *twitter = nil;

@implementation Twitter
@synthesize delegate;
@synthesize apiTransactions;

#pragma mark - Category Methods
/*单例对象初始化*/
+(Twitter *)sharedTwitter
{	
	if (twitter) 
	{
		return twitter;
	}
	
	@synchronized([Twitter class])
	{
        twitter = [[Twitter alloc] init];
	}
	return twitter;
}

/*单例对象释放*/
+ (void)releaseTwitter
{
    [twitter release];
    twitter = nil;
}

/*删除过时授权数据*/
+ (void)removeAuthorizedCacheInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TW_AccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TW_AccessSecret];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:TW_AccountProfile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*检查是否存在授权数据*/
+ (BOOL)checkAuthorizedCacheInfo{
    return[[NSUserDefaults standardUserDefaults] objectForKey:TW_AccountProfile]?YES:NO;
}

#pragma mark - Object Methods
- (id)init{
    if(self = [super init]){
        self.apiTransactions = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc{
    [apiTransactions release]; apiTransactions = nil;
    [super dealloc];
}
#pragma mark - Private Methods

/*弹出顶端事务*/
- (void)popTransaction{
    if([self.apiTransactions count] > 0){
        TwitterTransaction *transaction = [self.apiTransactions objectAtIndex:0];
        [SRHttpFetcher beginFetchWithRequest:transaction.transactionRequest
                                      object:transaction 
                                    delegate:twitter];
        [self.apiTransactions removeObjectAtIndex:0];
    }
}

/*废弃顶端事务*/
- (void)deprecatedTopTransaction{
    if([self.apiTransactions count] > 0)
        [self.apiTransactions removeObjectAtIndex:0];
}

/*立刻执行事务*/
- (void)commitTransaction:(TwitterTransaction *)transaction{
    [SRHttpFetcher beginFetchWithRequest:transaction.transactionRequest
                                  object:transaction 
                                delegate:twitter];
}



#pragma mark - SRHttpFetcherDelegate Delegate
- (void)requestSuccessWithData:(NSData *)data object:(NSObject *)object{
    TwitterTransaction *transaction = (TwitterTransaction *)object;
    if(!transaction.transactionSelector)
        [self popTransaction];
    else 
        [self performSelector:transaction.transactionSelector withObject:data];
         
    if(self.delegate && [self.delegate respondsToSelector:@selector(twTransactionSuccessWithKey:data:)])
        [self.delegate twTransactionSuccessWithKey:transaction.transactionKey data:data];
}

- (void)requestFaildWithError:(NSError *)error object:(NSObject *)object{    
    TwitterTransaction *transaction = (TwitterTransaction *)object;
    if(self.delegate && [self.delegate respondsToSelector:@selector(twTransactionFailedWithKey:error:)])
        [self.delegate twTransactionFailedWithKey:transaction.transactionKey error:error];
}

#pragma mark - #########API Achieve#########
/*分享文字*/
- (void)beginShareMessage:(NSString *)message{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[TwitterTransaction transactionWithKey:TW_CallBack_ShareMessage request:[TwitterAPI createShareMsgRequestWithMessage:message] selector:nil]];
    [self popTransaction];
    
}

/*分享文字和图片*/
- (void)beginShareMessage:(NSString *)message image:(UIImage *)image{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[TwitterTransaction transactionWithKey:TW_CallBack_ShareMessageAndImage request:[TwitterAPI createShareMsgAndImgRequestWithMessage:message image:image] selector:nil]];
    [self popTransaction];
}

- (void)uploadVideo:(NSData *)data message:(NSString *)message
{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[TwitterTransaction transactionWithKey:TW_CallBack_ShareMessageAndImage request:[TwitterAPI createShareMsgAndVideoRequestWithMessage:message video:data] selector:nil]];
    [self popTransaction];
}

#pragma mark - #########Finished Selector#########
/*......*/


@end
