//
//  RequestDataManager.m
//  CustomDownloadManager
//
//  Created by IOSDev on 12/1/15.
//  Copyright © 2015 IOSDev. All rights reserved.
//

#import "RequestDataManager.h"

static const NSInteger HTTP_RESPONSE_CODES_SUCCESS = 200;
@implementation RequestDataManager


#pragma mark - Initialization

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.baseUrl = url;
    }
    return self;
}


#pragma mark - Request Method

- (void)requestDataSuccess:(void(^)(AFHTTPRequestOperation * operation, id response))success
                   failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
                         failure:failure];
}

- (void)requestHTMLDataSuccess:(void(^)(AFHTTPRequestOperation * operation, id response))success
                       failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
                         failure:failure];
}

- (void)requestAuthenticatedDataWithUserName:(NSString *)userName
                                    password:(NSString *)password
                                     success:(void(^)(AFHTTPRequestOperation * operation, id response))success
                                    failure :(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
                         failure:failure];
}


- (void)invokeRequestOperation:(AFHTTPRequestOperationManager *)manager
                 requestMethod:(RequestMethod )requestMethod
                       success:(void(^)(AFHTTPRequestOperation * operation, id response)) success
                       failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    switch (requestMethod) {
        case GET:
            [self getData:manager success:success failure:failure];
            break;
        case POST:
            [self postData:manager success:success failure:failure];
            break;
        case PUT:
            [self putData:manager success:success failure:failure];
            break;
        case DELETE:
            [self deleteData:manager success:success failure:failure];
            break;
        default:
            break;
    }
}
#pragma mark - GET Method
-(void)getData:(AFHTTPRequestOperationManager *)manager
       success:(void(^)(AFHTTPRequestOperation * operation, id response)) success
       failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure  {
    // Using AFNetworking to get data
    [manager GET:self.baseUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success data
        if (operation.response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - POST Method
- (void)postData:(AFHTTPRequestOperationManager *)manager
         success:(void(^)(AFHTTPRequestOperation * operation, id response)) success
         failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager POST:self.baseUrl parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success data
        if (operation.response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - PUT Method
- (void)putData:(AFHTTPRequestOperationManager *)manager
        success:(void(^)(AFHTTPRequestOperation * operation, id response)) success
        failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager PUT:self.baseUrl parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success data
        if (operation.response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - DELETE Method
- (void)deleteData:(AFHTTPRequestOperationManager *)manager
           success:(void(^)(AFHTTPRequestOperation * operation, id response)) success
           failure:(void(^)(AFHTTPRequestOperation * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager DELETE:self.baseUrl parameters:self.parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // success data
        if (operation.response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}
@end
