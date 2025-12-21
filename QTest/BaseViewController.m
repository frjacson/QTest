//
//  BaseViewController.m
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (nonatomic, strong) UIView *contentContainerView;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIViewController *currentContentVC;
@property (nonatomic, strong) NSLayoutConstraint *contentContainerBottomConstraint;
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setupConfirmButton];
    [self setupNavigationBar];
    [self setupConfirmButton];
    [self setupContentContainer];
}

#pragma mark - Navigation
-(void)setupNavigationBar {
    // 默认不显示退出按钮，只有进入 OtherViewController 时才显示
    self.navigationItem.leftBarButtonItem = nil;
}

-(void)configureTitle:(NSString *)title {
    self.title = title;
}

-(void)exitAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setExitButtonHidden:(BOOL)hidden {
    if (hidden) {
        self.navigationItem.leftBarButtonItem = nil;
    } else {
        // 使用 SF Symbols 的左箭头图标（chevron.left）
        UIImage *exitImage = [UIImage systemImageNamed:@"chevron.left"];
        // 设置为模板模式以便应用颜色
        exitImage = [exitImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIBarButtonItem *exitItem = [[UIBarButtonItem alloc] initWithImage:exitImage 
                                                                      style:UIBarButtonItemStylePlain 
                                                                     target:self 
                                                                     action:@selector(exitAction)];
        // 设置浅黑色
        exitItem.tintColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        self.navigationItem.leftBarButtonItem = exitItem;
    }
}

#pragma mark - Bottom Button
-(void)setupConfirmButton {
    self.confirmButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.confirmButton.backgroundColor = UIColor.systemBlueColor;
    self.confirmButton.layer.cornerRadius = 8;
    self.confirmButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    
    [self.confirmButton addTarget:self
                           action:@selector(confirmButtonAction)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.confirmButton];
    self.confirmButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
        [self.confirmButton.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:16],
        [self.confirmButton.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-16],
        [self.confirmButton.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-12],
        [self.confirmButton.heightAnchor constraintEqualToConstant:48]
    ]];
}

- (void)confirmButtonAction {
    [self confirmButtonTapped];
}

- (void)confirmButtonTapped {
    // 子类重写
}

- (void)setConfirmButtonHidden:(BOOL)hidden {
    self.confirmButton.hidden = hidden;
    
    // 更新 contentContainerView 的底部约束
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    [self.contentContainerBottomConstraint setActive:NO];
    
    if (hidden) {
        // 隐藏按钮时，约束到底部安全区域
        self.contentContainerBottomConstraint = [self.contentContainerView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor];
    } else {
        // 显示按钮时，约束到按钮顶部
        self.contentContainerBottomConstraint = [self.contentContainerView.bottomAnchor constraintEqualToAnchor:self.confirmButton.topAnchor constant:-12];
    }
    
    [self.contentContainerBottomConstraint setActive:YES];
}

- (void)setConfirmButtonTitle:(NSString *)title {
    [self.confirmButton setTitle:title ?: @"确认" forState:UIControlStateNormal];
}

#pragma mark - Content Container

- (void)setupContentContainer {
    self.contentContainerView = [[UIView alloc] init];
    self.contentContainerView.backgroundColor = UIColor.systemGroupedBackgroundColor;
    
    [self.view addSubview:self.contentContainerView];
    self.contentContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    // 保存底部约束，以便后续可以修改
    self.contentContainerBottomConstraint = [self.contentContainerView.bottomAnchor constraintEqualToAnchor:self.confirmButton.topAnchor constant:-12];
    
    [NSLayoutConstraint activateConstraints:@[
        [self.contentContainerView.topAnchor constraintEqualToAnchor:safeArea.topAnchor],
        [self.contentContainerView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor],
        [self.contentContainerView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor],
        self.contentContainerBottomConstraint
    ]];
}

#pragma mark - Content Switch

/// 纯 View（轻量）
- (void)switchToContentView:(UIView *)contentView {
    [self.contentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentContainerView addSubview:contentView];
    
    [NSLayoutConstraint activateConstraints:@[
        [contentView.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [contentView.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [contentView.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [contentView.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor]
    ]];
}

/// 子 ViewController（推荐）
- (void)switchToContentViewController:(UIViewController *)viewController {
    if (self.currentContentVC) {
        [self.currentContentVC willMoveToParentViewController:nil];
        [self.currentContentVC.view removeFromSuperview];
        [self.currentContentVC removeFromParentViewController];
    }
    
    self.currentContentVC = viewController;
    
    [self addChildViewController:viewController];
    [self.contentContainerView addSubview:viewController.view];
    
    viewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [NSLayoutConstraint activateConstraints:@[
        [viewController.view.topAnchor constraintEqualToAnchor:self.contentContainerView.topAnchor],
        [viewController.view.leadingAnchor constraintEqualToAnchor:self.contentContainerView.leadingAnchor],
        [viewController.view.trailingAnchor constraintEqualToAnchor:self.contentContainerView.trailingAnchor],
        [viewController.view.bottomAnchor constraintEqualToAnchor:self.contentContainerView.bottomAnchor]
    ]];
    
    [viewController didMoveToParentViewController:self];
}

@end
