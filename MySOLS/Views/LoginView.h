#import <UIKit/UIKit.h>
#import <SystemConfiguration/SystemConfiguration.h>

@interface LoginView : UIViewController<UIWebViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *UsernameField;
@property (strong, nonatomic) IBOutlet UITextField *PasswordField;
@property (strong, nonatomic) IBOutlet UIWebView *WebView;
@property (strong, nonatomic) IBOutlet UILabel *ResponseText;
@property (strong, nonatomic) IBOutlet UIButton *LoginButton;

- (IBAction)LoginPressed:(id)sender;

@end
