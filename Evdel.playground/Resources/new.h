//
// Created by Lior Rozner on 22/4/13.


#import "WMLAPIResponse.h"

@class WMLUserProfile;
@class WMLUserInfo;
@class WMLUserProvider;

typedef NS_ENUM(NSUInteger, WMLAppUpdateLevel) {
    WMLAppUpdateLevelNone = 0,
    WMLAppUpdateLevelRecommended = 1,
    WMLAppUpdateLevelRequired = 2,
};


@interface WMLLoginResponse : WMLAPIResponse

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, readonly, getter=isNewUser) BOOL newUser;
@property (nonatomic, readonly) WMLAppUpdateLevel appUpdateLevel;
@property (nonatomic, copy, readonly) NSDictionary *featureFlags;
@property (nonatomic, copy, readonly) NSString *bucketName;
@property (nonatomic, copy, readonly) NSString *firstName;
@property (nonatomic, copy, readonly) NSString *lastName;
@property (nonatomic, copy, readonly) NSString *sweepstakesEmail;
@property (nonatomic, readonly) NSDate *sweepstakesRegistrationDate;
@property (nonatomic, copy, readonly) NSString *contactEmail;
@property (nonatomic, copy, readonly) NSString *installType;
@property (nonatomic, copy, readonly) NSString *agency;
@property (nonatomic, copy, readonly) NSString *mediaSource;
@property (nonatomic, copy, readonly) NSString *campaignName;
@property (nonatomic, copy, readonly) NSString *adSetName;
@property (nonatomic, copy, readonly) NSString *adGroupName;

@end


@interface WMLAuthenticationResponse : WMLAPIResponse

@property (nonatomic, copy, readonly) NSString *userId;
@property (nonatomic, copy, readonly) NSDictionary *featureFlags;
@property (nonatomic, copy, readonly) NSString *bucketName;
@property (nonatomic) WMLUserInfo *userInfo;
@property (nonatomic) WMLUserProvider *provider;
@property (nonatomic, copy, readonly) NSString *installType;
@property (nonatomic, copy, readonly) NSString *agency;
@property (nonatomic, copy, readonly) NSString *mediaSource;
@property (nonatomic, copy, readonly) NSString *campaignName;
@property (nonatomic, copy, readonly) NSString *adSetName;
@property (nonatomic, copy, readonly) NSString *adGroupName;

@end
