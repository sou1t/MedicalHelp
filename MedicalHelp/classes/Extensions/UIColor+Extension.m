//
//  UIColor+Extension.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 05.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

#pragma mark - Text

+ (UIColor *)textDarkColor {
    return RGB(51, 51, 51);
}

+ (UIColor *)textGrayColor {
    return RGB(151, 151, 151);
}

+ (UIColor *)textLightColor {
    return RGB(255, 255, 255);
}


#pragma mark - Backgrounds

+ (UIColor *)bgRedColor {
    return RGB(212, 74, 55);
}

+ (UIColor *)bgLightColor {
    return RGB(255, 255, 255);
}

+ (UIColor *)bgTagsBorderColor {
    return RGB(214, 214, 214);
}


#pragma mark - Functions

- (NSString *)hexString {
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
}

@end
