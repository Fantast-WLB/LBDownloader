//
//  ViewController.m
//  LBDownloader
//
//  Created by 吴龙波 on 2018/4/27.
//  Copyright © 2018 WhatTheGhost. All rights reserved.
//

#import "ViewController.h"
#import "LBDownloader.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LBDownloader *downloader = [LBDownloader sharedInstance];
    [downloader lb_addDownloadSessionWithURL:[NSURL URLWithString:@"http://m5.pc6.com/xuh5/machinarium1002.dmg"] fileName:@"哎哟不错喔"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
