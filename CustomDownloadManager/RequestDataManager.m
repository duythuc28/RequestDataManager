//
//  RequestDataManager.m
//  CustomDownloadManager
//
//  Created by IOSDev on 12/1/15.
//  Copyright © 2015 IOSDev. All rights reserved.
//

#import "RequestDataManager.h"

static const NSInteger HTTP_RESPONSE_CODES_SUCCESS = 200;
@interface RequestDataManager ()
@property (strong, nonatomic) NSMutableURLRequest * uploadMultiPartRequest;
@end
@implementation RequestDataManager
static void * kDGProgressChanged = &kDGProgressChanged;
#pragma mark - Initialization

- (id)initWithUrl:(NSString *)url {
    self = [super init];
    if (self) {
        self.baseUrl = url;
    }
    return self;
}


#pragma mark - Request Method

- (void)requestDataSuccess:(void(^)(NSURLSessionTask * operation, id response))success
                   failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
     
     
     
     
     
                         failure:failure];
}

- (void)requestHTMLDataSuccess:(void(^)(NSURLSessionTask * operation, id response))success
                       failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
                         failure:failure];
}

- (void)requestAuthenticatedDataWithUserName:(NSString *)userName
                                    password:(NSString *)password
                                     success:(void(^)(NSURLSessionTask * operation, id response))success
                                    failure :(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:userName password:password];
    [self invokeRequestOperation:manager
                   requestMethod:self.requestMethod
                         success:success
                         failure:failure];
}


- (void)invokeRequestOperation:(AFHTTPSessionManager *)manager
                 requestMethod:(RequestMethod )requestMethod
                       success:(void(^)(NSURLSessionTask * operation, id response)) success
                       failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
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
-(void)getData:(AFHTTPSessionManager *)manager
       success:(void(^)(NSURLSessionTask * operation, id response)) success
       failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure  {
    // Using AFNetworking to get data
    [manager GET:self.baseUrl parameters:nil success:^(NSURLSessionTask *operation, id responseObject) {
        // success data
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
        if (response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - POST Method
- (void)postData:(AFHTTPSessionManager *)manager
         success:(void(^)(NSURLSessionTask * operation, id response)) success
         failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager POST:self.baseUrl parameters:self.parameters success:^(NSURLSessionTask *operation, id responseObject) {
        // success data
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
        if (response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - PUT Method
- (void)putData:(AFHTTPSessionManager *)manager
        success:(void(^)(NSURLSessionTask * operation, id response)) success
        failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager PUT:self.baseUrl parameters:self.parameters success:^(NSURLSessionTask *operation, id responseObject) {
        // success data
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
        if (response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}

#pragma mark - DELETE Method
- (void)deleteData:(AFHTTPSessionManager *)manager
           success:(void(^)(NSURLSessionTask * operation, id response)) success
           failure:(void(^)(NSURLSessionTask * operation, NSError * error)) failure {
    // Using AFNetworking to post data
    [manager DELETE:self.baseUrl parameters:self.parameters success:^(NSURLSessionTask *operation, id responseObject) {
        // success data
        NSHTTPURLResponse* response = (NSHTTPURLResponse*)operation.response;
        if (response.statusCode == HTTP_RESPONSE_CODES_SUCCESS) {
            success (operation , responseObject);
        } else {
            failure (operation , nil);
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        // failure
        failure (operation, error);
    }];
}
#pragma mark - DOWNLOAD file
- (void)downloadFileDataBlock:(void(^)(NSURLSession * session,
                                       NSURLSessionDownloadTask *downloadTask,
                                       int64_t bytesWritten,
                                       int64_t totalBytesWritten,
                                       int64_t totalBytesExpectedToWrite))block
            completionHandler:(void (^)(NSURLResponse *response,
                                        NSURL *filePath,
                                        NSError *error))completionHandler {
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrl]];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      
                                                                      NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                                             inDomain:NSUserDomainMask
                                                                                                                                    appropriateForURL:nil
                                                                                                                                               create:NO
                                                                                                                                                error:nil];
                                                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                  } completionHandler:^(NSURLResponse *response,
                                                                                        NSURL *filePath,
                                                                                        NSError *error) {
                                                                      completionHandler(response, filePath, error);
                                                                  }];
    [downloadTask resume];
    
    [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session,
                                                NSURLSessionDownloadTask *downloadTask,
                                                int64_t bytesWritten, int64_t totalBytesWritten,
                                                int64_t totalBytesExpectedToWrite) {
        block (session, downloadTask, bytesWritten , totalBytesWritten , totalBytesExpectedToWrite);
    }];
}

- (void)requestDataTaskProgress:(void (^) (NSProgress * progress)) progress
                completionHandler:(void (^)(NSURLResponse *response,
                                            NSURL *filePath,
                                            NSError *error))completionHandler {
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    [self invokeRequestWithSessionManager:session
          requestMethod:self.requestMethod
               progress:progress
      completionHandler:completionHandler];
}

- (void)invokeRequestWithSessionManager:(AFHTTPSessionManager *)session
        requestMethod:(RequestMethod)requestMethod
                           progress:(void(^)(NSProgress * progress))progress
                  completionHandler:(void (^)(NSURLResponse *response,NSURL *filePath,NSError *error))completionHandler {
    switch (requestMethod) {
        case DOWNLOAD: {
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.baseUrl]];
            [self downloadDataRequest:request
                       sessionManager:session
                             progress:progress
                    completionHandler:completionHandler];
        }
            break;
        case UPLOAD: {
            
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - DownLoad file
- (void)downloadDataRequest:(NSURLRequest *)request
             sessionManager:(AFHTTPSessionManager *)session
                   progress:(void (^) (NSProgress * progress)) progress
          completionHandler:(void (^)(NSURLResponse *response,NSURL *filePath,NSError *error))completionHandler {
    
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:request
                                                                     progress:nil
                                                                  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
                                                                      
                                                                      NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory
                                                                                                                                             inDomain:NSUserDomainMask
                                                                                                                                    appropriateForURL:nil
                                                                                                                                               create:NO
                                                                                                                                                error:nil];
                                                                      return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
                                                                  } completionHandler:^(NSURLResponse *response,
                                                                                        NSURL *filePath,
                                                                                        NSError *error) {
                                                                      completionHandler(response, filePath, error);
                                                                  }];
    [downloadTask resume];
    
    [session setDownloadTaskDidWriteDataBlock:^(NSURLSession *session,
                                                NSURLSessionDownloadTask *downloadTask,
                                                int64_t bytesWritten, int64_t totalBytesWritten,
                                                int64_t totalBytesExpectedToWrite) {
        NSProgress * tProgress = [NSProgress progressWithTotalUnitCount:totalBytesExpectedToWrite];
        [tProgress setCompletedUnitCount:totalBytesWritten];
        progress(tProgress);
    }];
}

#pragma mark - Upload file

- (void)uploadDataRequest:(NSURLRequest *)request
           sessionManager:(AFHTTPSessionManager *)session
                 progress:(void (^) (NSProgress * progress)) progress
        completionHandler:(void (^) (NSURLResponse *response,NSURL *filePath,NSError *error )) completionHandler {
    
    NSURLSessionUploadTask *uploadTask;
    NSProgress  * uploadProgress;
    uploadTask = [session uploadTaskWithStreamedRequest:self.uploadMultiPartRequest
                                               progress:&uploadProgress
                                      completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                                          completionHandler(response, nil, error);
    }];
    [uploadTask resume];
    
}

- (void)setUploadMultiPartRequestFile:(NSString *)fileName
                             filePath:(NSString *)filePath
                                 name:(NSString *)name
                             mimeType:(NSString *)mineType {
    self.uploadMultiPartRequest = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:self.baseUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath]
                                   name:name
                               fileName:fileName
                               mimeType:mineType
                                  error:nil];
    } error:nil];
}

@end
