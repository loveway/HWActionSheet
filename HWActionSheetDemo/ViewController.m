//
//  ViewController.m
//  HWActionSheetDemo
//
//  Created by HenryCheng on 2018/11/12.
//  Copyright © 2018 HenryCheng. All rights reserved.
//

#import "ViewController.h"
#import "HWActionSheet.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)normalClick:(id)sender {
    HWActionSheet *sheet = [[HWActionSheet alloc] initWithTitles:@[@"按钮一", @"按钮二"]
                                                            type:HWActionSheetTypeNormal];
    [sheet setTapIndexBlock:^(NSInteger index) {

    }];
    sheet.selectedIndex = 1;
    [sheet show];
}
- (IBAction)noCancelClick:(id)sender {
    HWActionSheet *sheet = [[HWActionSheet alloc] initWithTitles:@[@"按钮一", @"按钮二"]                                                            type:HWActionSheetTypeBottomNoCancel];
    [sheet setTapIndexBlock:^(NSInteger index) {
        
    }];
    
    [sheet show];
}
- (IBAction)titleCloseClick:(id)sender {
    HWActionSheet *sheet = [[HWActionSheet alloc] initWithTitles:@[@"按钮一", @"按钮二"]                                                            type:HWActionSheetTypeTitleClose];
    [sheet setTapIndexBlock:^(NSInteger index) {
        
    }];
    sheet.actionTitle = @"这是一个标题";
    [sheet show];
}

@end
