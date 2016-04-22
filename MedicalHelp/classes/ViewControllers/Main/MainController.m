//
//  MainController.m
//  MedicalHelp
//
//  Created by Maxim Popov popovme@gmail.com on 23.11.15.
//  Copyright © 2015 Popovme. All rights reserved.
//

#import "MainController.h"

#import "DetailsController.h"
#import "MainCell.h"

typedef NS_ENUM(NSInteger, ButtonsType) {
    ButtonsTypeFirstAid = 1,
    ButtonsTypeSymptoms,
    ButtonsTypeDiseases,
    ButtonsTypeMedicaments,
};

@interface MainController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *buttonsView;

@property (nonatomic, assign) ButtonsType selectedButtonType;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, weak) NSArray *objects;

@end

@implementation MainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor bgRedColor];
    
    UIFont *buttonFont = [UIFont helveticaNeueBoldFontOfSize:13];
    for (UIView *view in self.buttonsView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)view;
            if (button.tag == ButtonsTypeFirstAid) {
                button.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
                button.titleLabel.font = buttonFont;
                [button setTitleColor:[UIColor textLightColor] forState:UIControlStateNormal];
            } else {
                button.titleLabel.font = buttonFont;
                [button setTitleColor:[UIColor textGrayColor] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor textDarkColor] forState:UIControlStateHighlighted];
                [button setTitleColor:[UIColor textDarkColor] forState:UIControlStateSelected];
                [button setTitleColor:[UIColor textDarkColor] forState:UIControlStateHighlighted | UIControlStateSelected];
                
                UIImage *selectedImage = [button backgroundImageForState:UIControlStateSelected];
                [button setBackgroundImage:selectedImage forState:UIControlStateHighlighted | UIControlStateSelected];
            }
        }
    }
    self.selectedButtonType = ButtonsTypeFirstAid;
}


#pragma mark - Property Private

- (void)setSelectedButtonType:(ButtonsType)selectedButtonType {
    if (_selectedButtonType != selectedButtonType) {
        _selectedButtonType = selectedButtonType;
        
        for (UIView *view in self.buttonsView.subviews) {
            if ([view isKindOfClass:[UIButton class]]) {
                UIButton *button = (UIButton *)view;
                button.selected = (button.tag == selectedButtonType);
            }
        }
        
        switch (selectedButtonType) {
            case ButtonsTypeFirstAid:
                self.objects = [DataModel sharedInstance].firstAids;
                self.tableView.backgroundColor = [UIColor bgRedColor];
                break;
                
            case ButtonsTypeSymptoms:
                self.objects = [DataModel sharedInstance].symptoms;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                break;
                
            case ButtonsTypeDiseases:
                self.objects = [DataModel sharedInstance].diseases;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                break;
                
            case ButtonsTypeMedicaments:
                self.objects = [DataModel sharedInstance].medicaments;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                break;
                
            default:
                break;
        }
        
        [self.tableView reloadData];
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailsController class]]) {
        DetailsController *detailsController = segue.destinationViewController;
        detailsController.mData = self.objects[self.selectedRow];
    }
}


#pragma mark - Actions

- (IBAction)actionButton:(UIButton *)button {
    self.selectedButtonType = button.tag;
}


#pragma mark - Work

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    [(MainCell *)cell setMData:self.objects[indexPath.row]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainCell defaultIdentifer] forIndexPath:indexPath];
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    
    IB_SHOW_SEGUE(DetailsController);
}

@end
