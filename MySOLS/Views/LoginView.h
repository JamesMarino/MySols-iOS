#import <UIKit/UIKit.h>

@interface LoginView : UIViewController<UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UITextField *UsernameField;
@property (strong, nonatomic) IBOutlet UITextField *PasswordField;
@property (strong, nonatomic) IBOutlet UIWebView *WebView;

- (IBAction)LoginPressed:(id)sender;

@end
