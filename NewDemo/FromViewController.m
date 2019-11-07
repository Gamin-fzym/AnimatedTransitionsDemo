//
//  FromViewController.m
//  NewDemo
//
//  Created by shuangba on 2019/10/28.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import "FromViewController.h"
#import "ToViewController.h"
#import "GATransitionPresentation.h"

@interface FromViewController () 

@end

@implementation FromViewController

- (IBAction)tapButtonAction:(id)sender {
    UIButton *tempBut = (UIButton *)sender;
    if (tempBut.tag == 1000) {
        /* 导航转场 */
        ToViewController *toVC = [[ToViewController alloc] initWithNibName:@"ToViewController" bundle:nil];
        // 设置导航转场协议
        self.navigationController.delegate = self;
        // 转场动画类型
        self.animateType = OpenAnimateType;
        [self.navigationController pushViewController:toVC animated:YES];
        
    } else if (tempBut.tag == 1001) {
        /* 模态转场 */
        ToViewController *toVC = [[ToViewController alloc] initWithNibName:@"ToViewController" bundle:nil];
        // 自定义转场仅限于modalPresentationStyle属性为UIModalPresentationFullScreen 或 UIModalPresentationCustom这两种模式
        toVC.modalPresentationStyle = UIModalPresentationFullScreen;
        // 使用自定义转场后modalTransitionStyle设置无效
        // toVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        // 设置模态转场协议
        toVC.transitioningDelegate = self;
        // 转场动画类型
        self.animateType = CircleAnimateType;
        [self presentViewController:toVC animated:YES completion:nil];
        
    } else if (tempBut.tag == 1002) {
        /* 底部卡片转场 */
        ToViewController *toVC = [[ToViewController alloc] initWithNibName:@"ToViewController" bundle:nil];
        toVC.modalPresentationStyle = UIModalPresentationCustom;
        
        GATransitionPresentation *presentation = [[GATransitionPresentation alloc] initWithPresentedViewController:toVC presentingViewController:self];
        presentation.animateType = CardAnimateType;
        toVC.transitioningDelegate = presentation;
        
        [self presentViewController:toVC animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"InfoVC";
    /* 侧滑转场 */
    UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    gesture.edges = UIRectEdgeRight;
    [self.view addGestureRecognizer:gesture];
}

- (void)panGestureAction:(UIScreenEdgePanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.gestureRecognizer = gesture;
        self.targetEdge = UIRectEdgeRight;
        ToViewController *toVC = [[ToViewController alloc] initWithNibName:@"ToViewController" bundle:nil];
        toVC.modalPresentationStyle = UIModalPresentationFullScreen;
        toVC.transitioningDelegate = self;
        self.animateType = SwipeAnimateType;
        [self presentViewController:toVC animated:YES completion:nil];
    }
}

@end
