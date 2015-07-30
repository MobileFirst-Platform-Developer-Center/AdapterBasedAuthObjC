/**
* Copyright 2015 IBM Corp.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
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
