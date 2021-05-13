//
//  FEWebViewController.m
//  FlyingEffects
//
//  Created by OrangesAL on 2020/3/2.
//  Copyright © 2020 OrangesAL. All rights reserved.
//

#import "FEWebViewController.h"
#import "UIColor+NTAdd.h"
#import "UIImage+NTAdd.h"
#import <WebKit/WebKit.h>
#import <SVProgressHUD.h>

@interface FEWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *webView;
@property (strong, nonatomic) UIProgressView *progressView;


@end

@implementation FEWebViewController

+ (UIViewController *)fe_webNavgationControllerWithTitle:(NSString *)title webUrl:(NSString *)url {
    FEWebViewController *vc = [FEWebViewController new];
    vc.title = title;
    vc.webUrl = url;
    [vc _fe_addBackItem];
    return [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _webView.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.titleName.length > 0 ? self.titleName : NSLocalizedString(@"loading", nil);

    
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_webUrl]]];

}

- (void)_fe_addBackItem {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:NTImage(@"pk_close") style:UIBarButtonItemStyleDone target:self action:@selector(_fe_back)];;
}

- (void)_fe_back {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.webView && [keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (newprogress == 1) {
                self.progressView.hidden = YES;
                [self.progressView setProgress:0 animated:NO];
            }else {
                self.progressView.hidden = NO;
                [self.progressView setProgress:newprogress animated:YES];
            }
        });
    }else if (object == self.webView && [keyPath isEqualToString:@"title"]) {
        self.navigationItem.title = self.webView.title;
    }
}

#pragma mark ----- lazy
- (WKWebView *)webView {
    if(!_webView) {
        
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds];
        _webView.navigationDelegate = self;
    
        [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        if (self.titleName.length == 0) {
            [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
    return _webView;
}

- (UIProgressView *)progressView {
    if(!_progressView) {
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 2)];
        self.progressView.tintColor = NT_HEX(#FFD166);
        self.progressView.trackTintColor = UIColor.lightGrayColor;
    }
    return _progressView;
}



@end
