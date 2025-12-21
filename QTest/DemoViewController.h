//
//  DemoViewController.h
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoViewController : UIViewController
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

/// 获取用户名
- (NSString *)getUsername;

/// 获取密码
- (NSString *)getPassword;

/// 验证所有输入框，返回是否全部有效
- (BOOL)validateAllFields;

@end

NS_ASSUME_NONNULL_END
