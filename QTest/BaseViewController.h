//
//  BaseViewController.h
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController

/// 中间的容器，对子类开放
@property (nonatomic, strong, readonly) UIView *contentContainerView;

/// 底部确认按钮
@property (nonatomic, strong, readonly) UIButton *confirmButton;

/// 设置标题
-(void)configureTitle:(NSString *)title;

/// 切换中间内容，view或者controller
-(void)switchToContentView:(UIView *)contentView;
-(void)switchToContentViewController:(UIViewController *)viewController;

/// 确认点击按钮
-(void)confirmButtonTapped;

/// 隐藏/显示确认按钮
-(void)setConfirmButtonHidden:(BOOL)hidden;

/// 隐藏/显示退出按钮
-(void)setExitButtonHidden:(BOOL)hidden;

/// 设置确认按钮的标题
-(void)setConfirmButtonTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
