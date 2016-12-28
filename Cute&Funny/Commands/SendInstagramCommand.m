//
//  SendInstagramCommand.m
//  PromGuide
//
//  Created by tang.wei on 14-3-24.
//
//

#import "SendInstagramCommand.h"
#import "SaveCommand.h"

@implementation SendInstagramCommand
{
//    UIDocumentInteractionController * _docController;
    SaveCommand* _saveCommand;
}

- (void)execute
{
    if (!_saveCommand) {
        _saveCommand = [[SaveCommand alloc] init];
    }

    _saveCommand.media = self.userData[kUserDataEntityKey];
    _saveCommand.userData = @{@"success":@"Gif saved to your album, please upload it via instagram."};
    
    [_saveCommand execute];
    
//    NSURL *instagramURL = [NSURL URLWithString:@"instagram://media?id=315"];
//    if ([[UIApplication sharedApplication] canOpenURL:instagramURL]) {
//        NSString *savedImagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Image.igo"];
//        [[self.userData objectForKey:kShareImageKey] writeToFile:savedImagePath atomically:YES];
//        NSURL *imageUrl = [NSURL fileURLWithPath:savedImagePath];
//        
////        _docController = [[UIDocumentInteractionController alloc] init];
//        //                    docController.delegate = self;
////        _docController.UTI = @"com.instagram.exclusivegram";
////        [_docController setURL:imageUrl];
//        
//        _docController = [[UIDocumentInteractionController interactionControllerWithURL:imageUrl] retain];
//        
//        NSString *message = [self.userData objectForKey:kShareMessageKey];
//        _docController.annotation = [NSDictionary dictionaryWithObject:message
//                                                                forKey:@"InstagramCaption"];
//        [_docController presentOpenInMenuFromRect:CGRectZero inView:[[[[UIApplication sharedApplication] delegate].window rootViewController] view] animated:YES];
//    }
//    else {
//        NSLog(@"No Instagram Found");
//        UIAlertView *alterView = [[UIAlertView alloc] initWithTitle:nil message:@"No Instagram Found" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alterView show];
//        [alterView release];
//    }
}

- (void)dealloc
{
//    [_docController release];
    [_saveCommand release];
    [super dealloc];
}

@end
