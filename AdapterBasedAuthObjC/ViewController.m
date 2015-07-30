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

#import "ViewController.h"
#import "MyConnectListener.h"
#import "MyChallengeHandler.h"
#import "MyLogoutListener.h"

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    NSLog(@"Connecting to MobileFirst Server...");
    MyConnectListener *connectListener = [[MyConnectListener alloc] init];
    [[WLClient sharedInstance] registerChallengeHandler:[[MyChallengeHandler alloc] initWithViewController:self] ];
    [[WLClient sharedInstance] wlConnectWithDelegate:connectListener];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)callProtectedAdapterProcedure:(UIButton *)sender {

    NSURL* url = [NSURL URLWithString:@"/adapters/AuthAdapter/getSecretData"];
    WLResourceRequest* request = [WLResourceRequest requestWithURL:url method:WLHttpMethodGet];
    [request sendWithCompletionHandler:^(WLResponse *response, NSError *error) {
        if(error){
            NSLog(@"Adapter invocation failure. Error: %@", error.description);
        }
        else{
            UIAlertView *adapterResponseAlert = [[UIAlertView alloc] initWithTitle:@"Adapter Response"
                                                                           message: [response responseText]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil];
            [adapterResponseAlert show];
        }
    }];

}
- (IBAction)logout:(id)sender {
    [[WLClient sharedInstance] logout:@"AuthRealm" withDelegate:[[MyLogoutListener alloc] init]];
}


@end
