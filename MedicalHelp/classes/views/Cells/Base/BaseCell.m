//
//  BaseCell.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

+ (NSString *)defaultIdentifer {
    return NSStringFromClass([self class]);
}

- (NSString *)reuseIdentifier {
    return [[self class] defaultIdentifer];
}

@end
