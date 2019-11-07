//
//  GATransitionViewController.m
//  NewDemo
//
//  Created by shuangba on 2019/11/6.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import "GATransitionViewController.h"
#import "GATransitionInteractive.h"

@interface GATransitionViewController () 

@property (nonatomic, strong) GATransitionAnimate *animate;

@end

@implementation GATransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (GATransitionAnimate *)animate {
    if (!_animate) {
        _animate = [GATransitionAnimate new];
    }
    _animate.animateType = self.animateType;
    return _animate;
}

#pragma mark - 导航Push/Pop转场协议 UINavigationControllerDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.animate.isPop = NO;
    } else if (operation == UINavigationControllerOperationPop) {
        self.animate.isPop = YES;
    }
    return self.animate;
}

#pragma mark - 转场协议 UIViewControllerTransitioningDelegate

// Present过程中返回一个遵守 <UIViewControllerAnimatedTransitioning> 协议的对象，也就是实现动画过程的对象
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.animate;
}

// dismiss过程中返回一个遵守 <UIViewControllerAnimatedTransitioning> 协议的对象，也就是实现动画过程的对象
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animate;
}

#pragma mark - 转场协议 涉及手势交互才需要实现下面的协议方法

// 如果delegate实现了此方法，在转场过程中会调用，可根据是否有手势来判断是否返回交互控制对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.gestureRecognizer) {
        return [[GATransitionInteractive alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    }
    return nil;
}

// 如果delegate实现了此方法，在转场过程中会调用，可根据是否有手势来判断是否返回交互控制对象
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator {
    if (self.gestureRecognizer) {
        return [[GATransitionInteractive alloc] initWithGestureRecognizer:self.gestureRecognizer edgeForDragging:self.targetEdge];
    }
    return nil;
}

/**
 返回一个UIPresentationController的子类对象，UIPresentationController，提供了四个函数来定义present和dismiss动画开始前后的操作：
    1、presentationTransitionWillBegin:   present将要执行时
    2、presentationTransitionDidEnd：    present执行结束后
    3、dismissalTransitionWillBegin：     dismiss将要执行时
    4、dismissalTransitionDidEnd：        dismiss执行结束后
*/
- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source NS_AVAILABLE_IOS(8_0) {
    return nil;
}

@end
