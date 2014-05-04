//
//  GamePlay.m
//  hangman
//
//  Created by Bruens IT on 04/05/14.
//  Copyright (c) 2014 bruens_uva. All rights reserved.
//

#import "GamePlay.h"

@implementation GamePlay



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self startGame];
    }
    return self;
}
-(void)startGame
{
    self.guessesLeft = 0;
    self.gamecompleted = false;
    
    //setting the total guessed a player can do
    
    self.totalGuessed = 0;
    
    [self setWordToBeGuessed];
    NSString *total_words = @"";
    
    for (int i=0; i < self.guessingWord.length; i++) {
        
        total_words = [total_words stringByAppendingString:@"-"];
    }
    self.getHypenGuessingWord = total_words;
    [self setGuessesLeft];
    self.highScore = 100;
    self.guessedChars = @"";
    self.totalIncorrectGuesses = 0;
    //setting the word to be guessed
    self.resultText = @"Playing...";
    [self createHighScoreString];


}
-(BOOL)validateInput:(NSString *)input theRange :(NSRange)range thirdValue:(NSString *)string
{
    if (self.gamecompleted) {
        return NO;
    }
    NSString *stringVal = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    NSCharacterSet *unacceptedInput = nil;
    unacceptedInput = [[NSCharacterSet characterSetWithCharactersInString:stringVal] invertedSet];
    // If there are any characters that I do not want in the text field, return NO.
    if ([[string componentsSeparatedByCharactersInSet:unacceptedInput] count] <= 1) {
        NSUInteger newLength = [input length] + [string length] - range.length;
        return (newLength > 1) ? NO : YES;
    }else{
        return NO;
    }

}

-(void)updateGameState:(NSString *)inputChar
{
    if (self.gamecompleted) {
        UIAlertView *alertGameCompleted = [[UIAlertView alloc]
                                           initWithTitle:@"Game finished"
                                           message: @"You finished the game, start a new game for playing again"
                                           delegate:nil
                                           cancelButtonTitle:@"OK"
                                           otherButtonTitles:nil];
        [alertGameCompleted show];
    }else{
        NSString *myString = [inputChar lowercaseString];
        
        if (![myString isEqualToString:@""]) {
            
            //set total guessed chars in label
            
            
            BOOL doesWordExists = [self checkCharExistInWord: myString];
            
            self.guessedChars = [self.guessedChars stringByAppendingString:myString];
            self.guessedChars = [self.guessedChars stringByAppendingString:@", "];
            self.totalGuessed = self.totalGuessed + 1;
            
            if (doesWordExists) {
                [self updateHypenGuessingWord:myString];
            }else{
                //set total guesses left in label
                self.guessesLeft = self.guessesLeft - 1;
                self.totalIncorrectGuesses = self.totalIncorrectGuesses+1;
                
                
                //update high score
                self.highScore = self.highScore - 3;
            }
            [self setStrTotalGuessed];
            [self setStrTotalGuessesLeft];
            
            if ([self checkCompleted]){
                //show a screen to the player that he won
                self.resultText = @"Congratulations, you won!!";
                //add the highscore to the NSUserdefaults settings
                NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
                
                NSArray * oldHighScores = [settings objectForKey:@"high_scores"];
                
                NSString *name = [settings objectForKey:@"name_player"] ;
                if (name == nil) {
                    name = @"Victor";
                }
                
                
                NSMutableDictionary *highScoreDetail = [[NSMutableDictionary alloc]init];
                [highScoreDetail setObject:[NSNumber numberWithInt:self.highScore] forKey:@"high_score"];
                [highScoreDetail setObject:[NSNumber numberWithInt:self.totalIncorrectGuesses] forKey:@"guesses"];
                [highScoreDetail setObject:name forKey:@"name"];
                [highScoreDetail setObject:self.guessingWord forKey:@"word"];
                
                
                
                NSMutableArray * arrayScores = [[NSMutableArray alloc] init];
                [arrayScores addObject:highScoreDetail];
                
                for (NSArray *historyArray in oldHighScores) {
                    [arrayScores addObject:historyArray];
                }
                
                
                [settings setObject:arrayScores forKey:@"high_scores"];
                [self createHighScoreString];
                
                self.gamecompleted = true;
                
            }else{
                if([self checkGuessNext]){
                    //the player is able to continue
                    self.resultText = @"Playing...";
                }else{
                    //the player has lost
                    //show a screen to the player that he lost
                    self.resultText = @"What a shame, you lost :(";
                    self.gamecompleted = true;
                    self.highScore = 0;
                }
            }
            
        }
        
    }
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

-(void)updateHypenGuessingWord: (NSString *)guessedChar
{
    NSString *total_words = self.getHypenGuessingWord;
    
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
    self.getHypenGuessingWord = total_words;

}
- (BOOL)checkCharExistInWord:(NSString*)guessedChar
{
    if ([self.guessingWord rangeOfString: guessedChar].location == NSNotFound) {
        return false;
    }else{
        return true;
    }
    
}
- (void)setGuessesLeft
{
    NSUserDefaults *settings = [NSUserDefaults standardUserDefaults];
    NSInteger allowedGuessesSetting = [settings integerForKey:@"allowedGuesses"];
    if (allowedGuessesSetting == 0) {
        allowedGuessesSetting = 8;
    }
    self.guessesLeft = allowedGuessesSetting;
    NSString *integerAsString = [NSString stringWithFormat:@"%d", self.guessesLeft];
    self.strTotalGuessesLeft = integerAsString;
    
}
-(void)setStrTotalGuessed
{
    NSString *integerAsString = [NSString stringWithFormat:@"%d", self.totalGuessed];
    self.strTotalGuessed = integerAsString;

}


-(void)setStrTotalGuessesLeft
{
    
    NSString *integerAsString = [NSString stringWithFormat:@"%d", self.guessesLeft];
    self.strTotalGuessesLeft = integerAsString;

}
- (BOOL)checkCompleted
{
    if(self.guessesLeft - self.totalGuessed != 0){
        
        if([self.getHypenGuessingWord isEqualToString:self.guessingWord]){
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
-(void)createHighScoreString
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
    self.highScoresMessage = highScoreMessage;
}
@end
