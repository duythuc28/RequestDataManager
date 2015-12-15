//
//  RequestDataManager.h
//  CustomDownloadManager
//
//  Created by IOSDev on 12/1/15.
//  Copyright © 2015 IOSDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
typedef enum {
    GET,
    POST,
    PUT,
    DELETE
} RequestMethod ;

@interface RequestDataManager : NSObject
@property (strong, nonatomic) NSDictionary * parameters;
@property (nonatomic) RequestMethod requestMethod;
@property (strong, nonatomic) NSString *baseUrl;
#pragma mark - Initialization
/**
 *  init instance with url
 *
 *  @param url request url
 *
 *  @return request data type
 */
- (id)initWithUrl:(NSString *)url;

#pragma mark - Request Method
/**
 *  Request RESTFul Service Data
 *
 *  @param success response data
 *  @param failure error code
 */
- (void)requestDataSuccess:(void(^)(AFHTTPRequestOperation * operation, id response))success
                   failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure;
/**
 *  Request RESTFul Service Data, content HTML header
 *
 *  @param success response data
 *  @param failure error code
 */
- (void)requestHTMLDataSuccess:(void(^)(AFHTTPRequestOperation * operation, id response))success
                       failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure;
@end
