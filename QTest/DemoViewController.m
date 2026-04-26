//
//  DemoViewController.m
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import "DemoViewController.h"
#import "QTest-Swift.h"

@interface DemoViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *usernameErrorLabel;
@property (nonatomic, strong) UILabel *passwordErrorLabel;
@property (nonatomic, strong) UILabel *addressBookLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    [self setupTapGesture];
}

-(void)setupUI {
    UILabel *usernameLabel = [self createLabelWithText:@"用户名"];
    UILabel *passwordLabel = [self createLabelWithText:@"密码"];
    
    self.usernameField = [self createUserNameField];
    self.passwordField = [self createPasswordField];
    self.addressBookLabel = [self createAddressBookLabel];
    
    // 创建错误提示标签
    self.usernameErrorLabel = [self createErrorLabel];
    self.passwordErrorLabel = [self createErrorLabel];
    
    // 设置代理
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    [self.view addSubview:usernameLabel];
    [self.view addSubview:passwordLabel];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.usernameErrorLabel];
    [self.view addSubview:self.passwordErrorLabel];
    [self.view addSubview:self.addressBookLabel];
    
    [self setupConstraintsWithUsernameLabel:usernameLabel 
                            usernameField:self.usernameField
                            passwordLabel:passwordLabel 
                            passwordField:self.passwordField];
}

-(UILabel *)createLabelWithText:(NSString *)text {
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = [UIFont systemFontOfSize:20.0];
    label.textColor = UIColor.darkGrayColor;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    return label;
}

-(UILabel *)createErrorLabel {
    UILabel *errorLabel = [[UILabel alloc] init];
    errorLabel.font = [UIFont systemFontOfSize:12.0];
    errorLabel.textColor = UIColor.systemRedColor;
    errorLabel.numberOfLines = 0;
    errorLabel.hidden = YES;
    errorLabel.translatesAutoresizingMaskIntoConstraints = NO;
    return errorLabel;
}

-(UILabel *)createAddressBookLabel {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"访问通讯录";
    label.font = [UIFont systemFontOfSize:16.0 weight:UIFontWeightMedium];
    label.textColor = UIColor.systemBlueColor;
    label.userInteractionEnabled = YES;
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openAddressBook)];
    [label addGestureRecognizer:tapGesture];
    return label;
}

-(UITextField *)createUserNameField {
    UITextField *userNameField = [[UITextField alloc] init];
    userNameField.placeholder = @"请输入用户名";
    userNameField.borderStyle = UITextBorderStyleRoundedRect;
    userNameField.font = [UIFont systemFontOfSize:16.0];
    userNameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    userNameField.autocorrectionType = UITextAutocorrectionTypeNo;
    userNameField.layer.borderWidth = 1.0;
    userNameField.layer.borderColor = [UIColor systemGray4Color].CGColor;
    userNameField.layer.cornerRadius = 4.0;
    
    userNameField.tag = 1001;
    userNameField.translatesAutoresizingMaskIntoConstraints = NO;
    return userNameField;
}

-(UITextField *)createPasswordField {
    UITextField *passwordField = [[UITextField alloc] init];
    passwordField.placeholder = @"请输入密码";
    passwordField.borderStyle = UITextBorderStyleRoundedRect;
    passwordField.font = [UIFont systemFontOfSize:16.0];
    passwordField.secureTextEntry = YES;
    passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    passwordField.autocorrectionType = UITextAutocorrectionTypeNo;
    passwordField.layer.borderWidth = 1.0;
    passwordField.layer.borderColor = [UIColor systemGray4Color].CGColor;
    passwordField.layer.cornerRadius = 4.0;
    passwordField.translatesAutoresizingMaskIntoConstraints = NO;
    
    passwordField.tag = 1002;
    
    return passwordField;
}

-(void) setupConstraintsWithUsernameLabel:(UILabel *)usernameLabel
                            usernameField:(UITextField *)usernameField
                            passwordLabel:(UILabel *)passwordLabel
                            passwordField:(UITextField *)passwordField{
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints: @[
        // 用户名标签
        [usernameLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [usernameLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-100],
        
        // 用户名输入框
        [usernameField.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [usernameField.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [usernameField.topAnchor constraintEqualToAnchor:usernameLabel.bottomAnchor constant:8],
        [usernameField.heightAnchor constraintEqualToConstant:44],
        
        // 用户名错误提示
        [self.usernameErrorLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.usernameErrorLabel.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.usernameErrorLabel.topAnchor constraintEqualToAnchor:usernameField.bottomAnchor constant:4],
        
        // 密码标签
        [passwordLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [passwordLabel.topAnchor constraintEqualToAnchor:self.usernameErrorLabel.bottomAnchor constant:20],
        
        // 密码输入框
        [passwordField.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [passwordField.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [passwordField.topAnchor constraintEqualToAnchor:passwordLabel.bottomAnchor constant:8],
        [passwordField.heightAnchor constraintEqualToConstant:44],
        
        // 密码错误提示
        [self.passwordErrorLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.passwordErrorLabel.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.passwordErrorLabel.topAnchor constraintEqualToAnchor:passwordField.bottomAnchor constant:4],
        
        // 访问通讯录
        [self.addressBookLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.addressBookLabel.topAnchor constraintEqualToAnchor:self.passwordErrorLabel.bottomAnchor constant:36]
    ]];
}

#pragma mark - 手势处理
- (void)setupTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO; // 允许其他控件正常接收触摸事件
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)openAddressBook {
    [self dismissKeyboard];
    NSString *phoneNumber = self.usernameField.text ?: @"";
    [Contact presentContactEditorFrom:self phoneNumber:phoneNumber];
}

#pragma mark - 校验方法
- (BOOL)validateUsername:(NSString *)username errorMessage:(NSString **)errorMessage {
    // 空值校验
    if (username.length == 0) {
        if (errorMessage) {
            *errorMessage = @"用户名不能为空";
        }
        return NO;
    }
    
    // 长度校验
    if (username.length >= 32) {
        if (errorMessage) {
            *errorMessage = @"用户名不能超过32个字符";
        }
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword:(NSString *)password errorMessage:(NSString **)errorMessage {
    // 空值校验
    if (password.length == 0) {
        if (errorMessage) {
            *errorMessage = @"密码不能为空";
        }
        return NO;
    }
    
    // 长度校验
    if (password.length >= 32) {
        if (errorMessage) {
            *errorMessage = @"密码不能超过32个字符";
        }
        return NO;
    }
    
    return YES;
}

- (void)showErrorForTextField:(UITextField *)textField errorMessage:(NSString *)errorMessage {
    UILabel *errorLabel = nil;
    if (textField.tag == 1001) {
        errorLabel = self.usernameErrorLabel;
        textField.layer.borderColor = UIColor.systemRedColor.CGColor;
    } else if (textField.tag == 1002) {
        errorLabel = self.passwordErrorLabel;
        textField.layer.borderColor = UIColor.systemRedColor.CGColor;
    }
    
    if (errorLabel) {
        errorLabel.text = errorMessage;
        errorLabel.hidden = NO;
    }
}

- (void)hideErrorForTextField:(UITextField *)textField {
    UILabel *errorLabel = nil;
    if (textField.tag == 1001) {
        errorLabel = self.usernameErrorLabel;
    } else if (textField.tag == 1002) {
        errorLabel = self.passwordErrorLabel;
    }
    
    if (errorLabel) {
        errorLabel.hidden = YES;
    }
    
    // 恢复边框颜色
    textField.layer.borderColor = [UIColor systemGray4Color].CGColor;
}

/// 验证所有输入框，返回是否全部有效
- (BOOL)validateAllFields {
    UITextField *usernameField = [self.view viewWithTag:1001];
    UITextField *passwordField = [self.view viewWithTag:1002];
    
    NSString *username = usernameField.text ?: @"";
    NSString *password = passwordField.text ?: @"";
    
    BOOL isValid = YES;
    NSString *errorMessage = nil;
    
    // 校验用户名
    if (![self validateUsername:username errorMessage:&errorMessage]) {
        [self showErrorForTextField:usernameField errorMessage:errorMessage];
        isValid = NO;
    } else {
        [self hideErrorForTextField:usernameField];
    }
    
    // 校验密码
    if (![self validatePassword:password errorMessage:&errorMessage]) {
        [self showErrorForTextField:passwordField errorMessage:errorMessage];
        isValid = NO;
    } else {
        [self hideErrorForTextField:passwordField];
    }
    
    return isValid;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // 限制最大长度为32
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (newText.length > 32) {
        return NO;
    }
    
    // 输入时清除错误状态
    [self hideErrorForTextField:textField];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // 结束编辑时进行校验
    NSString *text = textField.text ?: @"";
    NSString *errorMessage = nil;
    BOOL isValid = NO;
    
    if (textField.tag == 1001) {
        isValid = [self validateUsername:text errorMessage:&errorMessage];
    } else if (textField.tag == 1002) {
        isValid = [self validatePassword:text errorMessage:&errorMessage];
    }
    
    if (!isValid) {
        [self showErrorForTextField:textField errorMessage:errorMessage];
    }
}

#pragma mark - 获取用户名密码方法
-(NSString *)getUsername {
    return self.usernameField.text ?: @"";
}

-(NSString *)getPassword {
    return self.passwordField.text ?: @"";
}
@end
