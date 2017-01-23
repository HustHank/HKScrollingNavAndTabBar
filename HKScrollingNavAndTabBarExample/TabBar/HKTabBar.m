//
//  HKTabBar.m
//  YinKe
//
//  Created by HK on 16/12/31.
//  Copyright © 2016年 hkhust. All rights reserved.
//

#import "HKTabBar.h"
#import "UIView+HKExtension.h"

#define TabBarColor [UIColor colorWithRed:175/255.0 green:238/255.0 blue:238/255.0 alpha:1.0]

@interface HKTabBar ()

/** 中间按钮 */
@property (nonatomic, weak) UIButton *centerBtn;
@property (nonatomic, copy) HKTabBarClickBlock block;

@end

@implementation HKTabBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = TabBarColor;
        //去掉TabBar的分割线
        [self setBackgroundImage:[UIImage new]];
        [self setShadowImage:[UIImage new]];
        //设置中间按钮图片和尺寸
        UIButton *centerBtn = [[UIButton alloc] init];
        [centerBtn setBackgroundImage:[UIImage imageNamed:@"center"] forState:UIControlStateNormal];
        [centerBtn setBackgroundImage:[UIImage imageNamed:@"center"] forState:UIControlStateHighlighted];
        centerBtn.size = centerBtn.currentBackgroundImage.size;
        [centerBtn addTarget:self action:@selector(centerBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        self.centerBtn = centerBtn;
        [self addSubview:centerBtn];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //系统自带的按钮类型是UITabBarButton，找出这些类型的按钮，然后重新排布位置，空出中间的位置
    Class class = NSClassFromString(@"UITabBarButton");
    
    self.centerBtn.centerX = self.centerX;
    //调整中间按钮的中线点Y值
    self.centerBtn.centerY = (self.height - (self.centerBtn.height - self.height)) * 0.5;
    
    NSInteger btnIndex = 0;
    for (UIView *btn in self.subviews) {//遍历tabbar的子控件
        if ([btn isKindOfClass:class]) {//如果是系统的UITabBarButton，那么就调整子控件位置，空出中间位置
            //按钮宽度为TabBar宽度减去中间按钮宽度的一半
            btn.width = (self.width - self.centerBtn.width) * 0.5;
            //中间按钮前的宽度,这里就3个按钮，中间按钮Index为1
            if (btnIndex < 1) {
                btn.x = btn.width * btnIndex;
            } else { //中间按钮后的宽度
                btn.x = btn.width * btnIndex + self.centerBtn.width;
            }
            
            btnIndex++;
            //如果是索引是0(从0开始的)，直接让索引++，目的就是让消息按钮的位置向右移动，空出来中间按钮的位置
            if (btnIndex == 0) {
                btnIndex++;
            }
        }
    }
    
    [self bringSubviewToFront:self.centerBtn];
}

#pragma mark - Btn Click
- (void)centerBtnDidClick {
    if (self.block) {
        self.block();
    }
}

- (void)setBtnClickBlock:(HKTabBarClickBlock)block {
    self.block = block;
}

//重写hitTest方法，去监听中间按钮的点击，目的是为了让凸出的部分点击也有反应
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    //判断当前手指是否点击到中间按钮上，如果是，则响应按钮点击，其他则系统处理
    //首先判断当前View是否被隐藏了，隐藏了就不需要处理了
    if (self.isHidden == NO) {
        
        //将当前tabbar的触摸点转换坐标系，转换到中间按钮的身上，生成一个新的点
        CGPoint newP = [self convertPoint:point toView:self.centerBtn];
        
        //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
        if ( [self.centerBtn pointInside:newP withEvent:event]) {
            return self.centerBtn;
        }
    }
    
    return [super hitTest:point withEvent:event];
}

@end
