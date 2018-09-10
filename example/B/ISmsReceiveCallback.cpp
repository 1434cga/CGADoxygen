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
 * ISmsReceiveCallback.cpp
 * @brief
 * Definition of ISmsReceiveCallback
 */

#include <binder/Parcel.h>

#include "Log.h"

#include "services/TelephonyManagerService/base/ISmsReceiveCallback.h"

#undef LOG_TAG
#define LOG_TAG "ISmsReceiveCallback"

using android::Parcel;
/**
 * Observer for receiving incoming message events. \n
 * Application those who wishes to receive incoming message events must implment this interface
 * and register with SMSService
 * @author
 * TBD
 * @note
 * SmsService name is @b "service_layer.SmsService" \n \n
 *
 * @note Typical usage of SmsReceiveCallback is as below \n
 * sp<ISmsReceiveCallback> callback = new instance of implmentation of ISmsReceiveCallback;
 *
 * @code
 * const sp<IServiceManager> sm(defaultServiceManager());
 *   if (sm != NULL) {
 *       sp<IBinder> smsServiceBinder = sm->getService(String16("service_layer.SmsService"));
 *       mSmsService = interface_cast<ISmsService>(smsServiceBinder);
 *   }
 * mSmsService->registerReceiveCallback(receiverID, callback);
 * ... \n
 * mSmsService->unregisterReceiveCallback(receiverID, callback);
 * @endcode
 *
 * @startuml
 * [ISmsReceiveCallback] <--down- SMSService
 * @enduml
 */
class BpSmsReceiveCallback : public android::BpInterface<ISmsReceiveCallback>
{
public:
    explicit BpSmsReceiveCallback(const android::sp<android::IBinder>& impl) :
            BpInterface<ISmsReceiveCallback>(impl) {
    }

    /**
     * @brief OnDataMessageReceived
     * @details Called when Data SMS is received.
     *
     * @startuml
     * participant App
     * participant ISmsReceiveCallback
     * participant SmsManager
     * participant BpSmsService
     * participant BnSmsService
     * participant SmsServiceStub
     * participant SmsService
     * participant InboundSmsHandler
     * participant GsmInboundSmsHandler
     * participant GsmSmsMessage
     * participant RIL

     * App->SmsManager : 1 **RegisterReceiver**\n(sp<ISmsReceiveCallback>&, int32_t)
     * activate SmsManager
     * note over SmsManager 
     * refer RegisterReceiver() interface
     * endnote
     * App<--SmsManager
     * deactivate SmsManager

     * RIL<-] : 2 RIL_UNSOL_RESPONSE_NEW_SMS
     * activate RIL
     * GsmSmsMessage<-RIL : 2.1 newFromCMT(sp<mindroid::String>&)
     * activate GsmSmsMessage
     * GsmSmsMessage-->RIL : 2.2 SmsMessage*
     * deactivate GsmSmsMessage
     * RIL->] : 2.3 notifyRegistrant(sp<AsyncResult>&)
     * deactivate RIL
     * GsmInboundSmsHandler<--] : 3 handleMessage(sp<sl::Message>&)
     * activate GsmInboundSmsHandler
     * InboundSmsHandler<- GsmInboundSmsHandler : 3.1 handleNewSms(sp<AsyncResult>&)
     * activate InboundSmsHandler
     * alt msg->what == EVENT_NEW_SMS 
     * InboundSmsHandler->InboundSmsHandler : 3.2 dispatchMessage(sp<SmsMessageBase>&)
     * activate InboundSmsHandler #DarkSalmon
     * InboundSmsHandler->GsmInboundSmsHandler : 3.3 dispatchMessageRadioSpecific(sp<SmsMessageBase>&)
     * activate GsmInboundSmsHandler #DarkSalmon
     * InboundSmsHandler<-GsmInboundSmsHandler : 3.4 dispatchNormalMessage(sp<SmsMessageBase>&)
     * deactivate GsmInboundSmsHandler
     * activate InboundSmsHandler #Chocolate
     * InboundSmsHandler->InboundSmsHandler : 3.5 processMessagePart(sp<SmsMessageBase>&)
     * activate InboundSmsHandler #IndianRed
     * InboundSmsHandler->InboundSmsHandler : 3.6 processUserData(sp<SmsMessageBase>&,sp<ByteArray>&)
     * activate InboundSmsHandler #Salmon
     * InboundSmsHandler->InboundSmsHandler : 3.7 decodeWapPdu(sp<ByteArray>)
     * activate InboundSmsHandler #Coral
     * BpSmsService<-InboundSmsHandler : 3.8 notifyDataMessageReceived(uint8_t*,size_t, char*, int32_t)
     * activate BpSmsService
     * deactivate InboundSmsHandler
     * deactivate InboundSmsHandler
     * deactivate InboundSmsHandler
     * deactivate InboundSmsHandler
     * deactivate InboundSmsHandler
     * BpSmsService->BnSmsService : 3.9 onTransact(uint32_t, \nParcel&,Parcel*,uint32_t)
     * deactivate BpSmsService
     * BnSmsService->SmsServiceStub : 3.10 notifyDataMessageReceived(uint8_t*,size_t, char*, int32_t)
     * activate SmsServiceStub
     * ISmsReceiveCallback<-SmsServiceStub : 3.11 OnDataMessageReceived(uint8_t*,size_t, char*, int32_t)
     * BnSmsService<--SmsServiceStub : status
     * deactivate SmsServiceStub
     * BpSmsService<--BnSmsService : status
     * activate BpSmsService
     * BpSmsService-->InboundSmsHandler : 3.12 status
     * deactivate BpSmsService
     * InboundSmsHandler->InboundSmsHandler : 3.13 notifyAndAcknowledgeLastIncomingSms(bool,int32_t)
     * activate InboundSmsHandler #DarkSalmon
     * InboundSmsHandler->GsmInboundSmsHandler : 3.14 acknowledgeLastIncomingSms(bool,int32_t)
     * activate GsmInboundSmsHandler #DarkSalmon
     * deactivate InboundSmsHandler
     * GsmInboundSmsHandler->RIL : 3.15 acknowledgeLastIncomingGsmSms(bool, int32_t,sp<sl::Message>&)
     * activate RIL
     * deactivate GsmInboundSmsHandler
     * RIL->RIL : 3.16 send(sp<RILRequest>)
     * activate RIL #DarkSalmon
     * deactivate RIL
     * deactivate RIL
     * deactivate GsmInboundSmsHandler
     * deactivate InboundSmsHandler
     * end

     * @enduml
     *
     * @ingroup SMS_MGR SMS_IN SMS_CB
     * @param[in] bytes     Data received
     * @param[in] length    Length of data received
     * @param[in] origAddr  Originating Address
     * @param[in] slotId    slotId of received data SMS
     * @return    void
	 * @SRS{TTF-SMS-001 , Receive the data message}
     */
    virtual void OnDataMessageReceived(const uint8_t* bytes, const size_t length, const char* origAddr, const int32_t slotId) {
        Parcel data;
        data.writeInterfaceToken(ISmsReceiveCallback::getInterfaceDescriptor());
        data.writeByteArray(length, bytes);
        data.writeCString(origAddr);
        data.writeInt32(slotId);
        remote()->transact(TRANSACTION_onDataMessageReceived, data, NULL /*, IBinder::FLAG_ONEWAY*/);
    }
    virtual void OnSyncMLNotificationReceived(const uint8_t* bytes, const size_t length, const char* origAddr, const int32_t slotId) {
        Parcel data;
        data.writeInterfaceToken(ISmsReceiveCallback::getInterfaceDescriptor());
        data.writeByteArray(length, bytes);
        data.writeCString(origAddr);
        data.writeInt32(slotId);
        remote()->transact(TRANSACTION_onSyncMLNotificationReceived, data, NULL /*, IBinder::FLAG_ONEWAY*/);
    }

    /**
     * @brief OnTextMessageReceived
     * @details Called when Text SMS is received.
     *
     * - ![OnTextMessageReceived](../PNG/OnTextMessageReceived.png)
     *
     * @param[in] text    Length of data received
     * @param[in] origAddr  Originating Address
     * @param[in] slotId    slotId of received data SMS
     * @return    void
	 *
	 * @SRS{TTF-SMS-002 , Text Message Received}
     */
    virtual void OnTextMessageReceived(const char* text, const char* origAddr, const int32_t slotId) {
        Parcel data;
        data.writeInterfaceToken(ISmsReceiveCallback::getInterfaceDescriptor());
        data.writeCString(text);
        data.writeCString(origAddr);
        data.writeInt32(slotId);
        remote()->transact(TRANSACTION_onTextMessageReceived, data, NULL /*, IBinder::FLAG_ONEWAY*/);
    }
};

IMPLEMENT_META_INTERFACE(SmsReceiveCallback, "service_layer.ISmsReceiveCallback");

/**
 * @brief Method for appropriate unmarshalling of transactions
 * @details Method for appropriate unmarshalling of SMS Receive callback transactions.
 *
 * @param [in] code The action to perform
 * @param [in] data Marshalled data to send to the target. Must not be null. If you are not sending any data, you must create an empty Parcel.
 * @param [out] reply Marshalled data to be received from the target. May be null if you are not interested in the return value.
 * @param [in] flags Additional operation flags.
 * @return status_t returns the status
 *
 * @startuml
 * participant TEST_METHOD_A
 * participant TEST_METHOD_B
 * TEST_METHOD_A -> TEST_METHOD_B
 * @enduml
 *
 * @SRS{TTF-SMS-001, appropriate unmarshalling of transactions}
 *
 */
android::status_t BnSmsReceiveCallback::OnTransact(
        uint32_t code, const Parcel& data, Parcel* reply, uint32_t flags) {
    switch(code) {
        case TRANSACTION_onDataMessageReceived: {
            CHECK_INTERFACE(ISmsService, data, reply);
            int32_t length = data.readInt32();
            const uint8_t* bytes = reinterpret_cast<const uint8_t*>(data.readInplace(static_cast<uint32_t>(length)));
            const char* origAddr = data.readCString();
            const int32_t slotId = data.readInt32();
            OnDataMessageReceived(bytes, static_cast<uint32_t>(length), origAddr, slotId);
        }
		break;
    	case TRANSACTION_onSyncMLNotificationReceived: {
            CHECK_INTERFACE(ISmsService, data, reply);
            int32_t length = data.readInt32();
            const uint8_t* bytes = reinterpret_cast<const uint8_t*>(data.readInplace(static_cast<uint32_t>(length)));
            const char* origAddr = data.readCString();
            const int32_t slotId = data.readInt32();
            OnSyncMLNotificationReceived(bytes, static_cast<uint32_t>(length), origAddr, slotId);
        }
		break;
        case TRANSACTION_onTextMessageReceived: {
            CHECK_INTERFACE(ISmsService, data, reply);
            const char* text = data.readCString();
            const char* origAddr = data.readCString();
            const int32_t slotId = data.readInt32();
            OnTextMessageReceived(text, origAddr, slotId);
        }
		break;
        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
    return android::NO_ERROR;
}
