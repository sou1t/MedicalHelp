//
//  Macroses.h
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 05.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

// Localization
#define LS(key) NSLocalizedString(key, nil)
#define LSC(key, comment) NSLocalizedString(key, comment)
#define LSV(key, value, comment) NSLocalizedStringWithDefaultValue(key, nil, [NSBundle mainBundle], value, comment)
#define LSF(key, comment, ...) [NSString localizedStringWithFormat:NSLocalizedString(key, comment), ##__VA_ARGS__]

// Segue
#define IB_SEGUE(value) [NSString stringWithFormat:@"Segue%@", NSStringFromClass([value class])]
#define IB_SHOW_SEGUE(value) [self performSegueWithIdentifier:IB_SEGUE(value) sender:nil]

// Scale
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && MAX(SCREEN_WIDTH, SCREEN_HEIGHT) < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && MAX(SCREEN_WIDTH, SCREEN_HEIGHT) == 736.0)

#define AUTO_SCALE_FACTOR ([UIScreen mainScreen].bounds.size.width / 320.0)
#define AUTO_SCALE(size) roundf(AUTO_SCALE_FACTOR * (CGFloat)size)
#define MANUAL_SCALE(iPhone5Size, iPhone6Size, iPhone6PSize) (IS_IPHONE_6P ? iPhone6PSize : (IS_IPHONE_6 ? iPhone6Size : iPhone5Size))
