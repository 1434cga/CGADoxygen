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
 * ISmsReceiveCallback.h
 * @brief
 * Declaration of ISmsReceiveCallback
 */

#ifndef ISMS_RECEIVE_CALLBACK_H
#define ISMS_RECEIVE_CALLBACK_H

#include <binder/IInterface.h>
#include <binder/Parcel.h>

/**
 * @class ISmsReceiveCallback
 * @brief Observer for receiving incoming message events.
 * @details Application those who wishes to receive incoming message events must implment this interface
 * and register with SMSService
 * @author
 * TBD
 * @note
 * SmsService name is @b "service_layer.SmsService"
 *
 * @note Typical usage of SmsReceiveCallback is as below 
 * sp<ISmsReceiveCallback> callback = new instance of implmentation of ISmsReceiveCallback;
 *
 * @code
 * const sp<IServiceManager> sm(defaultServiceManager());
 *   if (sm != NULL) {
 *       sp<IBinder> smsServiceBinder = sm->getService(String16("service_layer.SmsService"));
 *       mSmsService = interface_cast<ISmsService>(smsServiceBinder);
 *   }
 * mSmsService->registerReceiveCallback(receiverID, callback);
 * mSmsService->unregisterReceiveCallback(receiverID, callback);
 * @endcode
 *
 * @startuml
 * [ISmsReceiveCallback] <--down- SMSService
 * @enduml
 */
class ISmsReceiveCallback : public android::IInterface
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
public:
    /**
     * Transaction status Message Received
     */
    enum {
        TRANSACTION_onDataMessageReceived = android::IBinder::FIRST_CALL_TRANSACTION,
        TRANSACTION_onSyncMLNotificationReceived,
        TRANSACTION_onTextMessageReceived,
    };
#endif
public:
#ifndef DOXYGEN_SHOULD_SKIP_THIS
    DECLARE_META_INTERFACE(SmsReceiveCallback);
#endif
    /**
     * @brief Called when Data SMS is received.
     * @details Called when Data SMS is received.
     *
     * @ingroup SMS_MGR SMS_IN SMS_CB
     * @param[in] bytes     Data received
     * @param[in] length    Length of data received
     * @param[in] origAddr  Originating Address
     * @param[in] slotId    slotId of received data SMS
     * @return    void
	 *
	 * @SRS{ TTF-SMS-001 , Data Message Received}
	 * @SRS{ TTF-SMS-002 , Data Message Received}
	 * @SRS{ TTF-SMS-003 , Data Message Received}
     */
    virtual void OnDataMessageReceived(const uint8_t* bytes, const size_t length, const char* origAddr, const int32_t slotId) = 0;
    /**
     * Called when SyncML notification is received.
     *
     * @ingroup SMS_MGR SMS_IN SMS_CB
     * @param[in] bytes     Data received
     * @param[in] length    Length of data received
     * @param[in] origAddr  Originating Address
     * @param[in] slotId    slotId of received SyncML notification
     * @return    void
	 * @SRS{ TTF-SMS-003 , call after receiving SyncML}
     */
    virtual void OnSyncMLNotificationReceived(const uint8_t* bytes, const size_t length, const char* origAddr, const int32_t slotId) = 0;

    /**
     * Called when text SMS is received.
     *
     * @ingroup SMS_MGR SMS_IN SMS_CB
     * @param[in] text      Text data received
     * @param[in] origAddr  Originating Address
     * @param[in] slotId    slotId of received text SMS
     * @return    void
	 * @SRS{ TTF-SMS-002 , call after receiving SMS}
     */
    virtual void OnTextMessageReceived(const char* text, const char* origAddr, const int32_t slotId) = 0;
};

// ----------------------------------------------------------------------------

/**
 * @class BnSmsReceiveCallback
 * @brief Unmarshalling of transactions
 * @details Unmarshalling of SMS Receive callback transactions
 * @date 2018.08.01.
 * @author modified by susanta.patra (susanta.patra@lge.com)
 */
class BnSmsReceiveCallback : public android::BnInterface<ISmsReceiveCallback>
{
#ifndef DOXYGEN_SHOULD_SKIP_THIS
public:
    virtual android::status_t OnTransact(uint32_t code,
                        const Parcel& data,
                        Parcel* reply,
                        uint32_t flags = 0);
#endif
};

#endif
