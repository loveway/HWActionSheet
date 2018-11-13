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

//judge iPhone X
#define is_iPhone  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define is_iOS11   ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)
#define is_iPhoneX (is_iOS11 && is_iPhone && [self isiphoneX])
#define KBottomSafe_height  (is_iPhoneX ? 34 : 0)

@interface HWActionSheet ()

@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, assign) NSInteger tagIndex;
@property (nonatomic, assign) HWActionSheetType type;
@property (nonatomic, strong) UIButton *tempBtn;


@end

static const CGFloat cellHeight = 45.0f;
static const CGFloat titleHeight = 56.0f;
static const CGFloat margin = 5.0f;
static const CGFloat separateHeight = 5.0f;

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
    if (_type == HWActionSheetTypeNormal) {
        sheetViewFrame.size.height = cellHeight * (_tagIndex + 1) + margin + KBottomSafe_height + separateHeight;
    } else if (_type == HWActionSheetTypeBottomNoCancel) {
        sheetViewFrame.size.height = cellHeight * _tagIndex  + KBottomSafe_height;
    } else if (_type == HWActionSheetTypeTitleClose) {
        sheetViewFrame.size.height = cellHeight * _tagIndex + titleHeight + KBottomSafe_height;
    }
    _sheetView.frame = sheetViewFrame;
    
    if (_type == HWActionSheetTypeNormal) {
        [self addCancelBtn];
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
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
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
    
    if (_tempBtn) {
        [_tempBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        _tempBtn = btn;
    }
    self.tapIndexBlock ? self.tapIndexBlock(btn.tag) : nil;
    [self close];
}

- (void)addCancelBtn {
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _sheetView.frame.size.height - cellHeight - KBottomSafe_height - separateHeight, _sheetView.frame.size.width, separateHeight)];
    lineView.backgroundColor = GlobelSeparatorColor;
    [self.sheetView addSubview:lineView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _sheetView.frame.size.height - cellHeight - KBottomSafe_height, _sheetView.frame.size.width, cellHeight);
    [btn setTitle:@"取消" forState:UIControlStateNormal];
    [btn setBackgroundImage:normalImage forState:UIControlStateNormal];
    [btn setBackgroundImage:highImage forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = titleFont(15);
    btn.tag = 0;
    [btn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sheetView addSubview:btn];
}

- (void)setActionTitle:(NSString *)actionTitle {
    _actionTitle = actionTitle;
    if (actionTitle && _type == HWActionSheetTypeTitleClose) {
        [self addTitleView];
    }
}

- (void)addTitleView {
    
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _sheetView.frame.size.width, titleHeight)];
    
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    closeBtn.frame = CGRectMake(_sheetView.frame.size.width - titleHeight, 0, titleHeight, titleHeight);
    [closeBtn setImage:[UIImage imageNamed:@"action_close"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:closeBtn];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    label.font = titleFont(14);
    label.text = _actionTitle;
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

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex == 0) {
        return;
    }
    UIButton *btn = (UIButton *)[self.sheetView viewWithTag:1];
    if (btn) {
        [btn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        _tempBtn = btn;
    }
}

- (BOOL)isiphoneX {
    // iPhone X/XS:      375pt * 812pt (@3x)
    // iPhone XS MAX:    414pt * 896pt (@3x)
    // iPhone XR:        414pt * 896pt (@2x)
    if ([UIScreen mainScreen].bounds.size.height == 812.0 || [UIScreen mainScreen].bounds.size.height == 896.0) {
        return YES;
    }
    return NO;
}
@end
