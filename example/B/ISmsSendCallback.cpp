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
 * ISmsSendCallback.cpp
 * @brief
 * Definition of ISmsSendCallback
 */
#include <binder/Parcel.h>

#include "Log.h"

#include "services/TelephonyManagerService/base/ISmsSendCallback.h"

#undef LOG_TAG
#define LOG_TAG "ISmsSendCallback"

using android::Parcel;

enum {
    TRANSACTION_onMessageSent = android::IBinder::FIRST_CALL_TRANSACTION,
    TRANSACTION_onDeliveryReport,
};

class BpSmsSendCallback : public android::BpInterface<ISmsSendCallback>
{
public:
    explicit BpSmsSendCallback(const android::sp<android::IBinder>& impl) :
            BpInterface<ISmsSendCallback>(impl) {
    }

    virtual void OnMessageSent(int32_t status, int32_t errorCode, int32_t msgId, const int32_t slotId) {
        android::Parcel data;
        data.writeInterfaceToken(ISmsSendCallback::getInterfaceDescriptor());
        data.writeInt32(status);
        data.writeInt32(errorCode);
        data.writeInt32(msgId);
        data.writeInt32(slotId);
        remote()->transact(TRANSACTION_onMessageSent, data, NULL);
    }

    virtual void OnDeliveryReport(int32_t referenceNumber, const int32_t slotId) {
        android::Parcel data;
        data.writeInterfaceToken(ISmsSendCallback::getInterfaceDescriptor());
        data.writeInt32(referenceNumber);
        data.writeInt32(slotId);
        remote()->transact(TRANSACTION_onDeliveryReport, data, NULL);
    }
};

IMPLEMENT_META_INTERFACE(SmsSendCallback, "service_layer.ISmsSendCallback");

android::status_t BnSmsSendCallback::OnTransact(
        uint32_t code, const android::Parcel& data, android::Parcel* reply, uint32_t flags) {
    switch(code) {
        case TRANSACTION_onMessageSent: {
            CHECK_INTERFACE(ISmsSendCallback, data, reply);
            int32_t status = data.readInt32();
            int32_t errorCode = data.readInt32();
            int32_t msgId = data.readInt32();
            const int32_t slotId = data.readInt32();
            OnMessageSent(status, errorCode, msgId, slotId);
            return android::NO_ERROR;
        }

        case TRANSACTION_onDeliveryReport: {
            CHECK_INTERFACE(ISmsSendCallback, data, reply);
            int32_t referenceNumber = data.readInt32();
            const int32_t slotId = data.readInt32();
            OnDeliveryReport(referenceNumber, slotId);
            return android::NO_ERROR;
        }

        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
}

