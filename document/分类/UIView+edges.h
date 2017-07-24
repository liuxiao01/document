//
//  UIView+edges.h
//  document
//
//  Created by liu xiao on 17/4/20.
//  Copyright © 2017年 liu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (edges)


//+ (UILabel *)copyLabel:(UILabel *)label;
//+ (UIButton *)copyButton:(UIButton *)button;


@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic,assign)  CGFloat right;  /* Shortcut for frame.origin.x + frame.size.width */
@property (nonatomic,assign)  CGFloat bottom; /* Shortcut for frame.origin.y + frame.size.height */
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign, readonly) CGFloat maxY;
@property (nonatomic, assign, readonly) CGFloat maxX;


@end
