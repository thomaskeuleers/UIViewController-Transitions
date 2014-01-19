//
//  STCardTransition.h
//  ViewControllerTransistionsDemo
//
//  Created by Thomas Keuleers on 19/01/14.
//  Copyright (c) 2014 Thomas Keuleers. All rights reserved.
//

@import UIKit;

@interface STCardTransition : NSObject<UIViewControllerAnimatedTransitioning>

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) BOOL reverse;

@end
