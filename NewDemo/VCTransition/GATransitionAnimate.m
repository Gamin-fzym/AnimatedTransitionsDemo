//
//  GATransitionAnimate.m
//  NewDemo
//
//  Created by shuangba on 2019/11/6.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import "GATransitionAnimate.h"
#import "FromViewController.h"

@interface GATransitionAnimate () <CAAnimationDelegate>

// CircleAnimateType时使用
@property (nonatomic, assign) BOOL isPresentOrDismiss; 

@end

@implementation GATransitionAnimate

#pragma mark - 动画协议 UIViewControllerAnimatedTransitioning

// 返回动画执行的时长
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

// 这个方法中添加转场动画
// 如果转换是交互式的，而不是百分比驱动的交互式转换，则此方法只能是nop(空操作)。
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    switch (self.animateType) {
        case NoneAnimateType: {
            [self noneAnimateTransition:transitionContext];
            break;
        }
        case FadeAnimateType: {
            [self fadeAnimateTransition:transitionContext];
            break;
        }
        case SwipeAnimateType: {
            [self swipeAnimateTransition:transitionContext];
            break;
        }
        case PopupAnimateType: {
            [self popupAnimateTransition:transitionContext];
            break;
        }
        case CircleAnimateType: {
            [self circleAnimateTransition:transitionContext];
            break;
        }
        case CardAnimateType: {
            [self cardAnimateTransition:transitionContext];
            break;
        }
        case OpenAnimateType: {
            [self openAnimateTransition:transitionContext];
            break;
        }
        default: {
            [self noneAnimateTransition:transitionContext];
            break;
        }
    }
}

#pragma mark - 没有动画

- (void)noneAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    fromView.frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:toView];
        
    BOOL cancelTransition = [transitionContext transitionWasCancelled];
    [transitionContext completeTransition:!cancelTransition];
}

#pragma mark - 渐显动画

- (void)fadeAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 获取当前上下文的容器
    UIView *containerView = [transitionContext containerView];
    // fromViewController
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    // toViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    fromView.frame = [transitionContext initialFrameForViewController:fromVC];
    toView.frame = [transitionContext finalFrameForViewController:toVC];
    [containerView addSubview:toView];
    
    NSTimeInterval time = [self transitionDuration:transitionContext];
    fromView.alpha = 1;
    toView.alpha = 0;
    [UIView animateWithDuration:time animations:^{
        fromView.alpha = 0;
        toView.alpha = 1;
    } completion:^(BOOL finished) {
        // transitionWasCancelled 这个方法判断转场是否已经取消了，下面的completeTransition设置转场完成
        // 动画结束后一定要调用completeTransition方法 来完成或取消转场
        BOOL cancelTransition = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancelTransition];
    }];
}

#pragma mark - 侧滑动画

- (void)swipeAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect fromFrame = [transitionContext initialFrameForViewController:fromVC];
    CGRect toFrame = [transitionContext finalFrameForViewController:toVC];
    
    BOOL presented = NO; // 为present 或者dismiss
    if (toVC.presentingViewController == fromVC) {
        presented = YES;
    }
    // CGVector offset;
    if (presented) {    // 从右往左
        // offset = CGVectorMake(-1, 0);
        fromView.frame = fromFrame;
        toView.frame = CGRectOffset(toFrame, toFrame.size.width, 0);
        [containerView addSubview:toView];
    } else {            // 从左往右
        // offset = CGVectorMake(1, 0);
        fromView.frame = fromFrame;
        toView.frame = toFrame;
        [containerView insertSubview:toView belowSubview:fromView];
    }
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:interval animations:^{
        if (presented) {
            toView.frame = toFrame;
        } else {
            fromView.frame = CGRectOffset(fromFrame, fromFrame.size.width, 0);
        }
    } completion:^(BOOL finished) {
        BOOL canceled = [transitionContext transitionWasCancelled];
        if (canceled) {
            [toView removeFromSuperview];
        }
        [transitionContext completeTransition:!canceled];
    }];
}

#pragma mark - 弹性Pop动画

- (void)popupAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL present = (toVC.presentingViewController == fromVC);
    UIView *tempView = nil;
    if (present) {
        tempView = [fromVC.view snapshotViewAfterScreenUpdates:NO];
        tempView.frame = fromVC.view.frame;
        fromVC.view.hidden = YES;
        [containerView addSubview:tempView];
        [containerView addSubview:toVC.view];
        toVC.view.frame = CGRectMake(0, containerView.frame.size.height, containerView.frame.size.width, 400);
    } else {
        // 参照present动画的逻辑，present成功后，containerView的最后一个子视图就是截图视图，我们将其取出准备动画
        NSArray *subviewsArray = containerView.subviews;
        tempView = subviewsArray[MIN(subviewsArray.count, MAX(0, subviewsArray.count - 2))];
    }
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    if (present) {
        [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:1.0 / 0.55 options:0 animations:^{
            tempView.transform = CGAffineTransformMakeScale(0.85, 0.85);
            toVC.view.transform = CGAffineTransformMakeTranslation(0, -400);
        } completion:^(BOOL finished) {
            BOOL cancel = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!cancel];
            if (cancel) {
                fromVC.view.hidden = NO;
                [tempView removeFromSuperview];
            }
        }];
    } else {
        [UIView animateWithDuration:duration animations:^{
            fromVC.view.transform = CGAffineTransformIdentity;
            tempView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            BOOL cancel = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!cancel];
            if (!cancel) {
                toVC.view.hidden = NO;
                [tempView removeFromSuperview];
            }
        }];
    }
}

#pragma mark - 扩散圆动画

- (void)circleAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    BOOL present = (toVC.presentingViewController == fromVC);
    if (present) {  // present
        [self presentViewControllerWithTransition:transitionContext];
    } else {        // dismiss
        [self dismissViewControllerWithTransition:transitionContext];
    }
}

- (void)presentViewControllerWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UINavigationController *navVc = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    FromViewController *fromVC = navVc.viewControllers.lastObject;
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    UIBezierPath *startCircle = [UIBezierPath bezierPathWithOvalInRect:fromVC.modelBut.frame];
    // sqrtf 求平方根函数  pow求次方函数，这里的意思是求X的2次方，要是pow(m,9)就是求m的9次方
    CGFloat radius = sqrtf(pow(containerView.frame.size.width, 2) + pow(containerView.frame.size.height, 2));
    UIBezierPath *endCircle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = endCircle.CGPath;
    toVC.view.layer.mask = maskLayer;
    // 创建路径动画
    CABasicAnimation * maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate = self;
    // 动画是加到layer上的，所以必须为CGPath，再将CGPath桥接为OC对象
    maskLayerAnimation.fromValue = (__bridge id)(startCircle.CGPath);
    maskLayerAnimation.toValue   = (__bridge id)((endCircle.CGPath));
    maskLayerAnimation.duration  = [self transitionDuration:transitionContext];
    // 速度控制函数
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    // 添加动画
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

- (void)dismissViewControllerWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toViewController = (UINavigationController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    FromViewController *tempViewController = toViewController.viewControllers.lastObject;
    UIView *containerView = [transitionContext containerView];
    // 当modalPresentationStyle = UIModalPresentationCustom 时不用添加fromViewController.view，因为视图不会被移除, 为UIModalPresentationFullScreen 时需要添加，否则背景是黑的
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    // 画两个圆路径，这里的结束和开始时候的画的圆的道理和present的时候正好是相反的
    CGFloat radius = sqrtf(containerView.frame.size.height * containerView.frame.size.height + containerView.frame.size.width * containerView.frame.size.width) / 2;
    UIBezierPath *startCycle = [UIBezierPath bezierPathWithArcCenter:containerView.center radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    // 结束的就是tempViewController.presentNextController.frame的大小
    UIBezierPath *endCycle = [UIBezierPath bezierPathWithOvalInRect:tempViewController.modelBut.frame];
    
    // 创建CAShapeLayer
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    // maskLayer.fillColor = [UIColor greenColor].CGColor;
    maskLayer.path = endCycle.CGPath;
    fromViewController.view.layer.mask = maskLayer;
    
    // 创建路径动画
    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.delegate  = self;
    maskLayerAnimation.fromValue = (__bridge id)(startCycle.CGPath);
    maskLayerAnimation.toValue   = (__bridge id)((endCycle.CGPath));
    maskLayerAnimation.duration  = [self transitionDuration:transitionContext];
    
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [maskLayerAnimation setValue:transitionContext forKey:@"transitionContext"];
    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}

/*
 Called when the animation either completes its active duration or
 is removed from the object it is attached to (i.e. the layer). 'flag'
 is true if the animation reached the end of its active duration
 without being removed.
 当动画结束其有效持续时间 或 从其附加对象（即图层）中删除。
 如果动画已达到其有效持续时间的结尾,没有被删除,'flag'则为true。
 */
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (_isPresentOrDismiss) {
        // 标记转场结束
        id <UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
        [transitionContext completeTransition:YES];
    } else {
        id <UIViewControllerContextTransitioning> transitionContext = [anim valueForKey:@"transitionContext"];
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        if ([transitionContext transitionWasCancelled]) {
            [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
        }
    }
}

#pragma mark - 底部卡片动画

- (void)cardAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    [containerView addSubview:toView];
    
    BOOL present = (toVC.presentingViewController == fromVC) ? YES : NO;
    if (present) {
        toView.frame = CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, 420);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.frame = CGRectMake(0, containerView.bounds.size.height - 420, containerView.bounds.size.width, 420);
        } completion:^(BOOL finished) {
            BOOL cancel = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!cancel];
        }];
    } else {
        fromView.frame = CGRectMake(0, containerView.bounds.size.height - 420, containerView.bounds.size.width, 420);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.frame = CGRectMake(0, containerView.bounds.size.height, containerView.bounds.size.width, 420);
        } completion:^(BOOL finished) {
            BOOL cancel = [transitionContext transitionWasCancelled];
            [transitionContext completeTransition:!cancel];
        }];
    }
}

#pragma mark - Push/Pop开门动画

- (void)openAnimateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    if (!self.isPop) {
        [self pushWithTransition:transitionContext];
    } else {
        [self popWithTransition:transitionContext];
    }
}

- (void)pushWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *leftFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    leftFromView.frame = fromView.frame;
    UIView *rightFromView = [fromView snapshotViewAfterScreenUpdates:NO];
    rightFromView.frame = CGRectMake(-fromView.frame.size.width/2, 0, fromView.frame.size.width, fromView.frame.size.height);
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    leftView.clipsToBounds = YES;
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [leftView addSubview:leftFromView];
    [rightView addSubview:rightFromView];
    [containerView addSubview:toView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    NSTimeInterval interval = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:interval animations:^{
        leftView.frame = CGRectMake(-fromView.frame.size.width/2, 0, fromView.frame.size.width/2, fromView.frame.size.height);
        rightView.frame = CGRectMake(fromView.frame.size.width, 0, fromView.frame.size.width/2, fromView.frame.size.height);
    } completion:^(BOOL finished) {
        BOOL cancel = [transitionContext transitionWasCancelled];
        [transitionContext completeTransition:!cancel];
        if (!cancel) {
            [leftView removeFromSuperview];
            [rightView removeFromSuperview];
        }
    }];
}

- (void)popWithTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    // 左侧动画视图
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height)];
    leftView.clipsToBounds = YES;
    [leftView addSubview:toView];
    
    // 右侧动画视图
    // 使用系统自带的snapshotViewAfterScreenUpdates:方法，参数为YES，代表视图的属性改变渲染完毕后截屏，参数为NO代表立刻将当前状态的视图截图
    UIView *rightToView = [toView snapshotViewAfterScreenUpdates:YES];
    rightToView.frame = CGRectMake(-toView.frame.size.width/2, 0, toView.frame.size.width, toView.frame.size.height);
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(toView.frame.size.width, 0, toView.frame.size.width/2, toView.frame.size.height)];
    rightView.clipsToBounds = YES;
    [rightView addSubview:rightToView];

    // 加入动画视图
    [containerView addSubview:fromView];
    [containerView addSubview:leftView];
    [containerView addSubview:rightView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
         leftView.frame = CGRectMake(0, 0, toView.frame.size.width/2, toView.frame.size.height);
         rightView.frame = CGRectMake(toView.frame.size.width/2, 0, toView.frame.size.width/2, toView.frame.size.height);
    } completion:^(BOOL finished) {
        // 由于加入了手势交互转场，所以需要根据手势动作是否完成/取消来做操作
         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
         if ([transitionContext transitionWasCancelled]) {
             // 手势取消
         } else {
             // 手势完成
             [containerView addSubview:toView];
         }
         [leftView removeFromSuperview];
         [rightView removeFromSuperview];
         toView.hidden = NO;
    }];
}

@end
