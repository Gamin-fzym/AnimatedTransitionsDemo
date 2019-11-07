//
//  GATransitionPresentation.h
//  NewDemo
//
//  Created by shuangba on 2019/11/7.
//  Copyright © 2019 shuangba. All rights reserved.
//  CardAnimateType时使用

#import <UIKit/UIKit.h>
#import "GATransitionAnimate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GATransitionPresentation : UIPresentationController <UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) GATransitionAnimateType animateType;

@end

NS_ASSUME_NONNULL_END
