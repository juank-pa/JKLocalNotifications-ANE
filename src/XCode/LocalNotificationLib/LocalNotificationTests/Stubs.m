//
//  Stubs.m
//  LocalNotificationLib
//
//  Created by Juan Carlos Pazmino on 7/21/17.
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <string.h>
#import "Stubs.h"
#import "Constants.h"

#ifdef __cplusplus
"C" {
#endif
    /* Context Data ************************************************************/
    void *nativeContext = NULL;
    void *sentFreContext = NULL;

    void *freObjectResult = "fre object";
    void *freObjectArgument;

    int32_t freObjectIntArgument;
    uint32_t freObjectUIntArgument;
    double freObjectDoubleArgument;
    uint32_t freObjectBoolArgument;

    FREObject freObjectString = "string";
    FREObject freObjectArray = "array";
    FREObject freObjectNumber = "number";
    FREObject freObjectBoolean = "boolean";
    FREObject freObjectNull = "null";
    const uint8_t* resultString = (uint8_t *)"result string";

    uint8_t *propertyName;
    FREByteArray resultByteArray = {7, (uint8_t *)"result"};
    FREObject byteArrayReleased;

    FREResult result(FREContext ctx) {
        return ctx == NULL? FRE_INVALID_ARGUMENT : FRE_OK;
    }

    /**
     * @returns FRE_OK
     *          FRE_WRONG_THREAD
     *          FRE_INVALID_ARGUMENT If nativeData is null.
     */

    FREResult FREGetContextNativeData( FREContext ctx, void** nativeData ) {
        sentFreContext = ctx;
        *nativeData = nativeContext;
        return result(ctx);
    }

    /**
     * @returns FRE_OK
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     */

    FREResult FRESetContextNativeData( FREContext ctx, void*  nativeData ) {
        sentFreContext = ctx;
        nativeContext = nativeData;
        return result(ctx);
    }

    /**
     * @returns FRE_OK
     *          FRE_WRONG_THREAD
     *          FRE_INVALID_ARGUMENT If actionScriptData is null.
     */

    FREResult FREGetContextActionScriptData( FREContext ctx, FREObject *actionScriptData ) {
        return result(ctx);
    }

    /**
     * @returns FRE_OK
     *          FRE_WRONG_THREAD
     */

    FREResult FRESetContextActionScriptData( FREContext ctx, FREObject  actionScriptData ) {
        return result(ctx);
    }

    /**
     * @returns FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_WRONG_THREAD
     *          FRE_INVALID_ARGUMENT If objectType is null.
     */

    FREResult FREGetObjectType( FREObject object, FREObjectType *objectType ) {
        if (object == freObjectString) {
            *objectType = FRE_TYPE_STRING;
        }
        if (object == freObjectArray) {
            *objectType = FRE_TYPE_ARRAY;
        }
        else if (object == freObjectNumber) {
            *objectType = FRE_TYPE_NUMBER;
        }
        else if (object == freObjectBoolean) {
            *objectType = FRE_TYPE_BOOLEAN;
        }
        else if (object == freObjectNull) {
            *objectType = FRE_TYPE_NULL;
        }
        else {
            return FRE_INVALID_OBJECT;
        }
        return result(object);
    }

    /**
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     */

    FREResult FREGetObjectAsInt32 ( FREObject object, int32_t  *value ) {
        *value = -30;
        freObjectArgument = object;
        return result(object);
    }
    FREResult FREGetObjectAsUint32( FREObject object, uint32_t *value ) {
        *value = 35;
        freObjectArgument = object;
        return result(object);
    }
    FREResult FREGetObjectAsDouble( FREObject object, double   *value ) {
        *value = 3.5;
        freObjectArgument = object;
        return result(object);
    }
    FREResult FREGetObjectAsBool  ( FREObject object, uint32_t *value ) {
        *value = 1;
        freObjectArgument = object;
        return result(object);
    }


    /**
     * @return  FRE_OK
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     */

    FREResult FRENewObjectFromInt32 ( int32_t  value, FREObject *object ) {
        freObjectIntArgument = value;
        freObjectArgument = &freObjectIntArgument;
        *object = freObjectResult;
        return result(object);
    }
    FREResult FRENewObjectFromUint32( uint32_t value, FREObject *object ) {
        freObjectUIntArgument = value;
        freObjectArgument = &freObjectUIntArgument;
        *object = freObjectResult;
        return result(object);
    }
    FREResult FRENewObjectFromDouble( double   value, FREObject *object ) {
        freObjectDoubleArgument = value;
        freObjectArgument = &freObjectDoubleArgument;
        *object = freObjectResult;
        return result(object);
    }
    FREResult FRENewObjectFromBool  ( uint32_t value, FREObject *object ) {
        freObjectBoolArgument = value;
        freObjectArgument = &freObjectBoolArgument;
        *object = freObjectResult;
        return result(object);
    }

    /**
     * Retrieves a string representation of the object referred to by
     * the given object. The referenced string is immutable and valid
     * only for duration of the call to a registered function. If the
     * caller wishes to keep the the string, they must keep a copy of it.
     *
     * @param object The string to be retrieved.
     *
     * @param length The size, in bytes, of the string. Includes the
     *               null terminator.
     *
     * @param value  A pointer to a possibly temporary copy of the string.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     */

    FREResult FREGetObjectAsUTF8(
                                 FREObject       object,
                                 uint32_t*       length,
                                 const uint8_t** value
                                 ) {
        freObjectArgument = object;
        *length = (uint32_t) strlen((char *)resultString);
        *value = resultString;
        return result(object);
    }

    /**
     * Creates a new String object that contains a copy of the specified
     * string.
     *
     * @param length The length, in bytes, of the original string. Must include
     *               the null terminator.
     *
     * @param value  A pointer to the original string.
     *
     * @param object Receives a reference to the new string object.
     *
     * @return  FRE_OK
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     */

    FREResult FRENewObjectFromUTF8(
                                   uint32_t        length,
                                   const uint8_t*  value ,
                                   FREObject*      object
                                   ) {
        freObjectArgument = (void *)value;
        *object = freObjectResult;
        return result(object);
    }

    /* Object Access **************************************************************/

    unsigned char byteArray[20] = {0};
    unsigned char *byteArrayPointer = NULL;

    /**
     * @param className UTF8-encoded name of the class being constructed.
     *
     * @param thrownException A pointer to a handle that can receive the handle of any ActionScript
     *            Error thrown during execution. May be null if the caller does not
     *            want to receive this handle. If not null and no error occurs, is set an
     *            invalid handle value.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from calling this method.
     *              In this case, thrownException will be set to the handle of the thrown value.
     *          FRE_ILLEGAL_STATE If a ByteArray or BitmapData has been acquired and not yet released.
     *          FRE_NO_SUCH_NAME
     *          FRE_WRONG_THREAD
     */

    FREResult FRENewObject(
                           const uint8_t* className      ,
                           uint32_t       argc           ,
                           FREObject      argv[]         ,
                           FREObject*     object         ,
                           FREObject*     thrownException
                           ) {
        if (strcmp((char *)className, "flash.utils.ByteArray") == 0) {
            memset(byteArray, 0, sizeof(unsigned char) * 20);
            byteArrayPointer = byteArray;
            *object = byteArray;
        }
        return result(object);
    }

    /**
     * @param propertyName UTF8-encoded name of the property being fetched.
     *
     * @param thrownException A pointer to a handle that can receive the handle of any ActionScript
     *            Error thrown during getting the property. May be null if the caller does not
     *            want to receive this handle. If not null and no error occurs, is set an
     *            invalid handle value.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *
     *          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from getting this property.
     *              In this case, thrownException will be set to the handle of the thrown value.
     *
     *          FRE_NO_SUCH_NAME If the named property doesn't exist, or if the reference is ambiguous
     *              because the property exists in more than one namespace.
     *
     *          FRE_ILLEGAL_STATE If a ByteArray or BitmapData has been acquired and not yet released.
     *
     *          FRE_WRONG_THREAD
     */

    FREResult FREGetObjectProperty(
                                   FREObject       object         ,
                                   const uint8_t*  propName       ,
                                   FREObject*      propValue      ,
                                   FREObject*      thrownException
                                   ) {
        freObjectArgument = object;
        propertyName = (uint8_t *)propName;
        if (strcmp((char *)propName, "invalidProperty") == 0) {
            return FRE_NO_SUCH_NAME;
        }
        *propValue = freObjectString;
        return result(object);
    }

    /**
     * @param propertyName UTF8-encoded name of the property being set.
     *
     * @param thrownException A pointer to a handle that can receive the handle of any ActionScript
     *            Error thrown during method execution. May be null if the caller does not
     *            want to receive this handle. If not null and no error occurs, is set an
     *            invalid handle value.
     *
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from getting this property.
     *              In this case, thrownException will be set to the handle of the thrown value.
     *
     *          FRE_NO_SUCH_NAME If the named property doesn't exist, or if the reference is ambiguous
     *              because the property exists in more than one namespace.
     *
     *          FRE_ILLEGAL_STATE If a ByteArray or BitmapData has been acquired and not yet released.
     *
     *          FRE_READ_ONLY
     *          FRE_WRONG_THREAD
     */

    FREResult FRESetObjectProperty(
                                   FREObject       object         ,
                                   const uint8_t*  propertyName   ,
                                   FREObject       propertyValue  ,
                                   FREObject*      thrownException
                                   ) {
        return result(object);
    }

    /**
     * @param methodName UTF8-encoded null-terminated name of the method being invoked.
     *
     * @param thrownException A pointer to a handle that can receive the handle of any ActionScript
     *            Error thrown during method execution. May be null if the caller does not
     *            want to receive this handle. If not null and no error occurs, is set an
     *            invalid handle value.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_ACTIONSCRIPT_ERROR If an ActionScript exception results from calling this method.
     *              In this case, thrownException will be set to the handle of the thrown value.
     *
     *          FRE_NO_SUCH_NAME If the named method doesn't exist, or if the reference is ambiguous
     *              because the method exists in more than one namespace.
     *
     *          FRE_ILLEGAL_STATE If a ByteArray or BitmapData has been acquired and not yet released.
     *
     *          FRE_WRONG_THREAD
     */

    FREResult FRECallObjectMethod (
                                   FREObject      object         ,
                                   const uint8_t* methodName     ,
                                   uint32_t       argc           ,
                                   FREObject      argv[]         ,
                                   FREObject*     result         ,
                                   FREObject*     thrownException
                                   ) {
        if(object == byteArray) {
            if (strcmp((char *)methodName, "writeByte") == 0 && argc >= 1) {
                *byteArrayPointer = *(char *)(argv[0]);
                byteArrayPointer++;
            }
        }
        return FRE_OK;
    }

    /**
     * Referenced data is valid only for duration of the call
     * to a registered function.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     *          FRE_ILLEGAL_STATE
     */

    FREResult FREAcquireBitmapData(
                                   FREObject      object         ,
                                   FREBitmapData* descriptorToSet
                                   ) {
        return FRE_OK;
    }

    /**
     * Referenced data is valid only for duration of the call
     * to a registered function.
     *
     * Use of this API requires that the extension and application must be packaged for
     * the 3.1 namespace or later.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     *          FRE_ILLEGAL_STATE
     */

    FREResult FREAcquireBitmapData2(
                                    FREObject      object         ,
                                    FREBitmapData2* descriptorToSet
                                    ) {
        return FRE_OK;
    }

    /**
     * BitmapData must be acquired to call this. Clients must invalidate any region
     * they modify in order to notify AIR of the changes. Only invalidated regions
     * are redrawn.
     *
     * @return  FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_WRONG_THREAD
     *          FRE_ILLEGAL_STATE
     *          FRE_TYPE_MISMATCH
     */

    FREResult FREInvalidateBitmapDataRect(
                                          FREObject object,
                                          uint32_t x      ,
                                          uint32_t y      ,
                                          uint32_t width  ,
                                          uint32_t height
                                          ) {
        return result(object);
    }
    /**
     * @return  FRE_OK
     *          FRE_WRONG_THREAD
     *          FRE_ILLEGAL_STATE
     *          FRE_TYPE_MISMATCH
     */

    FREResult FREReleaseBitmapData( FREObject object ) {
        return result(object);
    }

    /**
     * Referenced data is valid only for duration of the call
     * to a registered function.
     *
     * @return  FRE_OK
     *          FRE_TYPE_MISMATCH
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_WRONG_THREAD
     *          FRE_ILLEGAL_STATE
     */

    FREResult FREAcquireByteArray(
                                  FREObject     object        ,
                                  FREByteArray* byteArrayToSet
                                  ) {
        *byteArrayToSet = resultByteArray;
        byteArrayReleased = NULL;
        freObjectArgument = object;
        return result(object);
    }

    /**
     * @return  FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_ILLEGAL_STATE
     *          FRE_WRONG_THREAD
     */
    
    FREResult FREReleaseByteArray( FREObject object ) {
        byteArrayReleased = object;
        return result(object);
    }
    
    /* Array and Vector Access ****************************************************/
    
    /**
     * @return  FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_INVALID_ARGUMENT
     *          FRE_ILLEGAL_STATE
     *          FRE_TYPE_MISMATCH
     *          FRE_WRONG_THREAD
     */
    
    FREResult FREGetArrayLength(
                                FREObject  arrayOrVector,
                                uint32_t*  length
                                ) {
        *length = 2;
        return FRE_OK;
    }
    
    /**
     * @return  FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_TYPE_MISMATCH
     *          FRE_ILLEGAL_STATE
     *          FRE_INVALID_ARGUMENT If length is greater than 2^32.
     *
     *          FRE_READ_ONLY   If the handle refers to a Vector
     *              of fixed size.
     *
     *          FRE_WRONG_THREAD
     *          FRE_INSUFFICIENT_MEMORY
     */
    
    FREResult FRESetArrayLength(
                                FREObject  arrayOrVector,
                                uint32_t   length
                                ) {
        return result(arrayOrVector);
    }
    
    /**
     * If an Array is sparse and an element that isn't defined is requested, the
     * return value will be FRE_OK but the handle value will be invalid.
     *
     * @return  FRE_OK
     *          FRE_ILLEGAL_STATE
     *
     *          FRE_INVALID_ARGUMENT If the handle refers to a vector and the index is
     *              greater than the size of the array.
     *
     *          FRE_INVALID_OBJECT
     *          FRE_TYPE_MISMATCH
     *          FRE_WRONG_THREAD
     */
    
    FREResult FREGetArrayElementAt(
                                   FREObject  arrayOrVector,
                                   uint32_t   index        ,
                                   FREObject* value
                                   ) {
        *value = index == 0? freObjectString : freObjectArray;
        return result(arrayOrVector);
    }
    
    /**
     *
     * @return  FRE_OK
     *          FRE_INVALID_OBJECT
     *          FRE_ILLEGAL_STATE
     *
     *          FRE_TYPE_MISMATCH If an attempt to made to set a value in a Vector
     *              when the type of the value doesn't match the Vector's item type.
     *
     *          FRE_WRONG_THREAD
     */
    
    FREResult FRESetArrayElementAt(
                                   FREObject  arrayOrVector,
                                   uint32_t   index        ,
                                   FREObject  value
                                   ) {
        return result(arrayOrVector);
    }
    
    /* Callbacks ******************************************************************/

    const uint8_t* sentEventCode = NULL;
    const uint8_t* sentEventLevel = NULL;

    /** 
     * Causes a StatusEvent to be dispatched from the associated
     * ExtensionContext object.
     *
     * Dispatch happens asynchronously, even if this is called during
     * a call to a registered function.
     *
     * The ActionScript portion of this extension can listen for that event
     * and, upon receipt, query the native portion for details of the event
     * that occurred.
     *
     * This call is thread-safe and may be invoked from any thread. The string
     * values are copied before the call returns.
     *
     * @return  FRE_OK In all circumstances, as the referenced object cannot
     *              necessarily be checked for validity on the invoking thread.
     *              However, no event will be dispatched if the object is
     *              invalid or not an EventDispatcher.
     *          FRE_INVALID_ARGUMENT If code or level is NULL
     */

    FREResult FREDispatchStatusEventAsync(
                                          FREContext     ctx  ,
                                          const uint8_t* code ,
                                          const uint8_t* level
                                          ) {
        sentFreContext = ctx;
        sentEventCode = code;
        sentEventLevel = level;
        return FRE_OK;
    }

    void resetEvent() {
        sentFreContext = NULL;
        sentEventCode = NULL;
        sentEventLevel = NULL;
    }

    NSDictionary* FRPE_getApplicationLaunchOptions() {
        UILocalNotification *localNotification = [UILocalNotification new];
        localNotification.userInfo = @{
                                       JK_NOTIFICATION_CODE_KEY: @"NotificationCodeKey",
                                       JK_NOTIFICATION_DATA_KEY: @"NotificationDataKey"
                                       };
        return @{UIApplicationLaunchOptionsLocalNotificationKey: localNotification};
    }
    
#ifdef __cplusplus
}
#endif

//
// Notifications
//

// FRPE_ApplicationDidReceiveLocalNotification: Posted when the application
// receives a local notification. The userInfo dictionary contains the notification.
// Use the key FRPE_ApplicationDidReceiveLocalNotificationKey to access the value.
//
const NSString *const FRPE_ApplicationDidReceiveLocalNotification = @"FRPE_ApplicationDidReceiveLocalNotification";

// FRPE_ApplicationDidReceiveRemoteNotification: Posted when the application
// receives a remote notification. The userInfo dictionary contains the information
// associated with the remote notification.
// Use the key FRPE_ApplicationDidReceiveRemoteNotificationKey to access the value.
//
const NSString *const FRPE_ApplicationDidReceiveRemoteNotification = @"FRPE_ApplicationDidReceiveRemoteNotification";

// FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken: Posted when call
// to application:didRegisterForRemoteNotificationsWithDeviceToken: is received. The
// useInfo dictionary contains the device token passed as argument to the method.
// Use the FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey key to access the value.
//
const NSString *const FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken = @"FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken";

// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError: Posted when call to
// application:didFailToRegisterForRemoteNotificationsWithError: is received. The useInfo
// dictionary contains the error passed as argument to the method. Use the
// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey key to access the value.
//
const NSString *const FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError = @"FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError";

//
// UserInfo Dictionary Keys
//

// FRPE_ApplicationDidReceiveRemoteNotificationKey accesses an the UserInfo dictionary of
// FRPE_ApplicationDidReceiveRemoteNotification
//
const NSString *const FRPE_ApplicationDidReceiveRemoteNotificationKey = @"FRPE_ApplicationDidReceiveRemoteNotificationKey";

// FRPE_ApplicationDidReceiveLocalNotificationKey accesses an the UserInfo dictionary of
// FRPE_ApplicationDidReceiveLocalNotification
//
const NSString *const FRPE_ApplicationDidReceiveLocalNotificationKey = @"FRPE_ApplicationDidReceiveLocalNotificationKey";

// FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey accesses an the
// UserInfo dictionary of FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceToken
//
const NSString *const FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey = @"FRPE_ApplicationDidRegisterForRemoteNotificationsWithDeviceTokenKey";

// FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey accesses an the
// UserInfo dictionary of FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithError
//
const NSString *const FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey = @"FRPE_ApplicationDidFailToRegisterForRemoteNotificationsWithErrorKey";

@implementation StubNewFactory

@synthesize notificationCenter = _notificationCenter;

- (UNUserNotificationCenter *)notificationCenter {
    if (!_notificationCenter) {
        _notificationCenter = [StubNotificationCenter new];
    }
    return _notificationCenter;
}

@end

@implementation StubLegacyFactory

@synthesize application = _application;

- (UIApplication *)application {
    if (!_application) {
        _application = (id)[[StubApplication alloc] init];
    }
    return _application;
}

@end

@implementation StubApplication
@end

@implementation StubNotificationCenter

- (instancetype)init {
    return self;
}

@end

@implementation StubCenterDelegate
@end
