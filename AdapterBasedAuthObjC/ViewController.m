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
