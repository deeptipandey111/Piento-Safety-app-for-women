//
//  UIColor+Utility.h
//  Tapzo, Coraza
//
//  Created by Chengappa on 7/2/15.
//  Copyright (c) 2015 Akosha. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utility)
+ (UIColor *)colorWithHexString:(NSString *)hexString;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue;
+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorForAlphabet:(NSString*)alphabet;
+ (UIColor *)circleColorAtIndex:(int)index;
+ (UIColor *)themeColor;
+ (UIColor *)themeColorDark;
+ (UIColor *)darkGreyPlaceholderColor;
+ (UIColor *)searchBarBackgroundColorDefault;
+ (UIColor *)videoSelectedCellColor;
+ (UIColor *)videoUnSelectedCellColor;
+ (UIColor *)videoSeparatorColor;
+ (UIColor *)buttonBorderColor;
+ (UIColor *)tagColorYellow;
+ (UIColor *)tagColorGreen;
+ (UIColor *)darkPurpleColor;
+ (UIColor *)redLightBackgroundColor;
+ (UIColor *)yellowLightBackgroundColor;
+ (UIColor *)lightYellowCellBackgroundColor;
+ (UIColor *)greenLightBackgroundColor;
+ (UIColor *)smallLabelLightColor;
+ (UIColor *)collectionViewCellBorderColor;
+ (UIColor *)offerViewBorderColor;
+ (UIColor *)viewLightGreyColor;
+ (UIColor *)viewLightGreyColorwithAlpha:(CGFloat)alpha;
+ (UIColor *)brandColor;
+ (UIColor *)errorColor;
+ (UIColor *)strokeRedColor;
+ (UIColor *)textFieldTextColor;
+ (UIColor *)placeholderGreyColor;
+ (UIColor *)viewBackgroundColor;
+ (UIColor *)searchBarBackgroundColor;
+ (UIColor *)greenCouponCodeColor;
+ (UIColor *)searchBarBackgroundColorinLocationScreen;
+ (UIColor *)blankCardPlaceholderColor;
+ (UIColor *)searchBarTextColorinLocationScreen;
+ (UIColor *)searchBarTextColor;
+ (UIColor *)searchBarTintColor;
+ (UIColor *)tableViewLabelColor;
+ (UIColor *)tableViewBottomViewColor;
+ (UIColor *)tableViewBottomViewDarkColor;
+ (UIColor *)darkPlaceholderColor;
+ (UIColor *)filterSelectedColor;
+ (UIColor *)placeholderColor;
+ (UIColor *)lightSeperatorColor;
+ (UIColor *)searchBarLightGreyBackgroundColor;
+ (UIColor *)navigationBarTitleColor;
+ (UIColor *)tableViewSeparatorColor;
+ (UIColor *)tagCloudStrokeColor;
+ (UIColor *)tableViewBackgroundColor;
+ (UIColor *)cabTabGreyColor;
+ (UIColor *)tabGreyColor;
+ (UIColor *)feedCardBorderColor;
+ (UIColor *)textFieldUnSelectedColor;
+ (UIColor *)textFieldSelectedColor;
+ (UIColor *)tableViewTitleTextColor;
+ (UIColor *)movieIconColor;
+ (UIColor *)dndIconColor;
+ (UIColor *)horoscopeSelectionIconColor;
+ (UIColor *)lightText;
+ (UIColor *)newsIconColor;
+ (UIColor *)magazineIconColor;
+ (UIColor *)tableViewSubtitleTextColor;
+ (UIColor *)dealsIconColor;
+ (UIColor *)weatherIconColor;
+ (UIColor *)sportsIconColor;
+ (UIColor *)socialIconColor;
+ (UIColor *)pollutionIconColor;
+ (UIColor *)tvShowsIconColor;
+ (UIColor *)thermoMeterColorAtIndex:(int)index;
+ (UIColor *)tableViewRightDetailTextColor;
+ (UIColor *)aquaColor;
+ (UIColor *)twitterBrandColor;
+ (UIColor *)instagramBrandColor;
+ (UIColor *)youtubeBrandColor;
+ (UIColor *)sectionLineColor;
+ (UIColor *)searchBarPlaceholderColor;
+ (UIColor *)lighterAquaColor;
+ (UIColor *)lineColor21;
+ (UIColor *)lineColor117;
+ (UIColor *)unselectedMenuItemTitleColor;
+ (UIColor *)buttonColor;
+ (UIColor *)chatSenderMsgBackgroundColor;
+ (UIColor *)chatErrorMsgBackgroundColor;
+ (UIColor *)chatRecieverNameColor;
+ (UIColor *)chatWriteMsgTextColor;
+ (UIColor *)chatSendButtonTextColor;
+ (UIColor *)beautyServiceBubbleSelectedBackgroundColor;
+ (UIColor *)beautyServiceBubbleNormalBorderColor;
+ (UIColor *)beautyServiceBubbleSelectedBorderColor;
+ (UIColor *)orangebuttonColor;
+ (UIColor *)failedRedColor;
+ (UIColor *)chatSectionHeaderDateTitleColor;
+ (UIColor *)walkThroughButtonColor;
+ (UIColor *)chatUnreadMessageBackgroundColor;
+ (UIColor *)chatLoadPreviousMessageBackgroundColor;
+ (UIColor *)chatScreenBackgroundColor;
+ (UIColor *)chatTimelineColor;
+ (UIColor *)colorForBackground;
+ (UIColor *)colorForCabServiceDeclaimer;
+ (UIColor *)dealsCellTextColor;
@end
