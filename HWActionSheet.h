//
//  HWActionSheet.h
//  LiquoriceDoctorProject
//
//  Created by HenryCheng on 2018/9/27.
//  Copyright © 2018 iMac. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
  HWActionSheetType

 - HWActionSheetTypeNormal: type norml, bottom has cancel button.
 - HWActionSheetTypeTitleClose: type norml, bottom not has cancel button.
 - HWActionSheetTypeTitleClose: type has title and close button.
 */
typedef NS_ENUM(NSInteger, HWActionSheetType) {
    
    HWActionSheetTypeNormal,
    HWActionSheetTypeBottomNoCancel,
    HWActionSheetTypeTitleClose
};

NS_ASSUME_NONNULL_BEGIN

@interface HWActionSheet : UIView

@property (nonatomic, copy) void(^tapIndexBlock)(NSInteger index);
@property (nonatomic, assign) BOOL firstBtnSelected;
@property (nonatomic, assign) BOOL secondtBtnSelected;

- (instancetype)initWithTitles:(NSArray<NSString *> *)titles type:(HWActionSheetType)type;
- (void)show;
@end

NS_ASSUME_NONNULL_END
