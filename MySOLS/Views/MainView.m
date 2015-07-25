#import "MainView.h"
#include "KeyChain.h"
#include "Constants.h"

@interface MainView ()

@property (strong, nonatomic) IBOutlet UIWebView *webView;

- (void)attemptLogin;

@end

@implementation MainView

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Setup Webview
	self.webView.delegate = self;
	
	
	// Setup URL
	NSString *URLString = self.URL;
	NSURL *url = [NSURL URLWithString: URLString];
	
	// Setup Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
	
	// Instantiate Webview
	[self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	// Get current URL
	NSString *URLString = [[request URL] absoluteString];
	
	// Get Counter
	NSInteger counter = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginAttempts"];
	
	NSLog(@"Counter: %ld", (long)counter);
	
	if ([URLString isEqualToString:SOLS_LOGIN_URL]) {
		
		// Take to home page
		NSString * storyboardName = @"Main";
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
		UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
		[self presentViewController:vc animated:YES completion:nil];
		
		/*
		if (counter < 1) {
			// Attempt to login again
			[self attemptLogin];
			
			// Increase Counter
			NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
			[prefrences setInteger:(counter+1) forKey:@"LoginAttempts"];
		} else {
			// Enough Tries
			
			// Reset Counter
			NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
			[prefrences setInteger:0 forKey:@"LoginAttempts"];
			
			// Take to home page
			NSString * storyboardName = @"Main";
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
			UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
			[self presentViewController:vc animated:YES completion:nil];
			
			NSLog(@"Going Home...");
		}
		*/
		
		/*
		// Take to home page
		NSString * storyboardName = @"Main";
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
		UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
		[self presentViewController:vc animated:YES completion:nil];
		
		NSLog(@"Going Home...");
		 */
		
		/*
		// Increment Counter
		NSInteger counter = [[NSUserDefaults standardUserDefaults] integerForKey:@"LoginAttempts"];
		
		if (counter > 1) {
			// Take to home page
			NSString * storyboardName = @"Main";
			UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
			UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
			[self presentViewController:vc animated:YES completion:nil];
			
			NSLog(@"Going Home...");
			
			// Set counter to 0
			NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
			[prefrences setInteger:0 forKey:@"LoginAttempts"];
			
		} else {
			// Give it another go
			[self attemptLogin];
			NSLog(@"Another Login Attempt...");
			
			// Add attempts
			NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
			[prefrences setInteger:(counter+1) forKey:@"LoginAttempts"];
		}
		*/
		 
	} else {
		
		NSLog(@"new url");
		
		/*
		// Set counter to 0
		NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
		[prefrences setInteger:0 forKey:@"LoginAttempts"];
		 */
		
		/*
		// Redirect to webview
		NSString * storyboardName = @"Main";
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
		UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"MainWebView"];
		[self presentViewController:vc animated:YES completion:nil];
		*/
		 
	}
	
	// if logon URL
		// try log in once, if no luck, take back to 1st page
		// increment counter
	
	// else
		// set counter 0
	
	
	NSLog(@"Currently At: %@", URLString);
	
	return YES;
}

- (void)attemptLogin
{
	// Setup
	NSString *username, *password;
	
	
	// Get Username
	NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
	username = [prefrences stringForKey:@"Username"];
	
	// Get Password
	NSDictionary *data = [KeyChain getDataWithUsername:username];
	NSData *passwordData = data[(__bridge id)kSecValueData];
	password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
	
	NSLog(@"Username: %@", username);
	NSLog(@"Password: %@", password);
	
	// Setup URL
	NSString *URLString = SOLS_LOGIN_URL;
	NSURL *url = [NSURL URLWithString: URLString];
	NSString *body = [NSString stringWithFormat: SOLS_LOGIN_POST, username, password];
	
	// Setup Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
	
	// Instantiate Webview
	[self.webView loadRequest:request];
}

@end
