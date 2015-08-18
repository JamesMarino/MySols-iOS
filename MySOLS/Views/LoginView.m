#import "LoginView.h"
#include "KeyChain.h"
#include "Constants.h"
#include "MainView.h"
#import "Reachability.h"

@interface LoginView ()

- (void)attemptLogin;

- (BOOL)usernameIsValid;
- (BOOL)passwordIsValid;
- (void)updateResponseLabelWithText:(NSString*)Text;
- (BOOL)connected;
- (void)alertOffline;

@end

@implementation LoginView

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Satus Bar
	[self setNeedsStatusBarAppearanceUpdate];
	
	// Keyboard
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
								   initWithTarget:self
								   action:@selector(dismissKeyboard)];
	
	[self.view addGestureRecognizer:tap];
	
	// Setup Webview / other delegates
	self.WebView.delegate = self;
	self.UsernameField.delegate = self;
	self.PasswordField.delegate = self;
	
	// Display Values
	if ([[NSUserDefaults standardUserDefaults] stringForKey:PROPERTY_VALID_LOGIN]) {
		
		// Get Username
		NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:PROPERTY_USERNAME];
		
		// Get Password
		NSDictionary *data = [KeyChain getDataWithUsername:username];
		NSData *passwordData = data[(__bridge id)kSecValueData];
		NSString *password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
		
		// Set Fields
		self.UsernameField.text = username;
		self.PasswordField.text = password;
		
		if (([username length] != 0) && ([password length] != 0)) {
			
			// Check if connected to internet
			if ([self connected]) {
				// Auto-Login
				[self.LoginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
			} else {
				[self alertOffline];
			}
		}
	}
	
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
	return UIStatusBarStyleLightContent;
}

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
	
	if (textField == self.UsernameField) {
		[self.PasswordField becomeFirstResponder];
	} else if(textField == self.PasswordField) {
		[self.LoginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
	}
	
	return YES;
}

-(void)dismissKeyboard
{
	[self.UsernameField resignFirstResponder];
	[self.PasswordField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)LoginPressed:(id)sender
{
	// End Editing
	[self.view endEditing:YES];
	
	// Check Form Inputs / Setup
	NSString *ErrorMessage = NULL;
	BOOL UsernameValid = true, PasswordValid = true;
	
	UsernameValid = [self usernameIsValid];
	PasswordValid = [self passwordIsValid];
	
	if ((UsernameValid == false) && (PasswordValid == false)) {
		ErrorMessage = @"Password and Username Invalid";
	} else if (UsernameValid == false) {
		ErrorMessage = @"Username Invalid";
	} else if (PasswordValid == false) {
		ErrorMessage = @"Password Invalid";
	} else {
		// Store Password
		[KeyChain storeWithUsername:self.UsernameField.text
					   WithPassword:self.PasswordField.text];
		
		// Store Username
		NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
		[prefrences setObject:self.UsernameField.text forKey:PROPERTY_USERNAME];
		
		// Check if connected to internet
		if ([self connected]) {
			// Auto-Login
			// All good, Attempt to login
			[self attemptLogin];
		} else {
			[self alertOffline];
		}
	}
	
	// Print Error Message if there is Error Message
	if (ErrorMessage != NULL) {
		self.ResponseText.text = ErrorMessage;
	}
}

- (void)attemptLogin
{
	// Setup
	NSString *username, *password;
	
	// Get Username
	username = [[NSUserDefaults standardUserDefaults] stringForKey:PROPERTY_USERNAME];
	
	// Get Password
	NSDictionary *data = [KeyChain getDataWithUsername:username];
	NSData *passwordData = data[(__bridge id)kSecValueData];
	password = [[NSString alloc] initWithData:passwordData encoding:NSUTF8StringEncoding];
	
	// Setup URL
	NSURL *url = [NSURL URLWithString: SOLS_LOGIN_URL];
	NSString *body = [NSString stringWithFormat: SOLS_LOGIN_POST, username, password];
		
	// Setup Request
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
	[request setHTTPMethod: @"POST"];
	[request setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
		
	// Instantiate Webview
	[self.WebView loadRequest:request];
	
}

- (BOOL)usernameIsValid
{
	if (self.UsernameField.text.length <= 0) {
		return false;
	} else {
		return true;
	}
}

- (BOOL)passwordIsValid
{
	if (self.PasswordField.text.length <= 0) {
		return false;
	} else {
		return true;
	}
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	// Get current URL
	NSString *URLString = [[request URL] absoluteString];
	
	// Login Success
	if (![URLString isEqualToString:SOLS_LOGIN_URL]) {
		
		// Set Valid Credentials to True
		NSUserDefaults *prefrences = [NSUserDefaults standardUserDefaults];
		[prefrences setBool:true forKey:PROPERTY_VALID_LOGIN];
		
		// Take to Main Page
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle: nil];
		MainView *mainView = [storyboard instantiateViewControllerWithIdentifier:MAIN_VIEW_NAME];
		mainView.URL = URLString;
		[self presentViewController:mainView animated:YES completion:nil];
		
	} else {
		
		// Inform User
		if ([self usernameIsValid] || [self passwordIsValid]) {
			
			// Wait on User
			[self.ResponseText setTextColor:[UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]];
			self.ResponseText.text = @"Working...";
			
			// Change Error Text
			[self performSelector:@selector(updateResponseLabelWithText:)
					   withObject:@"Incorrect Username Or Password"
					   afterDelay:1.0];
		}
		
	}
	
	return YES;
}

- (void)updateResponseLabelWithText:(NSString*)Text
{
	[self.ResponseText setTextColor:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]];
	self.ResponseText.text = Text;
}

- (BOOL)connected
{
	Reachability *reachability = [Reachability reachabilityForInternetConnection];
	NetworkStatus networkStatus = [reachability currentReachabilityStatus];
	return networkStatus != NotReachable;
}

- (void)alertOffline
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline"
													message:@"You are offline and have been logged out. Please check your internet connection"
												   delegate:nil
										  cancelButtonTitle:@"Ok"
										  otherButtonTitles:nil];
	[alert show];
}

@end
