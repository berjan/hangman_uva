//
//  FlipsideViewController.m
//  hangman
//
//  Created by Bruens IT on 11/04/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger allowedGuessesSetting = [settings integerForKey:@"allowedGuesses"];
    NSInteger totalCharsToGuessSetting = [settings integerForKey:@"totalCharsToGuess"];
    
    if (allowedGuessesSetting == 0){
        self.sliTotalAllowedGuesses.value = 8;
        self.lblTotalAllowedGuesses.text = @"8";
    }else{
        self.sliTotalAllowedGuesses.value = allowedGuessesSetting;
        NSString *integerAsString = [NSString stringWithFormat:@"%d", allowedGuessesSetting];

        self.lblTotalAllowedGuesses.text = integerAsString;
    }
    
    if (totalCharsToGuessSetting == 0){
        self.sliTotalCharsToGuess.value = 4;
        self.lblTotalCharsToGuess.text = @"4";
    }else{
        self.sliTotalCharsToGuess.value = totalCharsToGuessSetting;
        NSString *integerAsString = [NSString stringWithFormat:@"%d", totalCharsToGuessSetting];
        
        self.lblTotalCharsToGuess.text = integerAsString;
    }
    
    self.txtPlayerName.text = [settings objectForKey:@"name_player"];
    
    
    
    
}
- (IBAction)savePlayerName
{
     NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    [settings setValue:self.txtPlayerName.text forKey:@"name_player"];
}
- (IBAction)sliderChanged:(id)sender
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.lblTotalToGuessSetting.text = [NSString stringWithFormat:@"%d",val];
    [settings setInteger:val forKey:@"allowedGuesses"];
}



- (IBAction)sliderTotalCharsToGuessChanged:(id)sender
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    UISlider *slider = (UISlider *)sender;
    NSInteger val = lround(slider.value);
    self.lblTotalCharsToGuess.text = [NSString stringWithFormat:@"%d",val];
    [settings setInteger:val forKey:@"totalCharsToGuess"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate flipsideViewControllerDidFinish:self];
}

@end
