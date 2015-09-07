//
//  JHSLuaViewController.m
//  JU
//
//  Created by dongxicheng on 7/20/15.
//  Copyright (c) 2015 ju.taobao.com. All rights reserved.
//

#import "JHSLuaViewController.h"
#import "LView.h"
#import "JHSLuaErrorView.h"
#import "JHSLuaLoadingView.h"
#import "JHSLuaCollectionView.h"
#import "JHSLuaTableView.h"
#import "JHSLuaViewButton.h"
#import "JHSLuaViewImageView.h"


@interface JHSLuaViewController ()
@property(nonatomic,strong) LView* lv;
@property(nonatomic,strong) NSString* source;
@property(nonatomic,strong) NSDate* sourceModifiyDate;
@end

#define iOS7 ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

@implementation JHSLuaViewController

- (void) dealloc{
    [self.lv releaseLuaView];
}

- (id)initWithSource:(NSString*) source{
    self = [super init];
    if (self) {
        self.source = source;
        [LVErrorView setDefaultStyle:[JHSLuaErrorView class]];
        [LVLoadingView setDefaultStyle:[JHSLuaLoadingView class]];
        [LVButton setDefaultStyle:[JHSLuaViewButton class]];
        [LVImageView setDefaultStyle:[JHSLuaViewImageView class]];
        [LVCollectionView setDefaultStyle:[JHSLuaCollectionView class]];
        [LVTableView setDefaultStyle:[JHSLuaTableView class]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if( iOS7 ) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // 创建LuaView
    [self createLuaView];
    
    //摇一摇本地代码
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    [self becomeFirstResponder];
}

-(void) createLuaView{
    while (self.view.subviews.count) {
        UIView* child = self.view.subviews.lastObject;
        [child removeFromSuperview];
    }
    [self.lv releaseLuaView];
    self.lv = nil;
    
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    
    self.lv = [[LView alloc] initWithFrame:rect];
    self.lv.viewController = self;
    [self.view addSubview:self.lv];
    
    //注册外部对象.
    self.lv[@"ViewController"] = self;
    
    [self.lv runFile:self.source];// 量贩团页面
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self.lv motionBegan:motion withEvent:event];
}

// 摇一摇取消摇动
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self.lv motionCancelled:motion withEvent:event];
}

// 摇一摇摇动结束
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [self.lv motionEnded:motion withEvent:event];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [self.lv viewWillAppear];
    [self resetLuaViewFrame];
}

- (void) resetLuaViewFrame{
    CGRect rect = self.view.bounds;
    rect.origin = CGPointZero;
    if( iOS7 ) {
        rect.origin.y = 64;
    }
    self.lv.frame = rect;
    self.lv.contentOffset = CGPointZero;
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self resetLuaViewFrame];
    [self.lv viewDidAppear];
}

-(void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.lv viewWillDisAppear];
}

-(void) viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.lv viewDidDisAppear];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

/**
 * openUrl API, 暴露给脚本调用
 */
-(void) openUrl:(NSString*)actionUrl{
}

@end