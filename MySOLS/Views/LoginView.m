#import "LoginView.h"
#include "KeyChain.h"
#include "Constants.h"
#include "MainView.h"

@interface LoginView ()

- (void)attemptLogin;

@end

@implementation LoginView

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Setup Webview
	self.WebView.delegate = self;

	// Attempt to login
	[self attemptLogin];
	
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (IBAction)LoginPressed:(id)sender
{
	// Store Password
	[KeyChain storeWithUsername:self.UsernameField.text
				   WithPassword:self.PasswordField.text];
	
	// Store Username
	NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
	[prefrences setObject:self.UsernameField.text forKey:@"Username"];
	
	// Attempt to login
	[self attemptLogin];
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
	
	if (([password length] <= 0) || ([username length] <= 0)) {
		
	} else {
	
		// Setup URL
		NSString *URLString = SOLS_LOGIN_URL;
		NSURL *url = [NSURL URLWithString: URLString];
		NSString *body = [NSString stringWithFormat: SOLS_LOGIN_POST, username, password];
		
		// Setup Request
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
		[request setHTTPMethod: @"POST"];
		[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
		
		// Instantiate Webview
		[self.WebView loadRequest:request];
	}
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	// Get current URL
	NSString *URLString = [[request URL] absoluteString];
	
	
	if (![URLString isEqualToString:SOLS_LOGIN_URL]) {
		
		// Take to Main Page
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
		MainView *mainView = [storyboard instantiateViewControllerWithIdentifier:@"MainWebView"];
		mainView.URL = URLString;
		[self presentViewController:mainView animated:YES completion:nil];
		
	} else {
		
		// Say Wrong Password
		
	}
	
	NSLog(@"Current Address: %@", URLString);
	
	return YES;
}

@end
