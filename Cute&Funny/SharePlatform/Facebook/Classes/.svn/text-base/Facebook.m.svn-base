//
//  Facebook.m
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Facebook.h"
#import "SRHttpFetcher.h"
#import "FacebookTransaction.h"
#import "JSON.h"
#import "FBRequest.h"

#define BundleName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
#define SAFE_Release(p)	if(p) { [p release]; p = nil; }


@interface Facebook(PrivateMethods) <FBRequestDelegate>

/*弹出顶端事务*/
- (void)popTransaction;

/*废弃顶端事务*/
- (void)deprecatedTopTransaction;

/*立刻执行事务*/
- (void)commitTransaction:(FacebookTransaction *)transaction;

/*解析Json为Dictionary*/
-  (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData;

/*检查BundleName的Album是否已经被创建*/
- (BOOL)checkBundleNameAlbumExsit:(NSArray *)albums;

@end

static Facebook  *facebook = nil;

@implementation Facebook
{
    FBRequest* _request;
}

@synthesize delegate;
@synthesize apiTransactions;

#pragma mark - Category Methods
/*单例对象初始化*/
+(Facebook *)sharedFacebook
{	
	if (facebook) 
	{
		return facebook;
	}
	
	@synchronized([Facebook class])
	{
        facebook = [[Facebook alloc] init];
	}
	return facebook;
}

/*单例对象释放*/
+ (void)releaseFacebook
{
    [facebook release];
    facebook = nil;
}

/*删除过时授权数据*/
+ (void)removeAuthorizedCacheInfo{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FB_AccessToken];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FB_AccountProfile];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/*检查是否存在授权数据*/
+ (BOOL)checkAuthorizedCacheInfo{
    return[[NSUserDefaults standardUserDefaults] objectForKey:FB_AccountProfile]?YES:NO;
}

#pragma mark - Object Methods
- (id)init{
    if(self = [super init]){
        self.apiTransactions = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

- (void)dealloc{
    SAFE_Release(apiTransactions);
    SAFE_Release(albumID);
    SAFE_Release(uploadImg);
    SAFE_Release(uploadMsg);
    [super dealloc];
}

#pragma mark - Private Methods
/*弹出顶端事务*/
- (void)popTransaction{
    if([self.apiTransactions count] > 0){
        FacebookTransaction *transaction = [self.apiTransactions objectAtIndex:0];
        [SRHttpFetcher beginFetchWithRequest:transaction.transactionRequest
                                      object:transaction 
                                    delegate:facebook];
        [self.apiTransactions removeObjectAtIndex:0];
    }
}

/*废弃顶端事务*/
- (void)deprecatedTopTransaction{
    if([self.apiTransactions count] > 0)
        [self.apiTransactions removeObjectAtIndex:0];
}

/*立刻执行事务*/
- (void)commitTransaction:(FacebookTransaction *)transaction{
    [SRHttpFetcher beginFetchWithRequest:transaction.transactionRequest
                                  object:transaction 
                                delegate:facebook];
}

/*解析Json为Dictionary*/
-  (NSMutableDictionary *)parseToDictionaryWithJsonData:(NSData *)jsonData{
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSError *error = nil;
    SBJSON *parser = [SBJSON new];
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithDictionary:[parser objectWithString:jsonString error:&error]];
    if(error)
        response = [NSMutableDictionary dictionaryWithCapacity:0];
    [jsonString release];
    [parser release];
    
    return response;
}

/*检查BundleName的Album是否已经被创建*/
- (BOOL)checkBundleNameAlbumExsit:(NSArray *)albums{
    for(NSDictionary *album in albums){
        if([[album objectForKey:@"name"] isEqualToString:BundleName]){
            albumID =  [[album objectForKey:@"id"] retain];
            return YES;
        }
    }
    return NO;
}


#pragma mark - SRHttpFetcherDelegate Delegate
- (void)requestSuccessWithData:(NSData *)data object:(NSObject *)object{
    FacebookTransaction *transaction = (FacebookTransaction *)object;
    if(!transaction.transactionSelector)
        [self popTransaction];
    else 
        [self performSelector:transaction.transactionSelector withObject:data];
    if(self.delegate && [self.delegate respondsToSelector:@selector(fbTransactionSuccessWithKey:data:)])
        [self.delegate fbTransactionSuccessWithKey:transaction.transactionKey data:data];
}

- (void)requestFaildWithError:(NSError *)error object:(NSObject *)object{
    FacebookTransaction *transaction = (FacebookTransaction *)object;
    if(self.delegate && [self.delegate respondsToSelector:@selector(fbTransactionFailedWithKey:error:)])
        [self.delegate fbTransactionFailedWithKey:transaction.transactionKey error:error];
}

#pragma mark - #########API Achieve#########
/*获取朋友列表*/
- (void)beginFetchFriendsList{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[FacebookTransaction transactionWithKey:FB_CallBack_FriendsList 
                                                                    request:[FacebookAPI createFriendsListRequest] 
                                                                   selector:nil]];
    [self popTransaction];
}

- (void)beginFetchEventsListForStartDate:(NSDate *)startDate endDate:(NSDate *)endDate forKey:(NSString *)key
{
    [self.apiTransactions removeAllObjects];
    [self.apiTransactions addObject:[FacebookTransaction transactionWithKey:key
                                                                    request:[FacebookAPI createEventsListRequestForStart:startDate end:endDate]
                                                                   selector:nil]];
    [self popTransaction];
}

/*发送信息到涂鸦墙*/
- (void)beginPostToFeedWallWithMessage:(NSString *)message parameters:(NSMutableDictionary *)parameters{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[FacebookTransaction transactionWithKey:FB_CallBack_FeedWall 
                                                                    request:[FacebookAPI createShareMsgRequestWithMessage:message parameters:parameters] 
                                                                   selector:nil]];
    [self popTransaction];
}


/*上传图片到相册*/
- (void)beginUploadImgWithImage:(UIImage *)image
                              message:(NSString *)messag{
    [self.apiTransactions  removeAllObjects];
    [self.apiTransactions addObject:[FacebookTransaction transactionWithKey:FB_CallBack_FetchAlbums 
                                                                    request:[FacebookAPI createAlbumsRequest] 
                                                                   selector:@selector(albumsRequestFinished:)]];
    [self.apiTransactions addObject:[FacebookTransaction transactionWithKey:FB_CallBack_CreateAlbum 
                                                                    request:[FacebookAPI createCreateAlbumWithName:BundleName message:nil] 
                                                                   selector:@selector(createAlbumRequestFinished:)]];
    SAFE_Release(uploadImg);
    SAFE_Release(uploadMsg);
    uploadImg = [image retain];
    uploadMsg = [messag retain];
    [self popTransaction];
}

- (void)uploadVideo:(NSData *)videoData message:(NSString *)message
{
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:videoData,@"video.mov",
                                   @"video/quicktime", @"contentType",
                                   @"Video Test", @"title",
                                   message, @"description", nil];
    
    [params setValue:@"json" forKey:@"format"];
    [params setValue:@"ios" forKey:@"sdk"];
    [params setValue:@"2" forKey:@"sdk_version"];
    if ([[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken]) {
        [params setValue:[[NSUserDefaults standardUserDefaults] objectForKey:FB_AccessToken] forKey:@"access_token"];
    }
    
    [_request release];
    _request = [[FBRequest getRequestWithParams:params
                                     httpMethod:@"POST"
                                       delegate:self
                                     requestURL:@"https://graph.facebook.com/me/videos"] retain];
    [_request connect];
}

- (void)requestLoading:(FBRequest *)request
{
    
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response
{
    
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(fbTransactionFailedWithKey:error:)]) {
        [self.delegate fbTransactionFailedWithKey:FB_CallBack_UploadImage error:error];
    }
}

- (void)request:(FBRequest *)request didLoad:(id)result
{
    if ( [self.delegate respondsToSelector:@selector(fbTransactionSuccessWithKey:data:)]) {
        [self.delegate fbTransactionSuccessWithKey:FB_CallBack_UploadImage data:nil];
    }
}

#pragma mark - #########Finished Selector#########
- (void)albumsRequestFinished:(NSData *)data{
    NSArray *respose =  [[self parseToDictionaryWithJsonData:data] objectForKey:@"data"] ;
    if([self checkBundleNameAlbumExsit:respose]){
        [self deprecatedTopTransaction]; 
        [self commitTransaction:[FacebookTransaction transactionWithKey:FB_CallBack_UploadImage 
                                                                request:[FacebookAPI createUploadImgRequestWithAlbumID:albumID image:uploadImg message:uploadMsg] 
                                                               selector:nil]];
        SAFE_Release(albumID);
        SAFE_Release(uploadImg);
        SAFE_Release(uploadMsg);
    }else
        [self popTransaction];
}

- (void)createAlbumRequestFinished:(NSData *)data{
    NSDictionary *respose =  [self parseToDictionaryWithJsonData:data];
    albumID =  [[respose objectForKey:@"id"] retain];
    [self commitTransaction:[FacebookTransaction transactionWithKey:FB_CallBack_UploadImage 
                                                            request:[FacebookAPI createUploadImgRequestWithAlbumID:albumID image:uploadImg message:uploadMsg] 
                                                           selector:nil]];
    SAFE_Release(albumID);
    SAFE_Release(uploadImg);
    SAFE_Release(uploadMsg);
}

@end
