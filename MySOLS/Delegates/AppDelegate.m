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

- (void)applicationDidBecomeActive:(UIApplication *)application {}

- (void)applicationWillTerminate:(UIApplication *)application {}

@end
