// Generated by Swift version 1.1 (swift-600.0.56.1)
#pragma clang diagnostic push

#if defined(__has_include) && __has_include(<swift/objc-prologue.h>)
# include <swift/objc-prologue.h>
#endif

#pragma clang diagnostic ignored "-Wauto-import"
#include <objc/NSObject.h>
#include <stdint.h>
#include <stddef.h>
#include <stdbool.h>

#if defined(__has_include) && __has_include(<uchar.h>)
# include <uchar.h>
#elif !defined(__cplusplus) || __cplusplus < 201103L
typedef uint_least16_t char16_t;
typedef uint_least32_t char32_t;
#endif

typedef struct _NSZone NSZone;

#if !defined(SWIFT_PASTE)
# define SWIFT_PASTE_HELPER(x, y) x##y
# define SWIFT_PASTE(x, y) SWIFT_PASTE_HELPER(x, y)
#endif
#if !defined(SWIFT_METATYPE)
# define SWIFT_METATYPE(X) Class
#endif

#if defined(__has_attribute) && __has_attribute(objc_runtime_name)
# define SWIFT_RUNTIME_NAME(X) __attribute__((objc_runtime_name(X)))
#else
# define SWIFT_RUNTIME_NAME(X)
#endif
#if !defined(SWIFT_CLASS_EXTRA)
# define SWIFT_CLASS_EXTRA
#endif
#if !defined(SWIFT_PROTOCOL_EXTRA)
# define SWIFT_PROTOCOL_EXTRA
#endif
#if !defined(SWIFT_CLASS)
# if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted) 
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) __attribute__((objc_subclassing_restricted)) SWIFT_CLASS_EXTRA
# else
#  define SWIFT_CLASS(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_CLASS_EXTRA
# endif
#endif

#if !defined(SWIFT_PROTOCOL)
# define SWIFT_PROTOCOL(SWIFT_NAME) SWIFT_RUNTIME_NAME(SWIFT_NAME) SWIFT_PROTOCOL_EXTRA
#endif

#if !defined(SWIFT_EXTENSION)
# define SWIFT_EXTENSION(M) SWIFT_PASTE(M##_Swift_, __LINE__)
#endif

#if !defined(OBJC_DESIGNATED_INITIALIZER)
# if defined(__has_attribute) && __has_attribute(objc_designated_initializer)
#  define OBJC_DESIGNATED_INITIALIZER __attribute__((objc_designated_initializer))
# else
#  define OBJC_DESIGNATED_INITIALIZER
# endif
#endif
#if defined(__has_feature) && __has_feature(modules)
@import ObjectiveC;
@import UIKit;
#endif

#pragma clang diagnostic ignored "-Wproperty-attribute-mismatch"
#pragma clang diagnostic ignored "-Wduplicate-method-arg"
@protocol LoginDelegate;
@class LoginViewController;
@class UIColor;

SWIFT_CLASS("_TtC5Login5Login")
@interface Login : NSObject
- (instancetype)init OBJC_DESIGNATED_INITIALIZER;
+ (LoginViewController *)createLoginViewControllerWithDelegate:(id <LoginDelegate>)dgt;
+ (void)specifyDefaultUserID:(LoginViewController *)loginVC defaultUserID:(NSString *)defaultUserID;
+ (void)specifyDefaultPassword:(LoginViewController *)loginVC defaultPassword:(NSString *)defaultPassword;
+ (void)specifyPasswordRequired:(LoginViewController *)loginVC passwordRqd:(BOOL)passwordRqd;
+ (void)specifyEnvironment:(LoginViewController *)loginVC environment:(NSString *)environment;
+ (void)specifyScreenBackgroundColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyScreenButtonsColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyVersionLabelColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyFormBackgroundColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyHeadingLabelText:(LoginViewController *)loginVC ttl:(NSString *)ttl;
+ (void)specifyHeadingLabelColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifySignInButtonTextColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifySignInButtonBackgroundColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyRememberNameLabelColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifyRememberSwitchColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifySpinnerColor:(LoginViewController *)loginVC rqdColor:(UIColor *)rqdColor;
+ (void)specifySpinnerAnimating:(LoginViewController *)loginVC animating:(BOOL)animating;
+ (void)specifyTouchIDEnabled:(LoginViewController *)loginVC enabled:(BOOL)enabled;
+ (void)saveCredentialsInKeychain:(LoginViewController *)loginVC;
+ (void)removeCredentialsInKeychain:(LoginViewController *)loginVC;
@end


SWIFT_PROTOCOL("_TtP5Login13LoginDelegate_")
@protocol LoginDelegate
- (void)loginViewControllerLoaded;
- (void)capturedLoginCredentials:(NSString *)userName password:(NSString *)password;
@optional
- (void)retrievedLoginCredentialsFromKeychain:(NSString *)userName password:(NSString *)password;
@end

@class NSBundle;
@class NSCoder;

SWIFT_CLASS("_TtC5Login19LoginViewController")
@interface LoginViewController : UIViewController <UITextFieldDelegate>
@property (nonatomic, weak) id <LoginDelegate> delegate;
- (void)viewDidLoad;
- (void)viewDidAppear:(BOOL)animated;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil OBJC_DESIGNATED_INITIALIZER;
- (instancetype)init OBJC_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder OBJC_DESIGNATED_INITIALIZER;
@end

#pragma clang diagnostic pop
