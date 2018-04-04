//
//  ViewController.m
//  TestHitTest
//
//  Created by ZXY on 2018/4/4.
//  Copyright © 2018年 JinRongBaGuaNv. All rights reserved.
//
#import "TTFeedbackViewController.h"
#import "ViewController.h"
@interface ViewController ()<UITextViewDelegate>
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *testString = @"欢迎使用探探, 在使用过程中有疑问请 <a href=\"tantanapp://feedback\">反馈</ a>";
    UITextView *showTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 200, 350, 50)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:showTextView.text];
    [attributedString addAttribute:NSLinkAttributeName
                             value:[self retHrefValue:testString]
                             range:[[attributedString string] rangeOfString:@"反馈"]];
    NSDictionary *linkAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],NSUnderlineColorAttributeName: [UIColor blueColor],NSUnderlineStyleAttributeName: @(NSUnderlinePatternSolid)};
    showTextView.linkTextAttributes = linkAttributes;
    showTextView.attributedText = [self setPromptLabelTitle:testString];
    showTextView.delegate = self;
    showTextView.editable = NO; // 可编辑状态不能点击链接
    [self.view addSubview:showTextView];
}
#pragma mark TextViewDelegate
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 100000
- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction{
    if ([[URL scheme] isEqualToString:@"tantanapp"]) {
        TTFeedbackViewController *feedBackVC = [[TTFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        return YES;
    }
    return NO;
}
#endif

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    if ([[URL scheme] isEqualToString:@"tantanapp"]) {
        TTFeedbackViewController *feedBackVC = [[TTFeedbackViewController alloc] init];
        [self.navigationController pushViewController:feedBackVC animated:YES];
        return YES;
    }
    return NO;
}
- (NSMutableAttributedString *)setPromptLabelTitle:(NSString *)htmlString {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    paragraphStyle.lineSpacing = 3.8;
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    [attrStr addAttributes:attribute range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}
-(NSString*)retHrefValue:(NSString *)htmlString{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    NSRange range;
    if ([[attrStr string] rangeOfString:@"反馈"].location == NSNotFound) {
        return nil;
    }
    [attrStr attributedSubstringFromRange:[[attrStr string] rangeOfString:@"反馈"]];
    NSDictionary*dic = [[attrStr attributedSubstringFromRange:[[attrStr string] rangeOfString:@"反馈"]] attributesAtIndex:0 effectiveRange:&range];
    NSLog(@"%@ ,%@",dic,dic[@"NSLink"]);
    return dic[@"NSLink"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

