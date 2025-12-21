//
//  Toast.m
//  QTest
//
//  Created on 2025/12/21.
//

#import "Toast.h"

@interface ToastView : UIView

@property (nonatomic, strong) UILabel *messageLabel;

@end

@implementation ToastView

- (instancetype)initWithMessage:(NSString *)message {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        self.layer.cornerRadius = 8.0;
        self.layer.masksToBounds = YES;
        
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.text = message;
        self.messageLabel.textColor = UIColor.whiteColor;
        self.messageLabel.font = [UIFont systemFontOfSize:14.0];
        self.messageLabel.textAlignment = NSTextAlignmentCenter;
        self.messageLabel.numberOfLines = 0;
        self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self addSubview:self.messageLabel];
        
        [NSLayoutConstraint activateConstraints:@[
            [self.messageLabel.topAnchor constraintEqualToAnchor:self.topAnchor constant:12],
            [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:16],
            [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-16],
            [self.messageLabel.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-12]
        ]];
    }
    return self;
}

@end

@implementation Toast

+ (void)showToast:(NSString *)message {
    [self showToast:message position:ToastPositionCenter duration:2.0];
}

+ (void)showToast:(NSString *)message position:(ToastPosition)position {
    [self showToast:message position:position duration:2.0];
}

+ (void)showToast:(NSString *)message position:(ToastPosition)position duration:(NSTimeInterval)duration {
    if (!message || message.length == 0) {
        return;
    }
    
    // 获取当前最顶层的窗口
    UIWindow *window = [self getKeyWindow];
    if (!window) {
        return;
    }
    
    // 创建 Toast 视图
    ToastView *toastView = [[ToastView alloc] initWithMessage:message];
    toastView.translatesAutoresizingMaskIntoConstraints = NO;
    toastView.alpha = 0;
    
    [window addSubview:toastView];
    
    // 设置约束
    UILayoutGuide *safeArea = window.safeAreaLayoutGuide;
    NSLayoutConstraint *centerYConstraint;
    
    switch (position) {
        case ToastPositionTop:
            centerYConstraint = [toastView.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:80];
            break;
        case ToastPositionCenter:
            centerYConstraint = [toastView.centerYAnchor constraintEqualToAnchor:window.centerYAnchor];
            break;
        case ToastPositionBottom:
            centerYConstraint = [toastView.bottomAnchor constraintEqualToAnchor:safeArea.bottomAnchor constant:-80];
            break;
    }
    
    [NSLayoutConstraint activateConstraints:@[
        [toastView.centerXAnchor constraintEqualToAnchor:window.centerXAnchor],
        centerYConstraint,
        [toastView.leadingAnchor constraintGreaterThanOrEqualToAnchor:window.leadingAnchor constant:40],
        [toastView.trailingAnchor constraintLessThanOrEqualToAnchor:window.trailingAnchor constant:-40],
        [toastView.widthAnchor constraintLessThanOrEqualToConstant:280]
    ]];
    
    // 动画显示
    [UIView animateWithDuration:0.3 animations:^{
        toastView.alpha = 1.0;
    } completion:^(BOOL finished) {
        // 延迟消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.3 animations:^{
                toastView.alpha = 0;
            } completion:^(BOOL finished) {
                [toastView removeFromSuperview];
            }];
        });
    }];
}

+ (UIWindow *)getKeyWindow {
    UIWindow *keyWindow = nil;
    
    if (@available(iOS 13.0, *)) {
        // iOS 13+ 使用场景窗口
        NSSet<UIScene *> *connectedScenes = [UIApplication sharedApplication].connectedScenes;
        for (UIScene *scene in connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *windowScene = (UIWindowScene *)scene;
                if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                    for (UIWindow *window in windowScene.windows) {
                        if (window.isKeyWindow) {
                            keyWindow = window;
                            break;
                        }
                    }
                    // 如果没找到 keyWindow，使用第一个窗口
                    if (!keyWindow && windowScene.windows.count > 0) {
                        keyWindow = windowScene.windows.firstObject;
                    }
                }
            }
        }
    } else {
        // iOS 13 以下直接获取 keyWindow
        keyWindow = [UIApplication sharedApplication].keyWindow;
        
        // 如果还是没找到，使用 windows 数组的第一个（iOS 13 以下才使用）
        if (!keyWindow) {
            NSArray *windows = [UIApplication sharedApplication].windows;
            if (windows.count > 0) {
                keyWindow = windows[0];
            }
        }
    }
    
    return keyWindow;
}

@end

