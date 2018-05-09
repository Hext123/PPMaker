//
//  PPButtonMaker.m
//  PPDemo
//
//  Created by ╰莪呮想好好宠Nǐつ on 2018/5/7.
//  Copyright © 2018年 PPAbner. All rights reserved.
//

#import "PPButtonMaker.h"
#import <objc/runtime.h>
#define PPBtMakerStrongSelf(type)  __strong typeof(type) type = weak##type;
static char KBtnActionBlockKey;

@interface PPButtonMaker ()
/** 要创建的bt */
@property(nonatomic,strong) UIButton *creatingBT;
/** 记录bt的block点击事件 */
@property(nonatomic,copy) makerBtActionBlock creatingBtActionBlock;

@end

@implementation PPButtonMaker
-(instancetype)init
{
    self = [super init];
    if (self) {
        
        __weak typeof(self) weakself = self;
        //父视图
        _intoView = ^PPButtonMaker *(UIView *superV){
            PPBtMakerStrongSelf(self)
            //此处判断父视图，主要是为了严谨；不判断也OK
            if (superV && !self.creatingBT.superview) {
                [superV addSubview:self.creatingBT];
            }
            return self;
        };
        
        //frame
        _frame = ^PPButtonMaker *(CGRect frame){
            PPBtMakerStrongSelf(self)
            self.creatingBT.frame = frame;
            return self;
        };
        
        //背景色
        _bgColor = ^PPButtonMaker *(UIColor *color){
            PPBtMakerStrongSelf(self)
            self.creatingBT.backgroundColor = color;
            return self;
        };
        
        //字体颜色
        _titleColor = ^PPButtonMaker *(UIColor *titleColor,UIControlState state){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitleColor:titleColor forState:state];
            return self;
        };
        _normalTitleColor = ^PPButtonMaker *(UIColor *normalTitleColor){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitleColor:normalTitleColor forState:UIControlStateNormal];
            return self;
        };
        _highlightedTitleColor = ^PPButtonMaker *(UIColor *highlightedTitleColor){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitleColor:highlightedTitleColor forState:UIControlStateHighlighted];
            return self;
        };
        
        
        //文字
        _title = ^PPButtonMaker *(NSString *title,UIControlState state){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitle:title forState:state];
            return self;
        };
        _normalTitle = ^PPButtonMaker *(NSString *normalTitle){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitle:normalTitle forState:UIControlStateNormal];
            return self;
        };
        _highlightedTitle = ^PPButtonMaker *(NSString *highlightedTitle){
            PPBtMakerStrongSelf(self)
            [self.creatingBT setTitle:highlightedTitle forState:UIControlStateHighlighted];
            return self;
        };
        
        //点击事件
        _actionBlock = ^PPButtonMaker *(makerBtActionBlock block){
            PPBtMakerStrongSelf(self)
            if (block) {
                self.creatingBtActionBlock = block;
            }
            return self;
        };
    }
    return self;
}

-(UIButton *)creatingBT
{
    if (!_creatingBT) {
        _creatingBT = [UIButton buttonWithType:UIButtonTypeCustom];
        [_creatingBT maker_actionWithBlock:^{
            if (self.creatingBtActionBlock) {
                self.creatingBtActionBlock();
            }
        }];
    }
    return _creatingBT;
}
@end

@implementation UIButton (PPMaker)
+(UIButton *)pp_btMake:(void (^)(PPButtonMaker *))make
{
    PPButtonMaker *btMaker = [[PPButtonMaker alloc]init];
    if (make) {
        make(btMaker);
    }
    return btMaker.creatingBT;
}

-(void)maker_actionWithControlEvent:(UIControlEvents )event
                          withBlock:(makerBtActionBlock)block
{
    objc_setAssociatedObject(self, &KBtnActionBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
}
-(void)maker_actionWithBlock:(makerBtActionBlock)block
{
    [self maker_actionWithControlEvent:UIControlEventTouchUpInside withBlock:block];
}

-(void)clickAction:(UIButton *)button{
    makerBtActionBlock block =objc_getAssociatedObject(self, &KBtnActionBlockKey);
    if (block) {
        block();
    }
}
@end





