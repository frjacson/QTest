//
//  OtherViewController.m
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import "OtherViewController.h"

@interface OtherViewController ()

@property (nonatomic, strong) UILabel *usernameLabel;      // "账号："
@property (nonatomic, strong) UILabel *usernameValueLabel; // 账号的值
@property (nonatomic, strong) UILabel *passwordLabel;      // "密码："
@property (nonatomic, strong) UILabel *passwordValueLabel; // 密码的值
@property (nonatomic, copy) NSString *savedUsername;
@property (nonatomic, copy) NSString *savedPassword;

@end

@implementation OtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self setupUI];
}

- (void)setupUI {
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"这是第二个页面";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:18.0];
    [self.view addSubview:titleLabel];
    
    // 账号标签
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.text = @"账号：";
    self.usernameLabel.font = [UIFont systemFontOfSize:16.0];
    self.usernameLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.usernameLabel];
    
    // 账号值标签
    self.usernameValueLabel = [[UILabel alloc] init];
    self.usernameValueLabel.font = [UIFont systemFontOfSize:16.0];
    self.usernameValueLabel.textColor = UIColor.blackColor;
    self.usernameValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.usernameValueLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.usernameValueLabel];
    
    // 密码标签
    self.passwordLabel = [[UILabel alloc] init];
    self.passwordLabel.text = @"密码：";
    self.passwordLabel.font = [UIFont systemFontOfSize:16.0];
    self.passwordLabel.textColor = UIColor.blackColor;
    [self.view addSubview:self.passwordLabel];
    
    // 密码值标签
    self.passwordValueLabel = [[UILabel alloc] init];
    self.passwordValueLabel.font = [UIFont systemFontOfSize:16.0];
    self.passwordValueLabel.textColor = UIColor.blackColor;
    self.passwordValueLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.passwordValueLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:self.passwordValueLabel];
    
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.usernameValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.passwordValueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    // 创建最大宽度约束（优先级较低，允许在需要时被打破）
    NSLayoutConstraint *usernameValueMaxWidth = [self.usernameValueLabel.widthAnchor constraintLessThanOrEqualToConstant:100];
    usernameValueMaxWidth.priority = UILayoutPriorityDefaultHigh;
    
    NSLayoutConstraint *passwordValueMaxWidth = [self.passwordValueLabel.widthAnchor constraintLessThanOrEqualToConstant:200];
    passwordValueMaxWidth.priority = UILayoutPriorityDefaultHigh;
    
    [NSLayoutConstraint activateConstraints:@[
        // 标题
        [titleLabel.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-60],
        
        // 账号行：标签在左，值在右
        [self.usernameLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.usernameLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:40],
        [self.usernameLabel.widthAnchor constraintEqualToConstant:60], // 固定标签宽度
        
        [self.usernameValueLabel.leadingAnchor constraintEqualToAnchor:self.usernameLabel.trailingAnchor constant:8],
        [self.usernameValueLabel.trailingAnchor constraintLessThanOrEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.usernameValueLabel.topAnchor constraintEqualToAnchor:self.usernameLabel.topAnchor],
        [self.usernameValueLabel.heightAnchor constraintEqualToAnchor:self.usernameLabel.heightAnchor],
        usernameValueMaxWidth, // 最大宽度约束
        
        // 密码行：标签在左，值在右
        [self.passwordLabel.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.passwordLabel.topAnchor constraintEqualToAnchor:self.usernameLabel.bottomAnchor constant:20],
        [self.passwordLabel.widthAnchor constraintEqualToConstant:60], // 固定标签宽度
        
        [self.passwordValueLabel.leadingAnchor constraintEqualToAnchor:self.passwordLabel.trailingAnchor constant:8],
        [self.passwordValueLabel.trailingAnchor constraintLessThanOrEqualToAnchor:safeArea.trailingAnchor constant:-20],
        [self.passwordValueLabel.topAnchor constraintEqualToAnchor:self.passwordLabel.topAnchor],
        [self.passwordValueLabel.heightAnchor constraintEqualToAnchor:self.passwordLabel.heightAnchor],
        passwordValueMaxWidth // 最大宽度约束
    ]];
    
    // 如果有保存的值，更新显示
    if (self.savedUsername || self.savedPassword) {
        [self updateLabels];
    }
}

- (void)updateLabels {
    // 标签保持不变，只更新值
    self.usernameValueLabel.text = self.savedUsername ?: @"";
    self.passwordValueLabel.text = self.savedPassword ?: @"";
}

- (void)setUsername:(NSString *)username password:(NSString *)password {
    // 保存值
    self.savedUsername = username;
    self.savedPassword = password;
    
    // 如果 view 已经加载，立即更新显示
    if (self.viewLoaded) {
        [self updateLabels];
    }
}

@end
