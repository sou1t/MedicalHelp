//
//  PMAString.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 03.12.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMAString : NSObject

@property (nonatomic, strong) NSDictionary *defaultStyle;
@property (nonatomic, strong) NSDictionary *styleList;

+ (instancetype)sharedInstance;

+ (NSMutableDictionary *)attributesWithFont:(UIFont *)font color:(UIColor *)color;
+ (NSMutableDictionary *)attributesWithFontName:(NSString *)fontName size:(CGFloat)size color:(UIColor *)color;

+ (NSAttributedString *)attributedString:(NSString *)string;

@end
