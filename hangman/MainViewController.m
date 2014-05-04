//
//  MainViewController.m
//  hangman
//
//  Created by Bruens IT on 11/04/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@end

@implementation MainViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    
    
    // Make sure the keyboard popsup
    [self.myTextField becomeFirstResponder];
    

    [self startGame];
    
}
-(void)startGame
{
    self.highScore = 100;
    self.gameCompleted = false;
    self.totalIncorrectGuesses = 0;
    //setting the word to be guessed
    
    [self setWordToBeGuessed];
    self.guessesLeft = 0;
    //setting the total guessed a player can do
    [self setGuessesLeft];
    
    //set total guesses left in label
    self.lblGuessesLeft.text = [self getGuessesLeft];
    
    self.totalGuessed = 0;
    self.lblTotalGuessed.text = @"0";
    
    self.guessedChars = @"";
    
    self.lblResultWinLoos.text = @"Playing...";
    
    
    NSString *total_words = @"";
    
    for (int i=0; i < self.guessingWord.length; i++) {
        
        total_words = [total_words stringByAppendingString:@"-"];
    }
    self.lblGuessedResult.text = total_words;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showKeyboardOnLaunch
{
    
}
- (IBAction)hideKeyboard
{
    [self.myTextField resignFirstResponder];
}
#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
    }
}
- (IBAction)startNewGame
{
    [self startGame];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.gameCompleted) {
        UIAlertView *alertGameCompleted = [[UIAlertView alloc]
                                                 initWithTitle:@"Game finished"
                                                 message: @"You finished the game, start a new game for playing again"
                                                 delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [alertGameCompleted show];
    }else{
        NSString *myString = [self.myTextField.text lowercaseString];
        
        if (![myString isEqualToString:@""]) {
            
            //set total guessed chars in label
            self.lblTotalGuessed.text = [self getCountGuessed];
            
            BOOL doesWordExists = [self checkCharExistInWord: myString];
            
            self.guessedChars = [self.guessedChars stringByAppendingString:myString];
            self.guessedChars = [self.guessedChars stringByAppendingString:@", "];
            
            
            if (doesWordExists) {
                [self updateViewHangmanLabel:myString];
            }else{
                //set total guesses left in label
                self.guessesLeft = self.guessesLeft - 1;
                self.totalIncorrectGuesses++;
                self.lblGuessesLeft.text = [self getGuessesLeft];
                
                //update high score
                self.highScore = self.highScore - 3;
            }
            
            if ([self checkCompleted]){
                //show a screen to the player that he won
                self.lblResultWinLoos.text = @"Congratulations, you won!!";
                //add the highscore to the NSUserdefaults settings
                NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];

                NSArray * oldHighScores = [settings objectForKey:@"high_scores"];

                NSString *name = @"Berjan";

                
                NSMutableDictionary *highScoreDetail = [[NSMutableDictionary alloc]init];
                [highScoreDetail setObject:[NSNumber numberWithInt:self.highScore] forKey:@"high_score"];
                [highScoreDetail setObject:[NSNumber numberWithInt:self.totalIncorrectGuesses] forKey:@"guesses"];
                [highScoreDetail setObject:@"Berjan" forKey:@"name"];
                [highScoreDetail setObject:self.guessingWord forKey:@"word"];

                
                
                NSMutableArray * arrayScores = [[NSMutableArray alloc] init];
                [arrayScores addObject:highScoreDetail];
                
                for (NSArray *historyArray in oldHighScores) {
                    [arrayScores addObject:historyArray];
                }
                

                [settings setObject:arrayScores forKey:@"high_scores"];
                

                self.gameCompleted = true;
                
            }else{
                if([self checkGuessNext]){
                    //the player is able to continue
                }else{
                    //the player has lost
                    //show a screen to the player that he lost
                    self.lblResultWinLoos.text = @"What a shame, you lost :(";
                    self.gameCompleted = true;
                    self.highScore = 0;
                }
            }

        }
        
            }
   

    self.myTextField.text = @"";
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (self.gameCompleted) {
        return NO;
    }
    NSString *stringVal = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSCharacterSet *unacceptedInput = nil;
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:stringVal] invertedSet];
    // If there are any characters that I do not want in the text field, return NO.
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1) {
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }else{
        return NO;
    }

    
}

-(NSString *)getCountGuessed
{
    self.totalGuessed = self.totalGuessed + 1;
    NSString *integerAsString = [NSString stringWithFormat:@"%d", self.totalGuessed];
    return integerAsString;
}

- (void)setGuessesLeft
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger allowedGuessesSetting = [settings integerForKey:@"allowedGuesses"];
    if (allowedGuessesSetting == 0) {
        allowedGuessesSetting = 8;
    }
    self.guessesLeft = allowedGuessesSetting;

}
-(NSString *)getGuessesLeft
{
    
    NSString *integerAsString = [NSString stringWithFormat:@"%d", self.guessesLeft];
    return integerAsString;
}

-(void)updateViewHangmanLabel:(NSString *)guessedChar
{
    NSString *total_words = self.lblGuessedResult.text;
    
    NSRange searchRange = NSMakeRange(0,self.guessingWord.length);
    NSRange foundRange;
    while (searchRange.location < self.guessingWord.length) {
        searchRange.length = self.guessingWord.length-searchRange.location;
        foundRange = [self.guessingWord rangeOfString:guessedChar options:nil range:searchRange];
        if (foundRange.location != NSNotFound) {
            // found an occurrence of the substring! do stuff here
            total_words = [total_words stringByReplacingCharactersInRange:foundRange withString: guessedChar];
            searchRange.location = foundRange.location+foundRange.length;
        } else {
//            total_words = [total_words stringByAppendingString:@"- "];
            // no more substring to find
            break;
        }
    }
    

    self.lblGuessedResult.text = total_words;
}

- (void)setWordToBeGuessed
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    NSString *documentsPath = [paths objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"words2.plist"];
    
    // check to see if Data.plist exists in documents
    if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    {
        // if not in documents, get key value list from main bundle
        plistPath = [[NSBundle mainBundle] pathForResource:@"words2" ofType:@"plist"];
    }
    //getting the word file
    NSArray *wordsFile = [[NSArray alloc] initWithContentsOfFile:plistPath];
    //create a random index number based on the file we have
    
    
    NSUInteger maxLen= 0, strLen = 0;
    for(NSString *str in wordsFile) {
        strLen = [str length];
        if ( strLen > maxLen) {
            maxLen = strLen;
        }
    }
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger totalCharsToGuessSetting = [settings integerForKey:@"totalCharsToGuess"];
    if (totalCharsToGuessSetting == 0) {
        totalCharsToGuessSetting = 4;
    }
        
    
    NSLog(@"Longest Word Length = %d", maxLen);
    
    NSMutableArray *arrayWordBasedOnLength = nil;
    arrayWordBasedOnLength = [[NSMutableArray alloc] init];
    for(NSString *str in wordsFile) {
        NSUInteger size = [str length];
        if(size == totalCharsToGuessSetting){
            
            [arrayWordBasedOnLength addObject:str];
        }
    }
    
    uint32_t rnd = arc4random_uniform([arrayWordBasedOnLength count]);
    //getting the random word from the file
    NSString *randomObject = [arrayWordBasedOnLength objectAtIndex:rnd];
    //make sure the word is lowercase
    NSString *theChoosenWord = [randomObject lowercaseString];
    //write the word to the log, to test the application
    NSLog(@"test value: %@",theChoosenWord);
    
    self.guessingWord = theChoosenWord;
}
- (BOOL)checkCharExistInWord:(NSString*)guessedChar
{
    if ([self.guessingWord rangeOfString: guessedChar].location == NSNotFound) {
        return false;
    }else{
        return true;
    }

}
- (BOOL)checkCompleted
{
    if(self.guessesLeft - self.totalGuessed != 0){
        
        if([self.lblGuessedResult.text isEqualToString:self.guessingWord]){
            return true;
        }else{
            return false;
        }
    }else{
        return false;
    }
}
-(BOOL)checkGuessNext
{
    if(self.guessesLeft != 0){
        return true;
    }else{
        return false;
    }
}

-(void)showHistoryGuessedChars
{
    UIAlertView *alertHistoryGuessedChars = [[UIAlertView alloc]
                                    initWithTitle:@"History"
                                    message: self.guessedChars
                                    delegate:nil
                                    cancelButtonTitle:@"OK"
                                    otherButtonTitles:nil];
    [alertHistoryGuessedChars show];
}

-(void)showHighScoreBoard
{
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSArray * highScores = [settings objectForKey:@"high_scores"];
    
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"high_score"  ascending:YES];
    highScores=[highScores sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    

    
    NSMutableString *highScoreMessage = [[NSMutableString alloc] init];
    int positionScore =1;
    for (int i = ([highScores count]-1); i >=0; i--) {
        if (positionScore == 11) {
            break;
        }
        NSString *scoreboardString = [[NSString alloc]init];
        NSDictionary *highScoreDict = [highScores objectAtIndex:i];
        NSString *name = [highScoreDict objectForKey:@"name"];
        NSString *word = [highScoreDict objectForKey:@"word"];
        NSNumber *guesses = [highScoreDict objectForKey:@"guesses"];
        NSNumber *highScore = [highScoreDict objectForKey:@"high_score"];
        scoreboardString = [NSString stringWithFormat:@"%d. %@, %@, %@, %@\n", positionScore, name, word, guesses, highScore];
        positionScore++;
        [highScoreMessage appendString: scoreboardString];
    }
    
    UIAlertView *alertHighScoreBoard = [[UIAlertView alloc]
                                             initWithTitle:@"Name, Word, Incorrect, Score"
                                             message: highScoreMessage
                                             delegate:nil
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [alertHighScoreBoard show];
}

@end
