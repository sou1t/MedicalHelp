//
//  UIColor+Extension.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 05.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#define RGBA(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0 blue:(b) / 255.0 alpha:(a)]
#define RGB(r, g, b) RGBA(r, g, b, 1)

@interface UIColor (Extension)

// Text
+ (UIColor *)textDarkColor;
+ (UIColor *)textGrayColor;
+ (UIColor *)textLightColor;

// Backgrounds
+ (UIColor *)bgRedColor;
+ (UIColor *)bgLightColor;

+ (UIColor *)bgTagsBorderColor;

// Functions
- (NSString *)hexString;

@end
