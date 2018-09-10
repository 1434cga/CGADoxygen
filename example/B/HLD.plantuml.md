
# About This Document
## Document Information


| Issuing authority  | LG VC Smart SW Platform Team      |
| ------------------ | --------------------------------- |
| Configuration ID   | LGE_VC_Telephony       |
| Status of document | In Progress / Approved / Released |

## Revision History
| Version | Date       | Comment         | Author                             | Approver |
| ------- | ---------- | --------------- | ---------------------------------- | -------- |
| 0.9     | 2018-07-20 | Initial Release | Susanta Patra <susanta.patra@lge.com> |          |



## Purpose
This document specifies the Software Detailed Design (SDD) for the SMS Manager including the static design, dynamic design, and algorithm design.

## Scope
This document identifies the class consisting of each component from SAD, and describes the behaviors of those classes to accomplish the requirements upon them

## Audience
- The target audience of this document is:
	- Software architect who will evaluate the design of the software
	- Component developer who will implement the design in actual code
	- Native application developers who need to use SMS Manager
	- Cheetah project participants who want to understand the low level design of the SMS Manager
	- Test engineers who verify this component

## Related Documents
- SAD (Software Architectural Design)

## Conventions
- This document remarks “NOTE” as follows

NOTE
> To describe information that helps audience’s conveniences.

## Acronyms
| Acronym | Description                   |
| ------- | ----------------------------- |
| SAD     | Software Architectural Design |
| SDD     | Software Detailed Design      |


## Glossary (Optional)
| Glossary        | Description      |
| --------------- | ---------------- |
| SMSManager[^1] | SMS Manager |

[^1]: SMS Manager

# Architecture
This is the software architecture design of Telephony Framework which consists of Telephony Manager Service and Interface layer.

Telephony Manager Service (TMS) is logically divided into services and Telephony core.

Services consist of Telephony Service, SMS Service, Data Service, Network Query Service and Telephony Registry.

Core Telephony framework handles functionalities like Service state, Call, IMS, Data, SMS, UICC and it also acts as an interface layer to communicate to RIL/NAD.

Telephony Interface layer which contains SMS Manager, Call Manager, Data Manager, Uicc Manager, Phone Manager, Ims Manager which acts as the interface to other services and application to use telephony features.

- ![Architecture Component](../PNG/Architecture1.png)
- ![Figure 1 Overall Software Architecture Design](../PNG/Architecture2.png)

# SMS Manager Component
## External Design
- App sends request to SMS Manager for getting SMSC address, setting SMSC address, sending data SMS and sending text SMS

```puml external_design : External Interaction Design for SMS Manager Component

box "external design"
participant App
participant SmsManager #Cyan
participant BpSmsService #Cyan
participant BnSmsService #Cyan
participant SmsService #Cyan
participant RIL

App->SmsManager : SendRequest()
SmsManager->BpSmsService : SendRequest()
BpSmsService->BnSmsService : onTransact(code, data, reply, flags)
BnSmsService->SmsService : SendRequest()
SmsService->RIL : SendRequest()
end box
```

| Related External SW Component | Interface Name | Direction | Descriptions |
| ------- | ----------------------------- | -------------- | ----------------- |
| App     | SendRequest | OUT | Send Request to sms manager to get SMSC address, set SMSC address, send data SMS and send text SMS |
| SmsManager     | SendRequest | IN | App will send the request to SmsManager for the requested operation |
| SmsManager     | SendRequest | OUT | Smsmanager then forwards the request to BpSmsService instance |
| BpSmsService     | SendRequest | IN | It receives the request from sms manager to process it via onTransact |
| BpSmsService     | onTransact | OUT | It forwards the request to BnSmsService interface |
| BnSmsService     | onTransact | IN | onTransact BnSmsService is called |
| BnSmsService     | SendRequest | OUT | BnSmsService instance will invoke the SmsService instance that will handle the request |
| SmsService     | SendRequest | IN | It takes the request |
| SmsService     | SendRequest | OUT | Passes the request to RIL |


## Internal Design
### Static Design
- The class diagram for the SMS Manager is shown below:

```puml static_design : Detailed Class Diagram
left to right direction
skinparam legendBackgroundColor yellow
skinparam legendFontColor blue
skinparam legendFontSize 16
skinparam legendFontStyle bold

class SmsManager << (S,#FF7700) Singleton >> {
-mSmsService
+checkSmsService()
+sendSms()
+sendSmsText()
+getServiceCenterAddress()
+setServiceCenterAddress()
+registerReceiver()
+unregisterReceiver()
-SmsManager()
-~SmsManager()
-checkSmsServiceImpl()
-sendSmsImpl()
-sendSmsTextImpl()
-getServiceCenterAddressImpl()
-setServiceCenterAddressImpl()
-registerReceiverImpl()
-unregisterReceiverImpl()
}

interface ISmsService {
}
class BpSmsService {
+sendData()
+sendText()
+registerReceiveCallback()
+unregisterReceiveCallback()
+getServiceCenterAddress()
+setServiceCenterAddress()
+notifyDataMessageReceived()
+notifySyncMLNotificationReceived()
+notifyTextMessageReceived()
}
class BnSmsService {
+onTransact()
}

class SmsService {
-mHandler
-mIccSmsIfMngr
+SmsService()
+~SmsService()
+onInit()
+instantiate()
-sendRequest()
-sendRequestAsync()
}
class Record {
-callback
}
interface ISmsReceiveCallback {
+onDataMessageReceived()
+onTextMessageReceived()
+onSyncMLNotificationReceived()
}
class BpSmsReceiveCallback {
+onDataMessageReceived()
+onTextMessageReceived()
+onSyncMLNotificationReceived()
}
class BnSmsReceiveCallback {
+onTransact()
}
class SmsServiceStub {
-mService
-mReceiveRecords
+SmsServiceStub()
+~SmsServiceStub()
+sendData()
+sendText()
+registerReceiveCallback()
+unregisterReceiveCallback()
+getServiceCenterAddress()
+setServiceCenterAddress()
+notifyDataMessageReceived()
+notifySyncMLNotificationReceived()
+notifyTextMessageReceived()
}
class SmsHandler {
+SmsHandler()
+~SmsHandler()
+handleMessage()
}
class IccSmsInterfaceManager {
#mDispatcher
+IccSmsInterfaceManager()
+~IccSmsInterfaceManager()
+init()
+sendData()
+sendText()
}
class SMSDispatcher {
#mCi
#mPhone
-mPendingMessagesList
+SMSDispatcher()
+~SMSDispatcher()
+handleMessage()
+sendRawPdu()
+handleSendComplete()
}
class ImsSMSDispatcher {
-mGsmInboundSmsHandler
-mGsmDispatcher
+ImsSMSDispatcher()
+~ImsSMSDispatcher()
+init()
+sendData()
+sendText()
}
class GsmSMSDispatcher {
-mGsmInboundSmsHandler
+GsmSMSDispatcher()
+~GsmSMSDispatcher()
+handleMessage()
+sendData()
+sendText()
+sendSms()
}
class PendingMessage {
+tracker
}
class SmsTracker {
+mCallback
+onSent()
+onFailed()
}
interface ISmsSendCallback {
+onMessageSent()
+onDeliveryReport()
}
class BpSmsSendCallback {
+onMessageSent()
+onDeliveryReport()
}
class BnSmsSendCallback {
+onTransact()
}
class InboundSmsHandler {
+InboundSmsHandler()
+~InboundSmsHandler()
+handleNewSms()
+dispatchMessage()
+processUserData()
+processMessagePart()
#dispatchMessageRadioSpecific()
#dispatchNormalMessage()
}
class GsmInboundSmsHandler {
+GsmInboundSmsHandler()
+~GsmInboundSmsHandler()
+init()
+handleMessage()
}
class RIL {
-mSocket
-mSenderThread
-mSender
}
class RILSender{
}
class RILReceiver{
}

SmsManager -- BpSmsService
SmsManager o-- ISmsService 
BpSmsService ..|> ISmsService
BpSmsService -- BnSmsService
SmsServiceStub-->SmsService : <<friend>>
BnSmsService <|-- SmsServiceStub
SmsServiceStub o-- Record 
Record o-- ISmsReceiveCallback 
BpSmsReceiveCallback -- BnSmsReceiveCallback 
BpSmsReceiveCallback ..|> ISmsReceiveCallback
SmsService *-- SmsHandler 
SmsHandler -- IccSmsInterfaceManager
IccSmsInterfaceManager *-- ImsSMSDispatcher 
ImsSMSDispatcher *-- GsmSMSDispatcher   
ImsSMSDispatcher *-- GsmInboundSmsHandler 
SMSDispatcher <|-- GsmSMSDispatcher
PendingMessage o-- SmsTracker 
SmsTracker o-- ISmsSendCallback
BpSmsSendCallback -- BnSmsSendCallback 
BpSmsSendCallback ..|> ISmsSendCallback
InboundSmsHandler <|-- GsmInboundSmsHandler
InboundSmsHandler -- ISmsService
GsmSMSDispatcher -- GsmInboundSmsHandler
SMSDispatcher o-- PendingMessage
SMSDispatcher -- RIL
RILSender-->RIL : <<friend>>
RILReceiver-->RIL : <<friend>>
GsmInboundSmsHandler -- RIL

```

#### Class list

| Class | Descriptions |
| ------- | ----------- |
| SmsManager | This class Manages SMS operations such as sending data, and text SMS messages, getting/setting service center address as per slotId. |

#### Interface list

| Class Name | Interface Name | Type | Description | Input | Output |
| ---------- | ----------- | --------- | --------- | ---------- | ---------- |
| SmsManager | CheckSmsService | Call | Test function to check if SMS service is alive | int32_t cmd | android::sp<mindroid::String> | 


### Dynamic Design

#### State Design
- ![State design of SMSManager component](../PNG/state.png)

#### Interaction Design
##### RegisterReceiver interface
```puml : RegisterReceiver interface
participant App
participant SmsManager
participant BpSmsService
participant BnSmsService
participant SmsServiceStub

App->SmsManager : 1 **RegisterReceiver**\n(sp<ISmsReceiveCallback>&, int32_t)
activate SmsManager
SmsManager->SmsManager : 1.1 RegisterReceiverImpl\n(int32_t, sp<ISmsReceiveCallback>&)
activate SmsManager #DarkSalmon
SmsManager->BpSmsService : 1.2 registerReceiveCallback\n(int32_t, sp<ISmsReceiveCallback>&)
deactivate SmsManager
activate BpSmsService
BpSmsService->BnSmsService : 1.3 onTransact(uint32_t, \nParcel&,Parcel*,uint32_t)
BnSmsService->SmsServiceStub : 1.4 registerReceiveCallback\n(int32_t, sp<ISmsReceiveCallback>&)
activate SmsServiceStub
BnSmsService<--SmsServiceStub
deactivate SmsServiceStub
BpSmsService<--BnSmsService
SmsManager<--BpSmsService
deactivate BpSmsService
App<--SmsManager : 1.5 return RegisterReceiver(sp<ISmsReceiveCallback>&, int32_t)

deactivate BpSmsService
deactivate SmsManager
```

- Step
    - step : 1 App calls SmsManager::RegisterReceiver() to register for getting new SMS messages by passing input arguments as ISmsReceiveCallback instance and receiverID.
    - step : 1.1 SmsManager calls its own singleton instance API i.e RegisterReceiverImpl().
    - step : 1.2 SmsManager forwards the request to BpSmsService instance by calling registerReceiveCallback().
    - step : 1.3 onTransact does the appropriate unmarshalling of app request transactions.
    - step : 1.4 BnSmsService instance will invoke the SmsServiceStub instance that will store in ReceiveRecords.
    - step : 1.5 Returns the RegisterReceiver status.

##### UnregisterReceiver interface
```puml : UnregisterReceiver interface
participant App
participant SmsManager
participant BpSmsService
participant BnSmsService
participant SmsServiceStub

App->SmsManager : 1 **UnregisterReceiver**\n(sp<ISmsReceiveCallback>&, int32_t)
activate SmsManager
SmsManager->SmsManager : 1.1 UnregisterReceiverImpl\n(int32_t, sp<ISmsReceiveCallback>&)
activate SmsManager #DarkSalmon
SmsManager->BpSmsService : 1.2 unregisterReceiveCallback\n(int32_t, sp<ISmsReceiveCallback>&)
deactivate SmsManager
activate BpSmsService
BpSmsService->BnSmsService : 1.3 onTransact(uint32_t, \nParcel&,Parcel*,uint32_t)
BnSmsService->SmsServiceStub : 1.4 unregisterReceiveCallback\n(int32_t, sp<ISmsReceiveCallback>&)
activate SmsServiceStub
BnSmsService<--SmsServiceStub
deactivate SmsServiceStub
BpSmsService<--BnSmsService
SmsManager<--BpSmsService
deactivate BpSmsService
App<--SmsManager : 1.5 return UnregisterReceiver(sp<ISmsReceiveCallback>&, int32_t)

deactivate BpSmsService
deactivate SmsManager
```