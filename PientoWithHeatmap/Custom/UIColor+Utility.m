//
//  UIColor+Utility.m
//  Tapzo, Coraza
//
//  Created by Chengappa on 7/2/15.
//  Copyright (c) 2015 Akosha. All rights reserved.
//

#import "UIColor+Utility.h"

@implementation UIColor (Utility)
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    return [[self class] colorWithHexString:hexString alpha:1.0];
}

+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha
{
    if (hexString.length == 0) {
        return nil;
    }
    
    // Check for hash and add the missing hash
    if('#' != [hexString characterAtIndex:0])
    {
        hexString = [NSString stringWithFormat:@"#%@", hexString];
    }
    
    // check for string length
    assert(7 == hexString.length || 4 == hexString.length);
    
    // check for 3 character HexStrings
    hexString = [[self class] hexStringTransformFromThreeCharacters:hexString];
    
    NSString *redHex    = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(1, 2)]];
    unsigned redInt = [[self class] hexValueToUnsigned:redHex];
    
    NSString *greenHex  = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(3, 2)]];
    unsigned greenInt = [[self class] hexValueToUnsigned:greenHex];
    
    NSString *blueHex   = [NSString stringWithFormat:@"0x%@", [hexString substringWithRange:NSMakeRange(5, 2)]];
    unsigned blueInt = [[self class] hexValueToUnsigned:blueHex];
    
    UIColor *color = [UIColor colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
    
    return color;
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue
{
    return [[self class] colorWith8BitRed:red green:green blue:blue alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    UIColor *color = nil;
    color = [UIColor colorWithRed:(float)red/255 green:(float)green/255 blue:(float)blue/255 alpha:alpha];
    
    return color;
}

+ (NSString *)hexStringTransformFromThreeCharacters:(NSString *)hexString
{
    if(hexString.length == 4)
    {
        hexString = [NSString stringWithFormat:@"#%@%@%@%@%@%@",
                     [hexString substringWithRange:NSMakeRange(1, 1)],[hexString substringWithRange:NSMakeRange(1, 1)],
                     [hexString substringWithRange:NSMakeRange(2, 1)],[hexString substringWithRange:NSMakeRange(2, 1)],
                     [hexString substringWithRange:NSMakeRange(3, 1)],[hexString substringWithRange:NSMakeRange(3, 1)]];
    }
    
    return hexString;
}

+ (unsigned)hexValueToUnsigned:(NSString *)hexValue
{
    unsigned value = 0;
    
    NSScanner *hexValueScanner = [NSScanner scannerWithString:hexValue];
    [hexValueScanner scanHexInt:&value];
    
    return value;
}

+ (UIColor *)colorForAlphabet:(NSString*)alphabet{
    
    static NSArray* colorsArray = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorsArray = [UIColor colorsArrayFromPlist];
    });
    
    NSPredicate* predicateToGetColorCode = [NSPredicate predicateWithFormat:@"Alphabet = %@",alphabet.capitalizedString];
    NSArray* filteredArray = [colorsArray filteredArrayUsingPredicate:predicateToGetColorCode];
    
    if (filteredArray.count==1) {
        NSDictionary* colorInfo = filteredArray[0];
        NSString* colorCode = colorInfo[@"ColorCode"];
        return [UIColor colorWithHexString:colorCode];
    }
    else{
        return [UIColor colorWithHexString:@"607d8b"];
    }
    
    
}

+ (UIColor *)colorForBackground {
    NSArray *colorArray = @[
                            @"F3bd54",
                            @"ff7043",
                            @"4eceea",
                            @"938cf4",
                            @"6ee565",
                            @"fe75c5",
                            @"f53822",
                            @"f63e7f",
                            @"cd44e3",
                            @"8e51ff",
                            @"4d5ed0",
                            @"0f93f5",
                            @"35b1a5",
                            @"46c64b",
                            @"ccdc1f",
                            @"938cf4",
                            @"6ee565",
                            @"fe75c5",
                            ];
    NSUInteger index = arc4random_uniform((uint32_t) colorArray.count);
    
    return [UIColor colorWithHexString:[colorArray objectAtIndex:index]];
}

+(NSArray*)colorsArrayFromPlist{
    
    NSString  *plistPath = [[NSBundle mainBundle] pathForResource:@"ColorCodeList" ofType:@"plist"];
    
    NSArray* colorsArray = [NSArray arrayWithContentsOfFile:plistPath];
    
    return colorsArray;
}

+ (UIColor *)circleColorAtIndex:(int)index {
    if (index > 7) {
        return [UIColor themeColor];
    }
    return [@[                  [UIColor themeColor],
              [UIColor colorWithHexString:@"8C8C8C"],
              [UIColor colorWithHexString:@"00B9CC"],
              [UIColor colorWithHexString:@"D1DD26"],
              [UIColor colorWithHexString:@"FAA819"],
              [UIColor colorWithHexString:@"F05F48"],
              [UIColor colorWithHexString:@"333333"],
              [UIColor colorWithHexString:@"555555"]

              
             ] objectAtIndex:index];
}

+ (UIColor *)thermoMeterColorAtIndex:(int)index {
    if (index > 5) {
        return [UIColor colorWithHexString:@"f0624e"];
    }
    return [@[
              [UIColor colorWithHexString:@"6cd595"],
              [UIColor colorWithHexString:@"a1e478"],
              [UIColor colorWithHexString:@"ffd600"],
              [UIColor colorWithHexString:@"fe8102"],
              [UIColor colorWithHexString:@"ff846b"],
              [UIColor colorWithHexString:@"f0624e"],
              
              ] objectAtIndex:index];
    
}

+ (UIColor *)tagCloudStrokeColor {
    return [UIColor colorWithHexString:@"a58ccb"];
}

+ (UIColor *)themeColor{
    return [UIColor colorWithHexString:@"60379E"];

    //return [UIColor colorWithHexString:@"60379E"];
}
+ (UIColor *)sectionLineColor{
    return [UIColor colorWithHexString:@"D5D5D5"];
}
+ (UIColor *)themeColorDark{
    return [UIColor colorWithHexString:@"592c82"];
}
+ (UIColor *)darkGreyPlaceholderColor{
    return [UIColor colorWithHexString:@"3E3E3E"];
}
+ (UIColor *)buttonBorderColor{
    return [UIColor colorWithHexString:@"EBE2F8"];
}
+(UIColor *)darkPlaceholderColor{
    return [UIColor colorWithHexString:@"dcdcdc"];
}
+(UIColor *)filterSelectedColor{
    return [UIColor colorWithHexString:@"2FBE60"];
}
+(UIColor *)lightSeperatorColor{
    return [UIColor colorWithHexString:@"f1f1f1"];
}
+(UIColor *)cabTabGreyColor{
    return [UIColor colorWithHexString:@"989898"];
}

+(UIColor *)placeholderColor{
    return [UIColor colorWithHexString:@"e2e2e2"];
}
+(UIColor *)searchBarLightGreyBackgroundColor{
    return [UIColor colorWithHexString:@"E8E7E7"];
}

+ (UIColor *)smallLabelLightColor{
  return [UIColor colorWithHexString:@"757F7E"];   
}

+ (UIColor *)collectionViewCellBorderColor{
    return [UIColor colorWithHexString:@"E2E2E2"];
}
+ (UIColor *)offerViewBorderColor{
    return [UIColor colorWithHexString:@"B3B3B3"];
}

+(UIColor *)viewLightGreyColor{
    return [UIColor colorWithHexString:@"EDEDED"];
}

+ (UIColor *)viewLightGreyColorwithAlpha:(CGFloat)alpha{
    return [[self class] colorWithHexString:@"#EFEFF4" alpha:alpha];
}

+ (UIColor *)brandColor{
    return [UIColor colorWithHexString:@"FA5858"];
}
+ (UIColor *)lightText{
    return [UIColor colorWithHexString:@"666666"];
}

+ (UIColor *)strokeRedColor {
    return [UIColor colorWithHexString:@"E1523B"];
}

+ (UIColor *)placeholderGreyColor {
    return [UIColor colorWithHexString:@"757F7E"];
}

+ (UIColor *)blankCardPlaceholderColor {
    return [UIColor colorWithHexString:@"e8e6e7"];
}

+ (UIColor *)textFieldTextColor {
    return [UIColor colorWithHexString:@"2B2B2B"];
}

+ (UIColor *)viewBackgroundColor{
    return [UIColor colorWithHexString:@"F6F6F6"];

}
+ (UIColor *)redLightBackgroundColor{
    return [UIColor colorWithHexString:@"EE5E47"];
    
}
+ (UIColor *)yellowLightBackgroundColor{
    return [UIColor colorWithHexString:@"F5B51B"];
    
}

+ (UIColor *)lightYellowCellBackgroundColor{
    return [UIColor colorWithHexString:@"F8F3A9"];
}

+ (UIColor *)greenLightBackgroundColor{
    return [UIColor colorWithHexString:@"5DB739"];
}

+ (UIColor *)tagColorYellow {
    return [UIColor colorWithHexString:@"F8A91B"];
}

+ (UIColor *)tagColorGreen {
    return [UIColor colorWithHexString:@"03b00f"];
}

+ (UIColor *)greenCouponCodeColor {
    return [UIColor colorWithHexString:@"00C853"];
}

+(UIColor *) searchBarTextColorinLocationScreen {
    return  [UIColor colorWithHexString:@"EEEEEE"];
}
+(UIColor *) searchBarBackgroundColorinLocationScreen{
    return  [UIColor colorWithHexString:@"7548bb"];
}

+(UIColor *) searchBarBackgroundColor{
    return  [UIColor colorWithHexString:@"E6E6E8"];
}
+(UIColor *)searchBarTextColor{
     return [[self class] colorWith8BitRed:21 green:21 blue:21];
}
+(UIColor *)searchBarTintColor{
    return [UIColor colorWithHexString:@"F05F48"];
}
+(UIColor *)searchBarPlaceholderColor{
    return [UIColor colorWithHexString:@"EEEEEE"];
}
+(UIColor *)tableViewLabelColor{
    return [UIColor colorWithHexString:@"151515"];
}
+(UIColor *)tableViewBottomViewColor{
    return [UIColor colorWithHexString:@"E8E8E8"];
}
+ (UIColor *)tableViewBottomViewDarkColor{
    return [UIColor colorWithHexString:@"C8C7CC"];
}

+ (UIColor *)walkThroughButtonColor{
    return [UIColor colorWithHexString:@"FAA819"];
}

+ (UIColor *)errorColor {
    return [UIColor colorWithHexString:@"FF6060"];
}

+ (UIColor *)darkPurpleColor {
    return [UIColor colorWithHexString:@"503c6e"];
}

+ (UIColor *)tableViewBackgroundColor {
    return [UIColor colorWithHexString:@"F2F2F2"];
}
+ (UIColor *)tabGreyColor {
    return [UIColor colorWithHexString:@"BFBFBF"];
}

+ (UIColor *)navigationBarTitleColor
{
    return [UIColor colorWithHexString:@"FFFFFF"];
}

+ (UIColor *)movieIconColor {
    return [UIColor colorWithHexString:@"FE243E"];
}

+ (UIColor *)newsIconColor {
    return [UIColor colorWithHexString:@"00B9CC"];
}

+ (UIColor *)horoscopeSelectionIconColor {
    return [UIColor colorWithHexString:@"4fb0e7"];
}

+ (UIColor *)dealsIconColor {
    return [UIColor colorWithHexString:@"46C64B"];
}
+ (UIColor *)weatherIconColor {
    return [UIColor colorWithHexString:@"FFCE0A"];
}
+ (UIColor *)sportsIconColor {
    return [UIColor colorWithHexString:@"024282"];
}

+ (UIColor *)socialIconColor {
    return [UIColor colorWithHexString:@"f18a2e"];
}


+ (UIColor *)twitterBrandColor {
    return [UIColor colorWithHexString:@"55acee"];
}

+ (UIColor *)instagramBrandColor {
    return [UIColor colorWithHexString:@"3f729b"];
}

+ (UIColor *)youtubeBrandColor {
    return [UIColor colorWithHexString:@"cd201f"];
}

+ (UIColor *)textFieldUnSelectedColor {
    return [UIColor colorWithHexString:@"D2D2D2"];
}

+ (UIColor *)videoSelectedCellColor {
    return [UIColor colorWithHexString:@"212327"];
}
+ (UIColor *)videoUnSelectedCellColor {
    return [UIColor colorWithHexString:@"16171a"];
}
+ (UIColor *)videoSeparatorColor {
    return [UIColor colorWithHexString:@"353537"];
}

+ (UIColor *)textFieldSelectedColor {
    return [UIColor themeColor];
}

+ (UIColor *)tvShowsIconColor{
    return [UIColor colorWithHexString:@"#942cd6"];
}

+ (UIColor *)pollutionIconColor {
    return [UIColor colorWithHexString:@"657372"];
}

+ (UIColor *)dndIconColor {
    return [UIColor colorWithHexString:@"f05f48"];
}

+ (UIColor *)magazineIconColor {
    return [UIColor colorWithHexString:@"7219F7"];
}

+ (UIColor *)feedCardBorderColor {
    return [UIColor colorWithHexString:@"EDEDED"];
}

+ (UIColor *)tableViewSeparatorColor
{
    return [[self class] colorWith8BitRed:200 green:199 blue:204];
}

+ (UIColor *)tableViewTitleTextColor
{
    return [[self class] colorWith8BitRed:21 green:21 blue:21];
}

+ (UIColor *)tableViewSubtitleTextColor
{
    return [[self class] colorWith8BitRed:129 green:129 blue:129];
}

+ (UIColor *)tableViewRightDetailTextColor
{
    return [[self class] colorWith8BitRed:149 green:156 blue:155];
}

+ (UIColor *)aquaColor
{
    return [[self class] colorWith8BitRed:0 green:185 blue:206];
}

+ (UIColor *)lighterAquaColor
{
    return [[self class] colorWith8BitRed:0 green:185 blue:204];
}

+ (UIColor *)lineColor21
{
    return [[self class] colorWith8BitRed:21 green:21 blue:21];
}

+ (UIColor *)lineColor117{
    return [[self class] colorWith8BitRed:117 green:117 blue:117];
}

+ (UIColor *)unselectedMenuItemTitleColor
{
    return [[self class] colorWith8BitRed:201 green:201 blue:201];
}

+ (UIColor *)buttonColor
{
    return [UIColor colorWithHexString:@"f05f48"];
}

+ (UIColor *)chatSenderMsgBackgroundColor
{
    return [[self class] colorWith8BitRed:0 green:185 blue:206];
}

+ (UIColor *)chatErrorMsgBackgroundColor
{
    return [[self class] colorWith8BitRed:0 green:185 blue:206 alpha:0.3];
}

+ (UIColor *)chatRecieverNameColor
{
    return [[self class] colorWith8BitRed:240 green:95 blue:72];
}

+ (UIColor *)chatWriteMsgTextColor
{
    return [[self class] colorWith8BitRed:200 green:200 blue:205];
}

+ (UIColor *)chatSendButtonTextColor
{
    return [[self class] colorWith8BitRed:149 green:156 blue:155];
}

+ (UIColor *)beautyServiceBubbleSelectedBackgroundColor
{
    return [[self class] colorWith8BitRed:240 green:95 blue:72];
}

+ (UIColor *)beautyServiceBubbleNormalBorderColor
{
    return [[self class] colorWith8BitRed:227 green:227 blue:227];
}

+ (UIColor *)beautyServiceBubbleSelectedBorderColor
{
    return [[self class] colorWith8BitRed:176 green:15 blue:0];
}

+ (UIColor *)orangebuttonColor
{
    return [UIColor colorWithHexString:@"F16F5A"];
}

+ (UIColor *)failedRedColor
{
    return [UIColor colorWithRed:240/255.0 green:95/255.0 blue:72/255.0 alpha:1.0];
}

+ (UIColor *)chatSectionHeaderDateTitleColor
{
    return [UIColor colorWithRed:142/255.0 green:142/255.0 blue:147/255.0 alpha:1.0];
}

+ (UIColor *)chatUnreadMessageBackgroundColor
{
    return [UIColor colorWithRed:218/255.0 green:228/255.0 blue:121/255.0 alpha:1.0];
}

+ (UIColor *)chatLoadPreviousMessageBackgroundColor
{
    return [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:1.0];
}

+ (UIColor *)chatScreenBackgroundColor
{
    return [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
}

+ (UIColor *)chatTimelineColor
{
    return [UIColor colorWithRed:201/255.0 green:201/255.0 blue:201/255.0 alpha:1.0];
}
+ (UIColor *)colorForCabServiceDeclaimer
{
    return [UIColor colorWithHexString:@"#603B9C"];
}
+ (UIColor *)dealsCellTextColor {
    return [UIColor colorWithHexString:@"#333333"];
}
@end
