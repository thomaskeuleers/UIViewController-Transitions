//
//  STCardTransition.m
//  ViewControllerTransistionsDemo
//
//  Created by Thomas Keuleers on 19/01/14.
//  Copyright (c) 2014 Thomas Keuleers. All rights reserved.
//

#import "STCardTransition.h"
#import "UIImage+ImageEffects.h"

static UIImage *snapshotView(UIView *view){
    CGSize size = CGSizeMake(CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
    UIGraphicsBeginImageContext(size);
    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
    UIImage *i = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return i;
}

@implementation STCardTransition

- (id)init
{
    self = [super init];
    if (self) {
        // Set default background color
        _backgroundColor = [UIColor grayColor];
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 1.2f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // Grab from/to viewcontroller
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    // Set background color for container view
    [[transitionContext containerView] setBackgroundColor:self.backgroundColor];
    
    // Add from viewcontroller to container
    [transitionContext.containerView addSubview:fromViewController.view];
    
    
    // Calculate which direction to animate to
    CGFloat startY = CGRectGetMaxY([transitionContext containerView].bounds);
    if (self.reverse) startY = -1 * startY;
    toViewController.view.frame = CGRectMake(0,startY, CGRectGetWidth([transitionContext containerView].bounds), CGRectGetHeight([transitionContext containerView].bounds));
    

    // Make transformation for scale
    CATransform3D scaleTransform = CATransform3DIdentity;
    scaleTransform = CATransform3DMakeScale(0.9f, 0.9f, 0.9f);
    toViewController.view.layer.transform = scaleTransform;
    
    // Blur fromViewController view
    UIImage *blurredSnapshot = [snapshotView(fromViewController.view) applyBlurWithRadius:1.0f
                                                                    tintColor:nil
                                                        saturationDeltaFactor:0.3
                                                                    maskImage:nil];
    UIImageView *blurredView = [[UIImageView alloc] initWithImage:blurredSnapshot];
    blurredView.layer.borderColor = [[UIColor redColor] CGColor];
    blurredView.layer.borderWidth = 2.0f;
    blurredView.frame = [transitionContext containerView].bounds;
    blurredView.alpha = 0.0f;
    [fromViewController.view addSubview:blurredView];
    
    
    // Blur toViewController view
    UIImage *blurredToVCImage = [snapshotView(toViewController.view) applyBlurWithRadius:1.0f
                                                                                tintColor:nil
                                                                    saturationDeltaFactor:0.3
                                                                                maskImage:nil];
    UIImageView *blurredToVCView = [[UIImageView alloc] initWithImage:blurredToVCImage];
    blurredToVCView.layer.borderColor = [[UIColor redColor] CGColor];
    blurredToVCView.layer.borderWidth = 2.0f;
    blurredToVCView.frame = [transitionContext containerView].bounds;
    blurredToVCView.alpha = 1.0f;
    [toViewController.view addSubview:blurredToVCView];
    
    [transitionContext.containerView addSubview:toViewController.view];
    
    // Do animation
    CGFloat duration = [self transitionDuration:transitionContext];
    CGFloat scaleFromDuration = duration * 0.2f;
    CGFloat moveVCs = duration * 0.4f;
    CGFloat scaleToDurantion = duration * 0.2f;
    [UIView animateWithDuration:scaleFromDuration animations:^{
        blurredView.alpha = 1.0f;
        fromViewController.view.layer.transform = scaleTransform;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:moveVCs animations:^{
            
            CGPoint oldCenter = fromViewController.view.center;
            CGPoint newCenter = oldCenter;
            newCenter.y = self.reverse ? oldCenter.y  + CGRectGetHeight(fromViewController.view.bounds) : oldCenter.y - CGRectGetHeight(fromViewController.view.bounds);
            
            fromViewController.view.center = newCenter;
            toViewController.view.center = oldCenter;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:scaleToDurantion animations:^{
                blurredToVCView.alpha = 0.0f;
                toViewController.view.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {
                [blurredView removeFromSuperview];
                [blurredToVCView removeFromSuperview];
                [transitionContext completeTransition:YES];
            }];
        }];
    }];
        
}
@end
