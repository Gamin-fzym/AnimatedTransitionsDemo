//
//  GATransitionPresentation.m
//  NewDemo
//
//  Created by shuangba on 2019/11/7.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import "GATransitionPresentation.h"
#import "GATransitionInteractive.h"

@interface GATransitionPresentation ()

@property (nonatomic, strong) GATransitionAnimate *animate;
@property (nonatomic, strong) UIView *dismissView;
@property (nonatomic, strong) UIView *replacePresentView;

@end

@implementation GATransitionPresentation

- (GATransitionAnimate *)animate {
    if (!_animate) {
        _animate = [GATransitionAnimate new];
    }
    _animate.animateType = self.animateType;
    return _animate;
}

/// present将要执行
- (void)presentationTransitionWillBegin {
    self.replacePresentView = [[UIView alloc] initWithFrame:[self frameOfPresentedViewInContainerView]];
    self.replacePresentView.layer.cornerRadius = 16;
    self.replacePresentView.layer.shadowOpacity = 0.44f;
    self.replacePresentView.layer.shadowRadius = 13.f;
    self.replacePresentView.layer.shadowOffset = CGSizeMake(0, -6.f);
    UIView *presentedView = [super presentedView];
    presentedView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.replacePresentView addSubview:presentedView];
    
    UIView *dismissView = [[UIView alloc] initWithFrame:self.containerView.bounds];
    [self.containerView addSubview:dismissView];
    self.dismissView = dismissView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction)];
    [self.dismissView addGestureRecognizer:tap];
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    
    self.dismissView.alpha = 0.f;
    self.dismissView.backgroundColor = [UIColor blackColor];
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dismissView.alpha = 0.5f;
    } completion:NULL];
}

/// present执行结束
- (void)presentationTransitionDidEnd:(BOOL)completed {
    if (!completed) {
        self.dismissView = nil;
    }
}

/// dismiss将要执行
- (void)dismissalTransitionWillBegin {
    id <UIViewControllerTransitionCoordinator> transitionCoordinator = self.presentingViewController.transitionCoordinator;
    [transitionCoordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        self.dismissView.alpha = 0.f;
    } completion:NULL];
}

/// dismiss执行结束
- (void)dismissalTransitionDidEnd:(BOOL)completed {
    if (completed == YES) {
        self.dismissView = nil;
    }
}

- (UIView *)presentedView {
    return self.replacePresentView;
}

- (void)tapGestureAction {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.animate;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.animate;
}

- (nullable UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(nullable UIViewController *)presenting sourceViewController:(UIViewController *)source {
    NSAssert(self.presentedViewController == presented, @"You didn't initialize %@ with the correct presentedViewController.  Expected %@, got %@.",
             self, presented, self.presentedViewController);
    return self;
}

@end
