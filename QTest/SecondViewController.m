//
//  SecondViewController.m
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import "BaseViewController.h"
#import "DemoViewController.h"
#import "OtherViewController.h"
#import "ThirdViewController.h"
#import "Toast.h"

@interface SecondViewController : BaseViewController

@property (nonatomic, strong) DemoViewController *initialContentVC;
@property (nonatomic, strong) OtherViewController *secondPageVC;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureTitle:@"保存"];
    
    self.initialContentVC = [[DemoViewController alloc] init];
    [self switchToContentViewController:self.initialContentVC];
}

-(void)confirmButtonTapped {
    // 通过检查子视图控制器来判断当前页面
    NSArray *childViewControllers = self.childViewControllers;
    UIViewController *currentVC = childViewControllers.lastObject;
    
    // 判断当前是在第一个页面还是第二个页面
    if ([currentVC isKindOfClass:[DemoViewController class]]) {
        // 在第一个页面，点击"确认"跳转到第二个页面
        NSLog(@"点击确认，提交订单");
        
        // 先进行校验
        if (![self.initialContentVC validateAllFields]) {
            [Toast showToast:@"请检查输入内容"];
            return;
        }
        
        // 获取用户名和密码
        NSString *username = [self.initialContentVC getUsername];
        NSString *password = [self.initialContentVC getPassword];
        
        // 切换到第二个页面
        self.secondPageVC = [[OtherViewController alloc] init];
        
        // 传递用户名和密码
        [self.secondPageVC setUsername:username password:password];
        
        [self switchToContentViewController:self.secondPageVC];
        
        // 修改标题为"第二个页面"
        [self configureTitle:@"第二个页面"];
        
        // 更改确认按钮文案为"下一页"
        [self setConfirmButtonTitle:@"下一页"];
        
        // 显示退出按钮（图标）
        [self setExitButtonHidden:NO];
        
    } else if ([currentVC isKindOfClass:[OtherViewController class]]) {
        // 在第二个页面，点击"下一页"跳转到第三个页面
        NSLog(@"点击下一页，跳转到第三个页面");
        
        ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
        [self switchToContentViewController:thirdVC];
        
        // 修改标题为"第三个页面"
        [self configureTitle:@"第三个页面"];
        
        // 隐藏确认按钮（第三个页面不需要底部按钮）
        [self setConfirmButtonHidden:YES];
    }
}

- (void)exitAction {
    // 判断当前是在第三个页面还是第二个页面
    // 通过检查 secondPageVC 是否存在来判断
    if (self.secondPageVC) {
        // 如果在第三个页面，返回到第二个页面
        // 通过判断当前显示的是否是 ThirdViewController（简单判断：如果存在 secondPageVC 且当前标题是"第三个页面"）
        // 更可靠的方式是检查当前子视图控制器
        NSArray *childViewControllers = self.childViewControllers;
        BOOL isOnThirdPage = NO;
        for (UIViewController *childVC in childViewControllers) {
            if ([childVC isKindOfClass:[ThirdViewController class]]) {
                isOnThirdPage = YES;
                break;
            }
        }
        
        // 恢复确认按钮（第三个页面不需要底部按钮）
        [self setConfirmButtonHidden:NO];
        
        if (isOnThirdPage) {
            // 在第三个页面，返回到第二个页面
            [self switchToContentViewController:self.secondPageVC];
            [self configureTitle:@"第二个页面"];
            [self setConfirmButtonTitle:@"下一页"];
        } else {
            // 在第二个页面，返回到第一个页面
            [self switchToContentViewController:self.initialContentVC];
            [self configureTitle:@"保存"];
            [self setConfirmButtonTitle:@"确认"];
            self.secondPageVC = nil; // 清空第二个页面的引用
            [self setExitButtonHidden:YES];
        }
    } else {
        // 在第一个页面，不应该有退出按钮，但如果被调用，返回到初始页面
        if (self.initialContentVC) {
            [self switchToContentViewController:self.initialContentVC];
        }
        [self configureTitle:@"保存"];
        [self setConfirmButtonTitle:@"确认"];
        [self setExitButtonHidden:YES];
    }
}

@end
