
#import "RAAS.h"
#import <SVProgressHUD.h>
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
#import "ExampleViewController.h"

@implementation ExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view = [[[NSBundle mainBundle]
                       loadNibNamed:@"SimpleView"
                       owner:self options:nil]
                      firstObject];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(makeUseOfOurDropIn)
                                                 name:@"settingsReceived"
                                               object:nil];
    
}

- (void) makeUseOfOurDropIn{
    
    CGRect buttonFrame = CGRectMake(100, 100, 50, 50);
    UIButton *shareButton = [[RAAS inviteManager] generateInviteButtonWithFrame:buttonFrame andContainer:self];
    [self.view addSubview:shareButton];
}



@end
