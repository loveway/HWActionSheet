//
//  HWActionSheet.m
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 2018/9/27.
//  Copyright © 2018 iMac. All rights reserved.
//

#import "HWActionSheet.h"

#define titleFont(f) [UIFont fontWithName:@"PingFangSC-Medium" size:f]
#define GCColor(r, g, b) [UIColor colorWithRed:(r/255.0) green:(g/255.0) blue:(b/255.0) alpha:1.0]
// 背景色
#define GlobelBgColor GCColor(237, 240, 242)
// 分割线颜色
#define GlobelSeparatorColor GCColor(226, 226, 226)
// 普通状态下的图片
#define normalImage [self createImageWithColor:GCColor(255, 255, 255)]
// 高亮状态下的图片
#define highImage [self createImageWithColor:GCColor(242, 242, 242)]

@interface HWActionSheet ()

@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, assign) HWActionSheetType type;

@end

const CGFloat cellHeight = 45.0f;
const CGFloat titleHeight = 56.0f;
const CGFloat margin = 5.0f;

@implementation HWActionSheet

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles type:(HWActionSheetType)type {
    
    if (self == [super init]) {
        _type = type;
        [self setupViewWithTitles:titles];
    }
    return self;
}

- (void)setupViewWithTitles:(NSArray<NSString *> *)titles {
    
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.alpha = 0.1;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:tap];
    
    UIView *sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0)];
    sheetView.backgroundColor = [UIColor whiteColor];
    sheetView.alpha = 1;
    [[UIApplication sharedApplication].keyWindow addSubview:sheetView];
    self.sheetView = sheetView;
    sheetView.hidden = YES;
    
    _tagIndex = 0;
    if(titles.count > 0) {
        for (NSString *title in titles) {
            [self setupBtnWithTitle:title];
        }
    }
    CGRect sheetViewFrame = _sheetView.frame;
    if (_type == HWActionSheettTypeNormal) {
        sheetViewFrame.size.height = cellHeight * (_tagIndex + 1) + margin + KBottomSafe_height;
    } else if (_type == HWActionSheetTypeBottomNoCancel) {
        sheetViewFrame.size.height = cellHeight * _tagIndex  + KBottomSafe_height;
    } else if (_type == HWActionSheetTitleClose) {
        sheetViewFrame.size.height = cellHeight * _tagIndex + titleHeight + KBottomSafe_height;
    }
    _sheetView.frame = sheetViewFrame;
    
    if (_type == HWActionSheetTypeNormal) {
        [self addCancelBtn];
    } else if (_type == HWActionSheetTypeBottomNoCancel) {

    } else if (_type == HWActionSheetTypeNormal) {
        [self addTitleView];
    }
}

- (void)cancelBtnClick {
    [self close];
}

- (void)close {
    CGRect sheetViewFrame = self.sheetView.frame;
    sheetViewFrame.origin.y =  [UIScreen mainScreen].bounds.size.height;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.sheetView.frame = sheetViewFrame;
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.sheetView removeFromSuperview];
        [self removeFromSuperview];
    }];
}
- (void)show {
    self.sheetView.hidden = NO;
    CGRect sheetViewFrame = self.sheetView.frame;
    sheetViewFrame.origin.y = [UIScreen mainScreen].bounds.size.height;
    self.sheetView.frame = sheetViewFrame;
    
    CGRect newSheetViewF = self.sheetView.frame;
    newSheetViewF.origin.y = [UIScreen mainScreen].bounds.size.height - self.sheetView.frame.size.height;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.sheetView.frame = newSheetViewF;
        self.alpha = 0.3;
    }];
}
- (void)setupBtnWithTitle:(NSString *)title {

    CGRect rect = CGRectZero;
    if (_type == HWActionSheetTypeNormal) {
        rect = CGRectMake(0, cellHeight * _tagIndex , [UIScreen mainScreen].bounds.size.width, cellHeight);
    } else if (_type == HWActionSheetTypeBottomNoCancel) {
        rect = CGRectMake(0, cellHeight * _tagIndex , [UIScreen mainScreen].bounds.size.width, cellHeight);
    } else if (_type == HWActionSheetTypeTitleClose) {
        rect = CGRectMake(0, cellHeight * _tagIndex + titleHeight, [UIScreen mainScreen].bounds.size.width, cellHeight);
    }
    UIButton *btn = [[UIButton alloc] initWithFrame:rect];

    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17];
    btn.tag = _tagIndex + 1;
    [btn addTarget:self action:@selector(cellBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
    
    // separate line
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btn.frame.size.width, 0.5)];
    line.backgroundColor = GlobelSeparatorColor;
    [btn addSubview:line];
    
    _tagIndex ++;
}

- (void)cellBtnClick:(UIButton *)btn {
    
    self.tapIndexBlock ? self.tapIndexBlock(btn.tag) : nil;
    [self close];
}

- (void)addCancelBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _sheetView.frame.size.height - cellHeight - KBottomSafe_height, _sheetView.frame.size.width, cellHeight);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor colorWithHexString:@"#333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont(17);
    btn.tag = 0;
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
}

- (void)addTitleView {
    
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sheetView.frame.size.width, titleHeight)];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_sheetView.frame.size.width - titleHeight, 0, titleHeight, titleHeight);
    [closeBtn setImage:[UIImage imageNamed:@"action_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.text = @"请选择";
    label.font = titleFont(14);
    [label sizeToFit];
    label.center = view.center;
    [view addSubview:label];
    
    [_sheetView addSubview:view];
}
- (UIImage *)createImageWithColor:(UIColor*)color {
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void)setFirstBtnSelected:(BOOL)firstBtnSelected {
    if (firstBtnSelected) {
        [self _setSelectedBtnWithTag:1];
    }
}

- (void)setSecondtBtnSelected:(BOOL)secondtBtnSelected {
    if (secondtBtnSelected) {
        [self _setSelectedBtnWithTag:2];
    }
}

- (void)_setSelectedBtnWithTag:(NSInteger)btnTag {
    UIButton *btn1 = (UIButton *)[self.sheetView viewWithTag:1];
    UIButton *btn2 = (UIButton *)[self.sheetView viewWithTag:2];
    
    if (btn1 && btn2) {
        if (btnTag == 1) {
            [btn1 setTitleColor:kMain_color forState:UIControlStateNormal];
            [btn2 setTitleColor:UIColorHex(#333333) forState:UIControlStateNormal];
        } else {
            [btn2 setTitleColor:kMain_color forState:UIControlStateNormal];
            [btn1 setTitleColor:UIColorHex(#333333) forState:UIControlStateNormal];
        }
    }
}
@end
