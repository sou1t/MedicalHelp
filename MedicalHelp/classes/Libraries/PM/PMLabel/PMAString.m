//
//  PMAString.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 03.12.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

// NSAttributedString Styles
//
// NSFontAttributeName                UIFont
// NSParagraphStyleAttributeName      NSParagraphStyle
// NSForegroundColorAttributeName     UIColor
// NSBackgroundColorAttributeName     UIColor
// NSLigatureAttributeName            NSNumber
// NSKernAttributeName                NSNumber
// NSStrikethroughStyleAttributeName  NSNumber
// NSUnderlineStyleAttributeName      NSNumber
// NSStrokeColorAttributeName         UIColor
// NSStrokeWidthAttributeName         NSNumber
// NSShadowAttributeName              NSShadow
// NSVerticalGlyphFormAttributeName   NSNumber

// NSTextEffectAttributeName          NSString
// NSAttachmentAttributeName          NSTextAttachment
// NSLinkAttributeName                NSURL
// NSBaselineOffsetAttributeName      NSNumber
// NSUnderlineColorAttributeName      UIColor
// NSStrikethroughColorAttributeName  UIColor
// NSObliquenessAttributeName         NSNumber
// NSExpansionAttributeName           NSNumber
// NSWritingDirectionAttributeName

#import "PMAString.h"

@interface PMAString ()

@property (nonatomic, strong) NSDictionary *innerStyle;
@property (nonatomic, strong) NSArray *innerStyleNames;
@property (nonatomic, strong) NSArray *styleNames;

@end

@implementation PMAString

+ (instancetype)sharedInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.defaultStyle = @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14]};
        
        self.innerStyle = @{@"_color" : NSForegroundColorAttributeName, @"_bgcolor" : NSBackgroundColorAttributeName};
        self.innerStyleNames = [self.innerStyle allKeys];
        
        self.styleList = @{@"bold": @{NSFontAttributeName: [UIFont helveticaNeueBoldFontOfSize:14]},
                           @"font14": @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:14]},
                           @"font17": @{NSFontAttributeName: [UIFont helveticaNeueFontOfSize:17]}};
        self.styleNames = [self.styleList allKeys];
    }
    
    return self;
}


#pragma mark - Property

- (void)setStyleList:(NSDictionary *)styleList {
    _styleList = [NSDictionary dictionaryWithDictionary:styleList];
    self.styleNames = [self.styleList allKeys];
}


#pragma mark - Public

+ (NSMutableDictionary *)attributesWithFont:(UIFont *)font color:(UIColor *)color {
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: color};
    
    return [NSMutableDictionary dictionaryWithDictionary:attributes];
}

+ (NSMutableDictionary *)attributesWithFontName:(NSString *)fontName size:(CGFloat)size color:(UIColor *)color {
    return [self attributesWithFont:[UIFont fontWithName:fontName size:size] color:color];
}

+ (NSAttributedString *)attributedString:(NSString *)string {
    return [[[self class] sharedInstance] attributedStringWithString:string];
}


#pragma mark - Work

- (NSAttributedString *)attributedStringWithString:(NSString *)string {
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:string];
    
    if (self.defaultStyle) {
        [result addAttributes:self.defaultStyle range:NSMakeRange(0, result.length)];
    }
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\<+[A-Z0-9a-z _=(),]+\\>" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange findeRange = NSMakeRange(0, 0);
    
    while(1) {
        NSString *process = (NSString *)[result mutableString];
        NSRange sRange = [regex rangeOfFirstMatchInString:process options:0 range:NSMakeRange(findeRange.location, [process length] - findeRange.location)];
        
        if (!NSEqualRanges(sRange, NSMakeRange(NSNotFound, 0))) {
            NSInteger sPos = sRange.location;
            
            NSString *sTag = [process substringWithRange:sRange];
            
            BOOL dopParam = NO;
            NSString *param;
            
            NSRange eR = [sTag rangeOfString:@"="];
            if (!NSEqualRanges(eR, NSMakeRange(NSNotFound, 0))) {
                NSArray *pars = [sTag componentsSeparatedByString:@"="];
                sTag = [NSString stringWithString:pars[0]];
                sTag = [sTag stringByReplacingOccurrencesOfString:@"<" withString:@""];
                sTag = [sTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                param = [NSString stringWithString:pars[1]];
                param = [param stringByReplacingOccurrencesOfString:@">" withString:@""];
                param = [param stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                
                dopParam = YES;
                pars = nil;
            }
            
            if (!dopParam) {
                sTag = [sTag stringByReplacingOccurrencesOfString:@"<" withString:@""];
                sTag = [sTag stringByReplacingOccurrencesOfString:@">" withString:@""];
                sTag = [sTag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            }
            
            BOOL find = NO;
            BOOL findInner = NO;
            
            id parameterObject = nil;
            for (NSString* key in self.innerStyleNames) {
                if ([sTag isEqualToString:key]) {
                    findInner = YES;
                    
                    if (dopParam) {
                        NSRange dpR = [param rangeOfString:@"rgba" options:NSCaseInsensitiveSearch];
                        if (!NSEqualRanges(dpR, NSMakeRange(NSNotFound, 0))) {
                            param = [param stringByReplacingOccurrencesOfString:@"rgba" withString:@""];
                            param = [param  stringByReplacingOccurrencesOfString:@"(" withString:@""];
                            param = [param  stringByReplacingOccurrencesOfString:@")" withString:@""];
                            NSArray *pc = [param componentsSeparatedByString:@","];
                            if ([pc count] == 4) {
                                parameterObject = RGBA([pc[0] intValue] % 256, [pc[1] intValue] % 256, [pc[2] intValue] % 256, [pc[3] intValue]);
                            } else {
                                parameterObject = [UIColor redColor];
                            }
                        } else {
                            
                            dpR = [param rangeOfString:@"rgb" options:NSCaseInsensitiveSearch];
                            if (!NSEqualRanges(dpR, NSMakeRange(NSNotFound, 0))) {
                                param = [param stringByReplacingOccurrencesOfString:@"rgb" withString:@""];
                                param = [param  stringByReplacingOccurrencesOfString:@"(" withString:@""];
                                param = [param  stringByReplacingOccurrencesOfString:@")" withString:@""];
                                NSArray *pc = [param componentsSeparatedByString:@","];
                                if ([pc count] == 3) {
                                    parameterObject = RGBA([pc[0] intValue] % 256, [pc[1] intValue] % 256, [pc[2] intValue] % 256, 1);
                                } else {
                                    parameterObject = [UIColor redColor];
                                }
                            }
                        }
                    }
                }
            }
            
            if (!findInner && self.styleList) {
                for (NSString* key in self.styleNames) {
                    if ([sTag isEqualToString:key]) {
                        find = YES;
                    }
                }
            }
            
            if (find || findInner) {
                [result deleteCharactersInRange:sRange];
                findeRange.location = sRange.location;
            } else {
                findeRange.location = sRange.location + 1;
                continue;
            }
            
            process = (NSString *)[result mutableString];
            NSRange fRange = [process rangeOfString:[NSString stringWithFormat:@"</%@>",sTag] options:NSCaseInsensitiveSearch range:NSMakeRange(sPos, [process length] - sPos)];
            
            NSInteger fPos = fRange.location;
            
            if (!NSEqualRanges(fRange, NSMakeRange(NSNotFound, 0))) {
                [result deleteCharactersInRange:fRange];
            } else {
                fPos = [process length];
            }
            
            if (findInner) {
                [result addAttribute:self.innerStyle[sTag] value:parameterObject range:NSMakeRange(sPos, fPos - sPos)];
            } else {
                [result addAttributes:self.styleList[sTag] range:NSMakeRange(sPos, fPos - sPos)];
            }
            
        } else {
            break;
        }
    }
    
    return (NSAttributedString *)result;
}

@end
