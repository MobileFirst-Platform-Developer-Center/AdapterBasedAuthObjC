/*
 *
 COPYRIGHT LICENSE: This information contains sample code provided in source code form. You may copy, modify, and distribute
 these sample programs in any form without payment to IBM® for the purposes of developing, using, marketing or distributing
 application programs conforming to the application programming interface for the operating platform for which the sample code is written.
 Notwithstanding anything to the contrary, IBM PROVIDES THE SAMPLE SOURCE CODE ON AN "AS IS" BASIS AND IBM DISCLAIMS ALL WARRANTIES,
 EXPRESS OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, ANY IMPLIED WARRANTIES OR CONDITIONS OF MERCHANTABILITY, SATISFACTORY QUALITY,
 FITNESS FOR A PARTICULAR PURPOSE, TITLE, AND ANY WARRANTY OR CONDITION OF NON-INFRINGEMENT. IBM SHALL NOT BE LIABLE FOR ANY DIRECT,
 INDIRECT, INCIDENTAL, SPECIAL OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR OPERATION OF THE SAMPLE SOURCE CODE.
 IBM HAS NO OBLIGATION TO PROVIDE MAINTENANCE, SUPPORT, UPDATES, ENHANCEMENTS OR MODIFICATIONS TO THE SAMPLE SOURCE CODE.
 
 */

#import "MyChallengeHandler.h"
#import "LoginViewController.h"

@implementation MyChallengeHandler

-(id)initWithViewController:(ViewController *)vc {
    self = [super initWithRealm:@"AuthRealm"];
    self.vc = vc;
    return self;
}

-(BOOL) isCustomResponse:(WLResponse *)response {
    if(response && response.responseJSON){
        if ([response.responseJSON objectForKey:@"authRequired"]) {
            NSString* authRequired = (NSString*) [response.responseJSON objectForKey:@"authRequired"];
            return [authRequired boolValue];
        }
    }
    
    return false;
}

-(void) handleChallenge:(WLResponse *)response {
    NSLog(@"A login form should appear");
    if([self.vc.navigationController.visibleViewController isKindOfClass:[LoginViewController class]]){
        dispatch_async(dispatch_get_main_queue(), ^(void){
            LoginViewController*  loginController = (LoginViewController*) self.vc.navigationController.visibleViewController;
            loginController.errorMsg.hidden = NO;
        });
    }
    else{
        [self.vc performSegueWithIdentifier:@"showLogin" sender:self.vc];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            LoginViewController*  loginController = (LoginViewController*) self.vc.navigationController.visibleViewController;
            loginController.challengeHandler = self;
            loginController.errorMsg.hidden = YES;
        });
    }
}

-(void) onSuccess:(WLResponse *)response {
    NSLog(@"Challenge succeeded");
    [self.vc.navigationController popViewControllerAnimated:YES];
    [self submitSuccess:response];
}

-(void) onFailure:(WLFailResponse *)response {
    NSLog(@"Challenge failed");
    [self submitFailure:response];
}


@end
