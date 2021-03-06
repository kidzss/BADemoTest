//
//  UIViewController+BAAlertView.m
//  BAAlertTest
//
//  Created by 博爱 on 16/2/26.
//  Copyright © 2016年 博爱之家. All rights reserved.
//

#import "UIViewController+BAAlertView.h"

//#ifdef IOS8x
//
//#else
static click clickIndex = nil;
static clickHaveField clickIncludeFields = nil;
static click clickDestructive = nil;
//#endif

static NSMutableArray *fields = nil;

@implementation UIViewController (BAAlertView)


#pragma mark - *****  alert view
- (void)BAAlertWithTitle:(NSString *)title
                 message:(NSString *)message
               andOthers:(NSArray<NSString *> *)others
                animated:(BOOL)animated
                  action:(click)click
{
    if (IOS8x)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx == 0)
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (action)
                    {
                        click(idx);
                    }
                }]];
            }
            else
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    if (action)
                    {
                        click(idx);
                    }
                }]];
            }
        }];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else
    {
        UIAlertView *alertView = nil;
        if (others.count > 0)
        {
            alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:others[0] otherButtonTitles: nil];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        }
        
        [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx != 0)
            {
                [alertView addButtonWithTitle:obj];
            }
        }];
        
        clickIndex = click;
        
        [alertView show];

    }
}

#pragma mark - *****  alertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (clickIndex)
    {
        clickIndex(buttonIndex);
    }
    else if (clickIncludeFields)
    {
        clickIncludeFields(fields,buttonIndex);
    }
    
    clickIndex = nil;
    clickIncludeFields = nil;
}

#pragma mark - *****  sheet
- (void)BAActionSheetWithTitle:(NSString *)title
                       message:(NSString *)message
                   destructive:(NSString *)destructive
             destructiveAction:(click )destructiveAction
                     andOthers:(NSArray <NSString *> *)others
                      animated:(BOOL )animated
                        action:(click )click
{
    if (IOS8x)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        if (destructive)
        {
            [alertController addAction:[UIAlertAction actionWithTitle:destructive style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                if (action)
                {
                    destructiveAction(NO_USE);
                }
            }]];
        }
        
        
        [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0)
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (action)
                    {
                        click(idx);
                    }
                }]];
            }
            else
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (action)
                    {
                        click(idx);
                    }
                }]];
            }
            
        }];
        
        [self presentViewController:alertController animated:animated completion:nil];
    }
    else
    {
        UIActionSheet *sheet = nil;
        if (others.count > 0 && destructive)
        {
            sheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:others[0] destructiveButtonTitle:destructive otherButtonTitles:nil];
        }
        else
        {
            sheet = [[UIActionSheet alloc] initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:destructive otherButtonTitles:nil];
        }
        
        [others enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0)
            {
                [sheet addButtonWithTitle:obj];
            }
        }];
        clickIndex = click;
        clickDestructive = destructiveAction;
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        if (clickDestructive)
        {
            clickDestructive(NO_USE);
        }
    }
    else
    {
        if (clickIndex)
        {
            clickIndex(buttonIndex - 1);
        }
    }
}


#pragma mark - *****  textField
- (void)BAAlertWithTitle:(NSString *)title
                 message:(NSString *)message
                 buttons:(NSArray<NSString *> *)buttons
         textFieldNumber:(NSInteger )number
           configuration:(configuration )configuration
                animated:(BOOL )animated
                  action:(clickHaveField )click
{
    if (fields == nil)
    {
        fields = [NSMutableArray array];
    }
    else
    {
        [fields removeAllObjects];
    }
    
    if (IOS8x)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        // textfield
        for (NSInteger i = 0; i < number; i++)
        {
            [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                [fields addObject:textField];
                configuration(textField,i);
            }];
        }
        
        // button
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx == 0)
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    if (action)
                    {
                        click(fields,idx);
                    }
                }]];
            }
            else
            {
                [alertController addAction:[UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    if (action)
                    {
                        click(fields,idx);
                    }
                }]];
            }
        }];
        [self presentViewController:alertController animated:animated completion:nil];
    }
    else
    {
        UIAlertView *alertView = nil;
        if (buttons.count > 0)
        {
            alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:buttons[0] otherButtonTitles:nil];
        }
        else
        {
            alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        }
        // field
        if (number == 1)
        {
            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        }
        else if (number > 2)
        {
            alertView.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
        }
        
        // configuration field
        if (alertView.alertViewStyle == UIAlertViewStyleLoginAndPasswordInput)
        {
            [fields addObject:[alertView textFieldAtIndex:0]];
            [fields addObject:[alertView textFieldAtIndex:1]];
            
            configuration([alertView textFieldAtIndex:0],0);
            configuration([alertView textFieldAtIndex:1],1);
        }
        else if(alertView.alertViewStyle == UIAlertViewStylePlainTextInput || alertView.alertViewStyle == UIAlertViewStyleSecureTextInput)
        {
            [fields addObject:[alertView textFieldAtIndex:0]];
            configuration([alertView textFieldAtIndex:0],0);
        }
        
        // other button
        [buttons enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx != 0)
            {
                [alertView addButtonWithTitle:obj];
            }
        }];
        clickIncludeFields = click;
        
        [alertView show];
    }
}

@end
