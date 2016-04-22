//
//  UIFont+Extension.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 05.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

#pragma mark - HelveticaNeue

+ (UIFont *)helveticaNeueFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue" size:size];
}

+ (UIFont *)helveticaNeueLightFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}

+ (UIFont *)helveticaNeueMediumFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Medium" size:size];
}

+ (UIFont *)helveticaNeueBoldFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
