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

@interface MainController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{bool isFiltered;
    bool isred;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *buttonsView;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *searchResult;



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
    
    self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
    self.searchBar.delegate = (id)self;
    self.searchBar.barTintColor = self.tableView.backgroundColor;
    isred=true;
    isFiltered = false;
    
    

}


- (void)searchBarRemoveKeyboard:(UISearchBar *)searchBar {
    
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = false;
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
                self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
                self.searchBar.barTintColor = self.tableView.backgroundColor;
                isred=true;
                [self ChangeCancelButtonColor:[UIColor whiteColor] setTitle:@"Отмена"];
                break;
                
            case ButtonsTypeSymptoms:
                self.objects = [DataModel sharedInstance].symptoms;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
                self.searchBar.barTintColor = self.tableView.backgroundColor;
                [self ChangeCancelButtonColor:[UIColor bgRedColor] setTitle:@"Отмена"];
                isred=false;
                break;
                
            case ButtonsTypeDiseases:
                self.objects = [DataModel sharedInstance].diseases;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
                self.searchBar.barTintColor = self.tableView.backgroundColor;
                isred = false;
                [self ChangeCancelButtonColor:[UIColor bgRedColor] setTitle:@"Отмена"];
                break;
                
            case ButtonsTypeMedicaments:
                self.objects = [DataModel sharedInstance].medicaments;
                self.tableView.backgroundColor = [UIColor bgLightColor];
                self.searchResult = [NSMutableArray arrayWithCapacity:[self.objects count]];
                self.searchBar.barTintColor = self.tableView.backgroundColor;
                isred = false;
                [self ChangeCancelButtonColor:[UIColor bgRedColor] setTitle:@"Отмена"];
                break;
                
            default:
                break;
        }
        self.searchBar.backgroundColor = self.tableView.backgroundColor;
        [self.tableView reloadData];
    }
}


#pragma mark - Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(nullable id)sender {
    if ([segue.destinationViewController isKindOfClass:[DetailsController class]]) {
        if (self.searchDisplayController.active) {
            DetailsController *detailsController = segue.destinationViewController;
            detailsController.mData = self.searchResult[self.selectedRow];

        }
        else
        {
        DetailsController *detailsController = segue.destinationViewController;
        detailsController.mData = self.objects[self.selectedRow];
        }
    }
}


#pragma mark - Actions

- (IBAction)actionButton:(UIButton *)button {
    self.selectedButtonType = button.tag;
}


#pragma mark - Work

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath withData:(NSArray *)data
{
        [(MainCell *)cell setMData:data[indexPath.row]];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (isFiltered)
    {
        return [self.searchResult count];
    }
    else
    {
        return [self.objects count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[MainCell defaultIdentifer] /*forIndexPath:indexPath*/];
    if (cell == nil)
    {
        cell = [[MainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[MainCell defaultIdentifer]];
    }
    if (isFiltered)
    {
       [self configureCell:cell atIndexPath:indexPath withData:self.searchResult];
    }
    else
    {
        [self configureCell:cell atIndexPath:indexPath withData:self.objects];
    }
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedRow = indexPath.row;
    
    IB_SHOW_SEGUE(DetailsController);
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    [self.searchResult removeAllObjects];
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"self.title CONTAINS[c] %@", searchText];
    
    self.searchResult = [NSMutableArray arrayWithArray: [self.objects filteredArrayUsingPredicate:resultPredicate]];
}

#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if (isred) {
        [self ChangeCancelButtonColor:[UIColor whiteColor] setTitle:@"Отмена"];
    }
    else
    {
        [self ChangeCancelButtonColor:[UIColor bgRedColor] setTitle:@"Отмена"];
    }
 
}

-(void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)text
{
    if (isred) {
        [self ChangeCancelButtonColor:[UIColor whiteColor] setTitle:@"Отмена"];
    }
    else
    {
        [self ChangeCancelButtonColor:[UIColor bgRedColor] setTitle:@"Отмена"];
    }
    self.searchBar.showsCancelButton = true;
    if(text.length == 0)
    {
        isFiltered = false;
    }
    else
    {
        [self filterContentForSearchText:text];
        isFiltered = true;
    }
    
    [self.tableView reloadData];
}



- (void) searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    [self searchBarRemoveKeyboard:theSearchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self searchBarRemoveKeyboard:searchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchBarRemoveKeyboard:searchBar];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.searchBar.showsCancelButton = true;
    return YES;
}


- (void)ChangeCancelButtonColor:(UIColor *)color setTitle:(NSString *)text {
    self.cancelButton = [self.searchBar valueForKey:@"_cancelButton"];
    [self.cancelButton setTitleColor:color forState:UIControlStateNormal];
    [self.cancelButton setTitle:text forState:UIControlStateNormal];
}

@end
