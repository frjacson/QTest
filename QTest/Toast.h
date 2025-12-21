//
//  Toast.h
//  QTest
//
//  Created on 2025/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ToastPosition) {
    ToastPositionTop,      // 顶部
    ToastPositionCenter,   // 中间
    ToastPositionBottom    // 底部
};

@interface Toast : NSObject

/// 显示 Toast 提示
/// @param message 提示信息
+ (void)showToast:(NSString *)message;

/// 显示 Toast 提示（自定义位置）
/// @param message 提示信息
/// @param position 显示位置
+ (void)showToast:(NSString *)message position:(ToastPosition)position;

/// 显示 Toast 提示（完整参数）
/// @param message 提示信息
/// @param position 显示位置
/// @param duration 显示时长（秒）
+ (void)showToast:(NSString *)message position:(ToastPosition)position duration:(NSTimeInterval)duration;

@end

NS_ASSUME_NONNULL_END

