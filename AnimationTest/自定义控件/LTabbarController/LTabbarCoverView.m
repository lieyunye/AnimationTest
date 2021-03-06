//
//  LTabbarCoverView.m
//  AnimationTest
//
//  Created by lengbinbin on 15/5/22.
//  Copyright (c) 2015年 lengbinbin. All rights reserved.
//

#import "LTabbarCoverView.h"
typedef struct {
    CGRect topRect;
    CGRect bottomRect;
    CGRect leftRect;
    CGRect rightRect;
}SeparateRect ;


@implementation LTabbarCoverView{
    NSInteger count;
    NSTimer *timer ;
    CGFloat totalMove;
    CGFloat move;
    CGRect targetFrame;
    CGRect orgRect;
}

/**
 *  动画过渡效果
 *
 *  @param aimRect  目标位置
 *  @param duration 持续时间
 */
-(void)animationMoveCoverTo:(CGRect)aimRect withDuration:(NSTimeInterval)duration{

    /**
     *  use timer
     */
    CGFloat step = 0.01;
    count = duration/step;
    targetFrame = aimRect;
    orgRect = self.coverView.frame;
    totalMove = (aimRect.origin.x - self.coverView.frame.origin.x);
    move = totalMove/count;

    if (timer) {
        [timer invalidate];
    }
    timer = [NSTimer scheduledTimerWithTimeInterval:step target:self selector:@selector(updateCoverViewFrame) userInfo:nil repeats:YES];
}

static int i = 0;
- (void) updateCoverViewFrame{
    CGFloat maxExtWidth = 0;
    CGFloat widthp = 0;
    maxExtWidth = totalMove/2;
    widthp = i * move;
    
    if (ABS(widthp) > ABS(maxExtWidth)) {
        widthp = maxExtWidth  + ((count/2  - i)* move) ;
    }
    
    //  <- 向左
    CGFloat temp  = 0;
    if (move < 0) {
        temp =  i * move;
        widthp = 0;
        if (ABS(temp) > ABS(maxExtWidth)) {
            temp =  maxExtWidth  + ((count/2  - i)* move) ;
        }
    }
    
    self.coverView.frame = CGRectMake(
                                      orgRect.origin.x +  i * move  - widthp ,
                                      orgRect.origin.y,
                                      orgRect.size.width + widthp - temp,
                                      orgRect.size.height);
    [self setNeedsDisplay];
    i++;
    if (i>count) {
        i=0;
        self.coverView.frame = targetFrame;
        [timer invalidate];
        timer = nil;
    }
}


- (SeparateRect) sepRect:(CGRect)outerRect WithInner:(CGRect)innerRect {
    SeparateRect rect;
    rect.leftRect = CGRectMake(0, 0, innerRect.origin.x, outerRect.size.height);
    rect.rightRect = CGRectMake(innerRect.origin.x + innerRect.size.width, 0, outerRect.size.width - innerRect.origin.x + innerRect.size.width, outerRect.size.height);
    return rect;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if (self.wantForgroundColor) {
        [self.wantForgroundColor setFill];
    }else
    {
        [[UIColor whiteColor] setFill];
    }
//    CGRectDivide
    SeparateRect rectBg =[self sepRect:self.frame WithInner:self.coverView.frame];
    UIRectFill(rectBg.leftRect);
    UIRectFill(rectBg.rightRect);
    
    [[UIColor clearColor] setFill];
    CGRect aRect =  CGRectIntersection(self.coverView.frame,self.frame);
    UIRectFill(aRect);    
}


@end
