//
//  ViewController.m
//  ViewControllerTransistionsDemo
//
//  Created by Thomas Keuleers on 19/01/14.
//  Copyright (c) 2014 Thomas Keuleers. All rights reserved.
//

#import "ViewController.h"
#import "STCardTransition.h"

@interface ViewController ()<UIViewControllerTransitioningDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGFloat red = arc4random_uniform(255);
    CGFloat green = arc4random_uniform(255);
    CGFloat blue = arc4random_uniform(255);
    self.view.backgroundColor = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1.0f];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destVC = segue.destinationViewController;
    destVC.transitioningDelegate = self;
}

#pragma mark - UIViewControllerTransitioningDelegate methods

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    STCardTransition *tran = [STCardTransition new];
    tran.reverse = NO;
    return tran;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    STCardTransition *tran = [STCardTransition new];
    tran.reverse = YES;
    return tran;
}
- (IBAction)close:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator;
//
//- (id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator;

@end
