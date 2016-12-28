//
//  ModalAlert.m
//  CountDown
//
//  Created by tang.wei on 14-4-28.
//  Copyright (c) 2014年 tang.wei. All rights reserved.
//

#import "ModalAlert.h"

typedef void (^ResultBlock)(NSUInteger);

@interface ModalAlertDelegate : NSObject

- (id)initWithResult:(ResultBlock)result;

@end

@implementation ModalAlert

// Yes-No button
+ (void) ask:(NSString *)message result:(void (^)(BOOL yesOrNo))result
{
    [self ask:nil message:message result:result];
}

+ (void) ask:(NSString *)title message:(NSString *)message result:(void (^)(BOOL yesOrNo))result
{
    [self showWithTitle:title message:message cancelButton:@"No" otherButtons:@[@"Yes"] result:^(NSUInteger buttonIndex) {
        result( (buttonIndex == 1) );
    }];
}

// OK-Cancel button
+ (void) confirm:(NSString *)message result:(void (^)(BOOL))result
{
    [self confirm:nil message:message result:result];
}

+ (void) confirm:(NSString *)title message:(NSString *)message result:(void (^)(BOOL))result
{
    [self showWithTitle:title message:message cancelButton:@"Cancel" otherButtons:@[@"OK"] result:^(NSUInteger buttonIndex) {
        result( (buttonIndex == 1) );
    }];
}

// OK
+ (void) say:(id)formatString,...
{
    va_list args;
    va_start(args, formatString);
    id message = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    
    [self showWithTitle:nil
                message:message
           cancelButton:@"OK"
           otherButtons:nil
                 result:nil];
    
    [message release];

}

+ (void) say:(NSString *)title message:(id)formatString,...
{
    va_list args;
    va_start(args, formatString);
    id message = [[NSString alloc] initWithFormat:formatString arguments:args];
    va_end(args);
    
    [self showWithTitle:title
                message:message
           cancelButton:@"OK"
           otherButtons:nil
                 result:nil];
    
    [message release];
}

// Other
+ (void)showWithTitle:(NSString *)title
              message:(NSString *)message
         cancelButton:(NSString *)cancel
         otherButtons:(NSArray *)otherButtons
               result:( void (^)(NSUInteger buttonIndex) )result
{
    ModalAlertDelegate* delegate = [[ModalAlertDelegate alloc] initWithResult:result];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:delegate
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil];
    
    for (NSString* btn in otherButtons) {
        [alert addButtonWithTitle:btn];
    }
    
    [alert show];
    [alert release];
    
}

@end


@interface ModalAlertDelegate () <UIAlertViewDelegate>

@property (nonatomic, copy) ResultBlock result;

@end

@implementation ModalAlertDelegate

- (id)initWithResult:(ResultBlock)result
{
    if (self = [super init]) {
        self.result = result;
    }
    return self;
}

- (void)dealloc
{
    self.result = nil;
    [super dealloc];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( self.result ) {
        self.result(buttonIndex);
    }
    
    [self release];
}

@end
