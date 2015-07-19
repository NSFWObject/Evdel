//
//  WMLRouteBuilder.h
//  Wondermall
//
//  Created by Sash Zats on 2/3/15.
//  Copyright (c) 2015 Wondermall Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WMLOpenStoreEventSource.h"
#import "WMLDealTypes.h"


@interface WMLRouteBuilder : NSObject

+ (instancetype)sharedRouteBuilder;

@end


@interface WMLRouteBuilder (Home)

- (NSURL *)storesURL;

- (NSURL *)savedListURL;

- (NSURL *)universalSearchURLWithQuery:(NSString *)searchTerm;

@end


@interface WMLRouteBuilder (Store)

- (NSURL *)storeURLForStoreId:(NSString *)storeId eventSource:(WMLOpenStoreEventSource)eventSource;

- (NSURL *)shippingPolicyURLForStoreId:(NSString *)storeId;

@end


@interface WMLRouteBuilder (CouponBook)

- (NSURL *)couponBookURL;

- (NSURL *)dealPopupForDealId:(NSString *)dealId source:(WMLOpenDealEventSource)source;

@end


@interface WMLRouteBuilder (Cart)

- (NSURL *)cartURL;

- (NSURL *)buyAtCartURLForStoreWithId:(NSString *)storeId;

@end
