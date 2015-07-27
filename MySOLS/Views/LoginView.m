#import "LoginView.h"
#include "KeyChain.h"
#include "Constants.h"
#include "MainView.h"

@interface LoginView ()

- (void)attemptLogin;

- (BOOL)usernameIsValid;
- (BOOL)passwordIsValid;
- (void)updateResponseLabelWithText:(NSString*)Text;

@end

@implementation LoginView

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// If you are Logging in, all defaults and KeyChain should be cleared
	// [self clearDefaults];
	
	// Setup Webview
	self.WebView.delegate = self;
	
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
			// Auto-Login
			[self.LoginButton sendActionsForControlEvents:UIControlEventTouchUpInside];
		}
	}
	
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (IBAction)LoginPressed:(id)sender
{
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
		
		// All good, Attempt to login
		[self attemptLogin];
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
	
	NSLog(@"Username: %@", username);
	NSLog(@"Password: %@", password);
	
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
	
	NSLog(@"Current Address: %@", URLString);
	
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

@end
