//
//  SecretAnimationCell.m
//  AnimationTest
//
//  Created by lengbinbin on 15/2/4.
//  Copyright (c) 2015年 lengbinbin. All rights reserved.
//

#import "SecretAnimationCell.h"
#import "AnimationControl.h"

@implementation SecretAnimationCell

-(void)sendActionViewBack{
  
    _inUseactionView = NO;
  
    [UIView animateWithDuration:.2 animations:^{
        self.actionView.center = self.actionStart;
    }];

}
-(void)resetUI{
    
    self.heart.center = self.heartStart;
    self.actionView.center = self.actionStart;

}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];

    if (self) {
        [self addObserver:self forKeyPath:@"actionView" options:NSKeyValueObservingOptionNew context:nil];
        [self addObserver:self forKeyPath:@"heart" options:NSKeyValueObservingOptionNew context:nil];

    }
    
    return self;
}
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{

    
    self.heartStart = self.heart.center;

    self.actionStart  = self.actionView.center;

}


- (void) likeAction{
    
    CGPoint pasPoint = self.contentView.center;
    
    [UIView animateWithDuration:.5 animations:^{
        self.heart.center = pasPoint;
        //    transform = CGAffineTransformScale(transform, 2,0.5);//前面的2表示横向放大2倍，后边的0.5表示纵向缩小一半
        CGAffineTransform transform=self.heart.transform;
        transform=CGAffineTransformScale(self.heart.transform,3, 3);
        self.heart.transform=transform;
    
    } completion:^(BOOL finished) {
       
        [UIView animateWithDuration:.2 animations:^{
            
            self.heart.center = self.likeBtn.center;
            CGAffineTransform transform=self.heart.transform;
            transform=CGAffineTransformScale(self.heart.transform, .3333, .3333);
            self.heart.transform=transform;
            
        } completion:^(BOOL finished) {

            self.heart.center = CGPointMake(-30, self.contentView.frame.size.height/2);
        }];
    }];
    
    


}


-(void)touchGesture:(UIPanGestureRecognizer *)recognizer{


    if (recognizer.state == UIGestureRecognizerStateBegan) {
        
        self.touchStartPoint = [recognizer locationInView:self.bg];
        if (CGPointEqualToPoint(CGPointZero, self.heartStart)) {
            self.heartStart = self.heart.center;
        }
        if (CGPointEqualToPoint(CGPointZero, self.actionStart)) {
            self.actionStart  = self.actionView.center;
        }
        self.actionTempCenter = self.actionView.center;
        
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged){
        
        CGPoint touchIn  = [recognizer locationInView:self.bg];
        CGPoint center = self.heart.center;
        
        CGFloat temp =  (touchIn.x - self.touchStartPoint.x);
// 方向区分
        BOOL rightDirection = NO;
        if (temp > 0) {
            //heart use
            rightDirection = YES;
        }
        
        //
        if (!_panInUseHeart &&  _inUseactionView){
        
            center = CGPointMake(self.actionTempCenter.x + temp, self.actionStart.y);
            
            [UIView animateWithDuration:.1 animations:^{
                
                self.actionView.center = center;
            }];

        }
        else{
            
            if (_panInUseHeart || rightDirection) {
                // 处理的心
                self.panInUseHeart = YES;

                center = CGPointMake(self.heartStart.x + temp, center.y);
                
                if (center.x > self.frame.size.width/2) {
                    center = CGPointMake(self.heartStart.x + self.frame.size.width/2+ temp/10, center.y);
                }
                
                if (center.x >= self.heart.frame.size.width/2) {
                    CGFloat sc = 1 + (center.x/self.frame.size.width/2)*4;
                    
                    self.heart.transform = CGAffineTransformMakeScale(sc, sc);
                }
                [UIView animateWithDuration:.1 animations:^{
                    
                    self.heart.center = center;
                }];
                
                
            }else{
                
                
                if (_inUseactionView) {
                    center = CGPointMake(self.contentView.center.x + temp, center.y);
                }else{
                    center = CGPointMake(self.actionStart.x + temp, center.y);
                }
                
                [UIView animateWithDuration:.1 animations:^{
                    
                    self.actionView.center = center;
                }];
                
                _inUseactionView = YES;
            }
            
        }
        
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded){
        
        if (!_panInUseHeart && _inUseactionView){

            CGPoint center = CGPointZero;
            CGFloat time = .2f;
            
            CGFloat bounds =self.contentView.frame.size.width;
            
            if (self.actionTempCenter.x == self.contentView.center.x) {
                bounds = self.contentView.frame.size.width * .7;
            }
            
            
            if (self.actionView.center.x > bounds) {
                center = self.actionStart;
                _inUseactionView = NO;
                
            }else{
                _inUseactionView = YES;
                center = CGPointMake(self.contentView.frame.size.width / 2,_actionStart.y);
            }
            
            [UIView animateWithDuration:time animations:^{
                self.actionView.center = center;
            }];

        }
        else
        {
            if (self.heart.center.x > self.frame.size.width/4 ) {
                
                if (self.heart.center.x <= self.frame.size.width/2) {
                    
                    [UIView animateWithDuration:.2 animations:^{
                        self.heart.center= CGPointMake(self.frame.size.width/2, self.heart.center.y);
                        self.heart.transform = CGAffineTransformMakeScale(2, 2);
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:.3 animations:nil completion:^(BOOL finished) {
                            
                            [UIView animateWithDuration:.3 animations:^{
                                self.heart.center  = self.likeBtn.center;
                                self.heart.transform = CGAffineTransformMakeScale(.5, .5);
                                
                            } completion:^(BOOL finished) {
                                self.heart.center = self.heartStart;
                                self.panInUseHeart = NO;
                            }];
                        }];
                        
                    }];
                    
                }
                else{
                    
                    [UIView animateWithDuration:.3 animations:^{
                        
                    } completion:^(BOOL finished) {
                        
                        [UIView animateWithDuration:.3 animations:^{
                            self.heart.center  = self.likeBtn.center;
                            self.heart.transform = CGAffineTransformMakeScale(.5, .5);
                            
                        } completion:^(BOOL finished) {
                            self.heart.center = self.heartStart;
                            self.panInUseHeart = NO;
                        }];
                        
                    }];
                }
            }else{
                
                [UIView animateWithDuration:.3 animations:^{
                    self.heart.center = self.heartStart;
                    self.heart.transform = CGAffineTransformMakeScale(1, 1);
                    
                } completion:^(BOOL finished) {
                    self.panInUseHeart = NO;
                } ];
            }
            
        }
    }
    
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{}


@end
