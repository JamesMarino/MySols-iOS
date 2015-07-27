#import "MainView.h"
#include "KeyChain.h"
#include "Constants.h"

@interface MainView ()

- (void)clearDefaults;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation MainView

- (void)viewDidLoad {
	[super viewDidLoad];
	
	// Remove top bar
	[self setNeedsStatusBarAppearanceUpdate];
	
	// Setup Webview
	self.webView.delegate = self;
	self.webView.scrollView.bounces = NO;
	
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
	[self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	[self.spinner stopAnimating];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)viewDidAppear:(BOOL)animated
{
	// Check What to do
	if ([self.URL length] != 0) {
		// Normal Setup
		NSURL *url = [NSURL URLWithString: self.URL];
		
		// Setup Request
		NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
		
		// Instantiate Webview
		[self.webView loadRequest:request];
	} else {
		[self navigateToLoginPage];
	}
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
	
	// Get current URL
	NSString *URLString = [[request URL] absoluteString];
	NSLog(@"URL: %@", URLString);

	// Switch on URL
	if ([URLString isEqualToString:SOLS_LOGIN_URL]) {
		[self navigateToLoginPage];
	} else if ([URLString rangeOfString:SOLS_LOGOUT_URL].location != NSNotFound) {
		[self clearDefaults];
		[self navigateToLoginPage];
	} else if ([URLString rangeOfString:SOLS_ALTERNATIVE_LOGIN_URL].location != NSNotFound) {
		[self navigateToLoginPage];
	}
	
	// Check for outside URL's
	if (([URLString rangeOfString:SOLS_BASE_URL].location == NSNotFound) ||
		([URLString rangeOfString:SOLS_SUBJECT_DB_URL].location != NSNotFound)) {
		NSURL *url = [NSURL URLWithString:URLString];
		[[UIApplication sharedApplication] openURL:url];
		
		// Go Back
		if ([webView canGoBack]) {
			[webView goBack];
		}
	}
	
	return YES;
}

- (void)navigateToLoginPage
{
	// Take to Login page
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:STORYBOARD_NAME bundle: nil];
	UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_NAME];
	[self presentViewController:vc animated:NO completion:nil];
}

- (void)clearDefaults
{
	// Reset User Defaults
	[NSUserDefaults resetStandardUserDefaults];
	
	// Reset Keychain
	[KeyChain deleteAllKeysForSecClass:kSecClassInternetPassword];
}

@end
