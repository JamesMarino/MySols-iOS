#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
	// Setup View
	self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle:nil];
	
	// Check wether last login attempt was succesful
	BOOL UserValidCredentials = [[NSUserDefaults standardUserDefaults] boolForKey:PROPERTY_VALID_LOGIN];
	
	if (UserValidCredentials) {
		// Take to Main Page - Login There
		self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:MAIN_VIEW_NAME];
		
	} else {
		// Take to Login Page
		self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_NAME];
	}
	
	// Make Visible !important
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {}

- (void)applicationDidEnterBackground:(UIApplication *)application {}

- (void)applicationWillEnterForeground:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    UIAlertView *newAppAlert = [[UIAlertView alloc] initWithTitle:@"MySOLS Decommission"
                                                          message:@"The new MyUOW App is now Available with SOLS login support, MySOLS won't be available anymore"
                                                         delegate:self
                                                cancelButtonTitle:@"App Store"
                                                otherButtonTitles:@"Cancel", nil];
    [newAppAlert show];
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    enum buttons {
        Ok = 0,
        Cancel = 1
    };
    
    if (buttonIndex == Cancel) {
        NSLog(@"Canceled");
    } else if (buttonIndex == Ok) {
        
        NSString* myUOWStoreLink = @"https://itunes.apple.com/au/app/myuow/id821928913";
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString:myUOWStoreLink]];

    }
}

@end
