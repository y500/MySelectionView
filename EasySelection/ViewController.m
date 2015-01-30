//
//  ViewController.m
//  EasySelection
//
//  Created by yanqizhou on 12/6/14.
//  Copyright (c) 2014 yanqizhou. All rights reserved.
//

#import "ViewController.h"
#import "MySelectionView.h"

@interface ViewController (){
    int selectIndex;
    UILabel *showLabel;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    showLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    showLabel.numberOfLines=0;
    showLabel.text=@"点击测试";
    showLabel.center=self.view.center;
    showLabel.textAlignment=NSTextAlignmentCenter;
    showLabel.textColor=[UIColor colorWithRed:0x66/0xff green:0x66/0xff blue:0x66/0xff alpha:1];
    [self.view addSubview:showLabel];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(testSelectView)];
    [self.view addGestureRecognizer:tap];
}

- (void)testSelectView {
    
    NSLog(@"111");
    
    NSMutableArray *numberArr=[NSMutableArray arrayWithCapacity:3];
    for (int i=1; i<=20; i++) {
        
        NSMutableDictionary *ndic=[NSMutableDictionary  dictionaryWithCapacity:2];
        [ndic setObject:[NSString stringWithFormat:@"%d间",i] forKey:@"name"];
        [ndic setObject:[NSString stringWithFormat:@"%d",i] forKey:@"data"];
        [numberArr addObject:ndic];
    }
    
    if (numberArr.count<=1) {
        return;
    }
    
    NSMutableDictionary *seDic=[NSMutableDictionary dictionaryWithCapacity:3];
    [seDic setObject:[NSString stringWithFormat:@"%d间",selectIndex] forKey:@"name"];
    [seDic setObject:[NSString stringWithFormat:@"%d",selectIndex] forKey:@"data"];
    
    MySelectionView *roomcntview=[[MySelectionView alloc] initWithContentArray:numberArr
                                                                      selected:seDic getNameBlock:^(NSDictionary *rdic){return [rdic objectForKey:@"name"];}
                                                                   selectBlock:^(MySelectionView *sview, NSDictionary *selectDic){
                                                                       
                                                                       selectIndex=[[selectDic objectForKey:@"data"] intValue];
                                                                       NSLog(@"%@",selectDic);
                                                                       NSLog(@"你选择了%d间",selectIndex);
                                                                       showLabel.text=[NSString stringWithFormat:@"你选了%d间",selectIndex];
                                                                       NSLog(@"333");
                                                                   }];
    [roomcntview show];
    
    NSLog(@"222");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
