//
//  FacebookTransaction.h
//
//  Created by yanglei on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FacebookTransaction : NSObject

@property(nonatomic,retain) NSString *transactionKey;

@property(nonatomic,assign) SEL transactionSelector;

@property(nonatomic,retain) NSMutableURLRequest *transactionRequest;

/*创建一个自动释放的事务*/
+ (FacebookTransaction *)transactionWithKey:(NSString *)key request:(NSMutableURLRequest *)request selector:(SEL)selector;

/*创建一个事务对象*/
- (id)initWithKey:(NSString *)key request:(NSMutableURLRequest *)request selector:(SEL)selector;

@end
