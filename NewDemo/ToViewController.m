//
//  ToViewController.m
//  NewDemo
//
//  Created by shuangba on 2019/11/1.
//  Copyright © 2019 shuangba. All rights reserved.
//

#import "ToViewController.h"
#import "FromViewController.h"

@interface ToViewController ()

@end

@implementation ToViewController

- (IBAction)tapButtonAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.navigationController) {
        [[self.view viewWithTag:1000] setHidden:YES];
        [[self.view viewWithTag:2000] setHidden:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"ToVC";
    /* 侧滑转场 */
    FromViewController *fromVC = (FromViewController *)self.transitioningDelegate;
    if ([fromVC isKindOfClass:[GATransitionViewController class]] && fromVC.animateType == SwipeAnimateType) {
        UIScreenEdgePanGestureRecognizer *gesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        gesture.edges = UIRectEdgeLeft;
        [self.view addGestureRecognizer:gesture];
        
        [[self.view viewWithTag:1000] setHidden:YES];
    }  else {
        [[self.view viewWithTag:2000] setHidden:YES];
    }
}

- (void)panGestureAction:(UIScreenEdgePanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan && [self.transitioningDelegate isKindOfClass:[FromViewController class]]) {
        FromViewController *fromVC = (FromViewController *)self.transitioningDelegate;
        fromVC.gestureRecognizer = sender;
        fromVC.targetEdge = UIRectEdgeLeft;
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
