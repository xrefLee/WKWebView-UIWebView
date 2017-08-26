//
//  OCUIWebViewLoadVC.m
//  WKWebView-UIWebView
//
//  Created by lxf on 16/11/14.
//  Copyright © 2016年 lxf. All rights reserved.
//

#import "OCUIWebViewLoadVC.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface OCUIWebViewLoadVC ()<UIWebViewDelegate>{
    UIView *bgView;
    UIImageView *imgView;
    NSMutableArray *imagePhotoArr;
    NSMutableArray *mUrlArray;
}

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation OCUIWebViewLoadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    self.webView.allowsInlineMediaPlayback = YES;
    imagePhotoArr = [NSMutableArray array];
    
//    [self.webView addObserver:self forKeyPath:@"document.title" options:NSKeyValueObservingOptionNew context:nil];
    


}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == nil) {
        
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)aWebView {
    
    
    //这里是js，主要目的实现对url的获取
    static  NSString * const jsGetAllImages =
    @"function getAllImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    var imgScr = '';\
    for(var i=0;i<objs.length;i++){\
    if (objs[i].src.indexOf(\"moimg.jpg\") > -1) {\
    };\
    imgScr = imgScr + objs[i].src + '+' + objs[i].getAttribute(\"data-src\") + '**';\
    };\
    return imgScr;\
    };";
    
    
//    imgScr = imgScr + objs[i].getAttribute(\"data-src\") + '+';\
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsGetAllImages];//注入js方法
    
    NSString *urlResurlt = [self.webView stringByEvaluatingJavaScriptFromString:@"getAllImages()"];
    
    NSMutableArray *tmp = [NSMutableArray arrayWithArray:[urlResurlt componentsSeparatedByString:@"**"]];
    mUrlArray = tmp.mutableCopy;
    for (NSString *url in tmp) {
        if (!url||[url isEqualToString:@"null"]||[url isEqualToString:@""]) {
            [mUrlArray removeObject:url];
        }
    }
    
    for (NSString *url in mUrlArray) {
        
        MWPhoto *photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:url]];
        [imagePhotoArr addObject:photo];
        
    }
    
    
    
    
    //调整字号
    NSString *str = @"document.getElementsByTagName('body') 65[0].style.webkitTextSizeAdjust= '95%'";
    [self.webView stringByEvaluatingJavaScriptFromString:str];
    
    //js方法遍历图片添加点击事件 返回图片个数
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };";
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsGetImages];//注入js方法
    
    //注入自定义的js方法后别忘了调用 否则不会生效（不调用也一样生效了，，，不明白）
    NSString *resurlt = [self.webView stringByEvaluatingJavaScriptFromString:@"getImages()"];
    //调用js方法
    //    NSLog(@"---调用js方法--%@  %s  jsMehtods_result = %@",self.class,__func__,resurlt);
    
    static  NSString * const jsGetTitle = @"function getTitle(){\
    var $body = $('body')\
    document.title = ''\
    var $iframe = $('<iframe src=\"/favicon.ico\"></iframe>').on('load', function() {\
        setTimeout(function() {\
            $iframe.off('load').remove()\
        }, 0)\
    }).appendTo($body)}";
    
    
    [self.webView stringByEvaluatingJavaScriptFromString:jsGetTitle];
    
    NSString *resurlt1 = [self.webView stringByEvaluatingJavaScriptFromString:@"getTitle()"];
    
    
    
    
    
    
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    //将url转换为string
    NSString *requestString = [[request URL] absoluteString];
    //    NSLog(@"requestString is %@",requestString);
    
    
    
    if ([requestString containsString:@"MODENGVIPJump://"]) {
        [self.navigationController pushViewController:[[UIViewController alloc]init] animated:YES];
        return NO;
    }
    
    
    
    //hasPrefix 判断创建的字符串内容是否以pic:字符开始
    if ([requestString hasPrefix:@"myweb:imageClick:"]) {
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        //        NSLog(@"image url------%@", imageUrl);
        
        if (bgView) {
            //设置不隐藏，还原放大缩小，显示图片
            bgView.hidden = NO;
            imgView.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-40, 220);
            imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
//            [imgView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:LOAD_IMAGE(@"house_moren")];
        }
        else
            [self showBigImage:imageUrl];//创建视图并显示图片
        
        return NO;
    }
    return YES;
}

#pragma mark 显示大图片
-(void)showBigImage:(NSString *)imageUrl{
    
    NSUInteger index = [mUrlArray indexOfObject:imageUrl];
    
    MWPhotoBrowser *photoBrowser = [[MWPhotoBrowser alloc]initWithPhotos:imagePhotoArr];
    
    
    photoBrowser.displayActionButton = NO;
   
    [photoBrowser setCurrentPhotoIndex:index];
    [self.navigationController pushViewController:photoBrowser animated:YES];
    
    

    
    
//    //创建灰色透明背景，使其背后内容不可操作
//    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
//    [bgView setBackgroundColor:[UIColor colorWithRed:0.3
//                                               green:0.3
//                                                blue:0.3
//                                               alpha:0.7]];
//    [self.view addSubview:bgView];
//    
//    //创建边框视图
//    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width-20, 240)];
//    //将图层的边框设置为圆脚
//    borderView.layer.cornerRadius = 8;
//    borderView.layer.masksToBounds = YES;
//    //给图层添加一个有色边框
//    borderView.layer.borderWidth = 8;
//    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
//                                                    green:0.9
//                                                     blue:0.9
//                                                    alpha:0.7] CGColor];
//    [borderView setCenter:bgView.center];
//    [bgView addSubview:borderView];
//    
//    //创建关闭按钮
//    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
//    closeBtn.backgroundColor = [UIColor redColor];
//    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
//    [closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-20, borderView.frame.origin.y-6, 26, 27)];
//    [bgView addSubview:closeBtn];
//    
//    //创建显示图像视图
//    imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
//    imgView.userInteractionEnabled = YES;
//    imgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
////    [imgView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:LOAD_IMAGE(@"house_moren")];
//    [borderView addSubview:imgView];
//    
//    //添加捏合手势
//    [imgView addGestureRecognizer:[[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)]];
//    
}
//关闭按钮
-(void)removeBigImage
{
    bgView.hidden = YES;
}

- (void) handlePinch:(UIPinchGestureRecognizer*) recognizer
{
    //缩放:设置缩放比例
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}
@end
