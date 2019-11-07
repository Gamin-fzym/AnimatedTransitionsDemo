//
//  GATransitionViewController.h
//  NewDemo
//
//  Created by shuangba on 2019/11/6.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GATransitionAnimate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GATransitionViewController : UIViewController <UIViewControllerTransitioningDelegate, UINavigationControllerDelegate>

@property (nonatomic, assign) GATransitionAnimateType animateType;
/// SwipeAnimateType时使用下面连个属性
@property (nonatomic, strong, nullable) UIScreenEdgePanGestureRecognizer *gestureRecognizer;
@property (nonatomic, readwrite) UIRectEdge targetEdge;

@end

NS_ASSUME_NONNULL_END

