//
//  ThirdViewController.m
//  QTest
//
//  Created by 齐维凯 on 2025/12/21.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    // 使用 UIStackView 实现流式布局（类似 HTML 的从上到下布局）
    [self setupStackViewLayout];
}

- (void)setupStackViewLayout {
    // 创建垂直方向的 StackView（类似 HTML 的从上到下布局）
    UIStackView *verticalStackView = [[UIStackView alloc] init];
    verticalStackView.axis = UILayoutConstraintAxisVertical; // 垂直方向
    verticalStackView.alignment = UIStackViewAlignmentFill; // 填充对齐
    verticalStackView.distribution = UIStackViewDistributionFill; // 填充分布
    verticalStackView.spacing = 20; // 子视图之间的间距
    verticalStackView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // 创建标题标签
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"这是第三个页面";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0];
    titleLabel.textColor = UIColor.blackColor;
    
    // 创建横向布局的 StackView（一行布局）
    UIStackView *horizontalStackView = [[UIStackView alloc] init];
    horizontalStackView.axis = UILayoutConstraintAxisHorizontal; // 横向方向（一行）
    horizontalStackView.alignment = UIStackViewAlignmentCenter; // 居中对齐
    horizontalStackView.distribution = UIStackViewDistributionFillEqually; // 等分分布
    horizontalStackView.spacing = 10; // 子视图之间的间距
    
    // 创建横向布局的示例视图
    UILabel *leftLabel = [[UILabel alloc] init];
    leftLabel.text = @"左侧";
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.backgroundColor = UIColor.systemBlueColor;
    leftLabel.textColor = UIColor.whiteColor;
    leftLabel.layer.cornerRadius = 4;
    leftLabel.clipsToBounds = YES;
    
    UILabel *middleLabel = [[UILabel alloc] init];
    middleLabel.text = @"中间";
    middleLabel.textAlignment = NSTextAlignmentCenter;
    middleLabel.backgroundColor = UIColor.systemGreenColor;
    middleLabel.textColor = UIColor.whiteColor;
    middleLabel.layer.cornerRadius = 4;
    middleLabel.clipsToBounds = YES;
    
    UILabel *rightLabel = [[UILabel alloc] init];
    rightLabel.text = @"右侧";
    rightLabel.textAlignment = NSTextAlignmentCenter;
    rightLabel.backgroundColor = UIColor.systemOrangeColor;
    rightLabel.textColor = UIColor.whiteColor;
    rightLabel.layer.cornerRadius = 4;
    rightLabel.clipsToBounds = YES;
    
    // 将视图添加到横向 StackView 中（会按照添加顺序从左到右排列）
    [horizontalStackView addArrangedSubview:leftLabel];
    [horizontalStackView addArrangedSubview:middleLabel];
    [horizontalStackView addArrangedSubview:rightLabel];
    
    // 创建内容标签
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"这是使用 UIStackView 实现的流式布局，支持垂直和横向布局";
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.font = [UIFont systemFontOfSize:16.0];
    contentLabel.textColor = UIColor.darkGrayColor;
    contentLabel.numberOfLines = 0; // 允许多行显示
    
    // 将视图添加到垂直 StackView 中（会按照添加顺序从上到下排列）
    [verticalStackView addArrangedSubview:titleLabel];
    [verticalStackView addArrangedSubview:horizontalStackView]; // 嵌套横向布局
    [verticalStackView addArrangedSubview:contentLabel];
    
    // 将 StackView 添加到主视图
    [self.view addSubview:verticalStackView];
    
    // 设置 StackView 的约束（只需要设置 StackView 的位置和大小）
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [verticalStackView.topAnchor constraintEqualToAnchor:safeArea.topAnchor constant:40],
        [verticalStackView.leadingAnchor constraintEqualToAnchor:safeArea.leadingAnchor constant:20],
        [verticalStackView.trailingAnchor constraintEqualToAnchor:safeArea.trailingAnchor constant:-20],
        // 不需要设置 bottom，让它根据内容自动调整高度
    ]];
    
    // 设置横向 StackView 的高度约束
    [NSLayoutConstraint activateConstraints:@[
        [horizontalStackView.heightAnchor constraintEqualToConstant:50]
    ]];
}

@end
