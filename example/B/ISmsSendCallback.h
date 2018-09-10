/*
 * Copyright (C) 2006 The Android Open Source Project
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
 * ISmsSendCallback.h
 * @brief
 * Declaration of ISmsSendCallback
 */


#ifndef ISMS_SEND_CALLBACK_H
#define ISMS_SEND_CALLBACK_H

#include <binder/IInterface.h>
#include <binder/Parcel.h>

/**
 * @class ISmsSendCallback
 * @brief Observer for handling SMS send events.
 * @details Application those who wishes to send message events must implment this interface
 * and pass this instance as callback to SMS send APIs.
 * @author
 * xxx.yyy
 * @note
 * SmsService name is @b "service_layer.SmsService" \n \n
 *
 * Typical usage of ISmsSendCallback is as below \n
 * @code 
 * sp<ISmsSendCallback> callback = new instance of implmentation of ISmsSendCallback;\n\n
 *
 * const sp<IServiceManager> sm(defaultServiceManager());\n\n
 *   if (sm != NULL) {\n\n
 *       sp<IBinder> smsServiceBinder = sm->getService(String16("service_layer.SmsService"));\n\n
 *       mSmsService = interface_cast<ISmsService>(smsServiceBinder);\n\n
 *   }\n\n
 * mSmsService->sendText(destAddr, scAddr, text, callback, true);\n\n
 * ... \n
 * @endcode
 *
 * @startuml
 * [ISmsSendCallback] <--down- SMSService
 * @enduml
 */
class ISmsSendCallback : public android::IInterface
{
public:
#ifndef DOXYGEN_SHOULD_SKIP_THIS
    DECLARE_META_INTERFACE(SmsSendCallback);
#endif
     /**
     * @brief OnMessageSent
     * @details Called when message sent operation is finished (TRANSACTION_onMessageSent code Received). This callback is called for both Success and failure case.
     * Also for single part message this is called immediately after send operation, but for multipart message
     * this call back is called only after the last part is sent
     *
     * @ingroup SMS_MGR SMS_OUT SMS_CB
     * @param [in] status       Status code of Message sent (0)ERROR_NONE, (1)GENERIC_FAILURE, (2)RADIO_OFF, (3)NULL_PDU, (4)NO_SERVICE, (5)LIMIT_EXCEEDED, (6)FDN_CHECK_FAILURE
     * @param [in] errorCode    Error codes on failure 0 if successful, the others values otherwise
     * @param [in] msgId        Unique ID of Message sent
     * @param [in] slotId       slotId of SMS sent
     * @return    void
     * @note       enum status code in SmsManagerConstants.h
     */
    virtual void OnMessageSent(int32_t status, int32_t errorCode, int32_t msgId, const int32_t slotId) = 0;

    /**
     * @brief OnDeliveryReport
     * @details Called when delivery report for an already sent message is received. (TRANSACTION_onDeliveryReport code Received)
     *
     * @ingroup SMS_MGR SMS_OUT SMS_CB
     * @param [in] referenceNumber     Unique ID of Message for which Delivery Report requested
     * @param [in] slotId              slotId of SMS for which Delivery Report requested
     * @return    void
     * @note As of now this is not supported
     */
    virtual void OnDeliveryReport(int32_t referenceNumber, const int32_t slotId) = 0;
};

// ----------------------------------------------------------------------------

/**
 * @class BnSmsSendCallback
 * @brief Unmarshalling of transactions
 * @details Unmarshalling of SMS Send callback transactions
 * @date 2018.08.01.
 * @author modified by susanta.patra (susanta.patra@lge.com)
 */
class BnSmsSendCallback : public android::BnInterface<ISmsSendCallback>
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
public:
    virtual ~BnSmsSendCallback() {}

    /**
     * @brief Method for appropriate unmarshalling of transactions
     * @details Method for appropriate unmarshalling of SMS Send callback transactions
     *
     * @param [in] code The action to perform
     * @param [in] data Marshalled data to send to the target. Must not be null. If you are not sending any data, you must create an empty Parcel.
     * @param [in] reply Marshalled data to be received from the target. May be null if you are not interested in the return value.
     * @param [in] flags Additional operation flags.
     * @return status_t returns the status
     */
    virtual android::status_t OnTransact(uint32_t code,
                        const android::Parcel& data,
                        android::Parcel* reply,
                        uint32_t flags = 0);
#endif
};

#endif

