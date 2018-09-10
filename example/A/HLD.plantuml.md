
# About This Document
## Document Information


| Issuing authority  | LG VC Smart SW Platform Team      |
| ------------------ | --------------------------------- |
| Configuration ID   | LGE_Cheetah_SDD_MgrTelltale       |
| Status of document | In Progress / Approved / Released |

## Revision History
| Version | Date       | Comment         | Author                             | Approver |
| ------- | ---------- | --------------- | ---------------------------------- | -------- |
| 0.9     | 2018-07-20 | Initial Release | Charles.Lee <cheoljoo.lee@lge.com> |          |



## Purpose
This document specifies the Software Detailed Design (SDD) for the MgrTelltale service including the static design, dynamic design, and algorithm design.

## Scope
This document identifies the class consisting of each component from SAD, and describes the behaviors of those classes to accomplish the requirements upon them.

## Audience
- The target audience of this document is:
	- Software architect who will evaluate the design of the software
	- Component developer who will implement the design in actual code
	- Native application developers who need to use MgrTelltale service
	- Cheetah project participants who want to understand the low level design of the MgrTelltale service
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
| MgrTelltale[^1] | Telltale Manager |

[^1]: Telltale manager


# MgrTelltale Component
## External Design
- Telltale manager shows the telltale on the display or sends signal to HMI.  Main functions of Telltale Manager.
	- Receive messages from MgrTsk and start monitoring.
	- It communicates with ODI Manager to get or send the CAN siganls.
	- It communicates with HMI manager to show the telltale.

```puml external_design : shows the relationship between MgrTelltale and other external components.

skinparam sequence {
  FontSize 13
  BackgroundColor<<Apache>> Red
  BorderColor<<Apache>> #FF6655
  FontName Courier
  BorderColor black
  BackgroundColor gold
  ArrowFontName Impact
  ArrowColor black
  ArrowFontColor #777777
  ParticipantBorderColor Black
    ParticipantBackgroundColor Black
    ParticipantFontName Impact
    ParticipantFontSize 17
    ParticipantFontColor White
}

Participant "MgrTsk Manager" as task
Participant "MgrTelltale Manager" as telltale
Participant "MgrODI Manager" as odi
Participant "HMI (KANZI) \nor\nGTF" as hmi

== Task Management ==
task -> telltale : A.1 IDM_PROCESS_MONITOR_START
task <- telltale : A.2 IDM_ALIVE_NOT_DEAD
task -> telltale : A.3 IDM_PREPARE_SHUTDOWN
task -> telltale : A.4 IDM_PREPARE_SHUTDOWN_CANCEL
== Timer Management ==
telltale -> telltale : B.1 TIMER_PULSE_CODE (Timer for Blink / Duration telltale)
telltale -> hmi : B.2 sendIndMsg : draw ON/OFF
== CAN signal Management ==
odi -> telltale : C.1 IDM_MODI_MTELLTALE_INDICATION
telltale -> hmi : C.1.1 sendIndMsg : draw ON/OFF
odi -> telltale : C.2 IDM_MODI_MTELLTALE_ALLTEST
```
- Step
    - step : A.1 telltale manager is waiting this msg until task manager sends this msg after starting.
    - step : A.2 telltale manager sends alive msg periodically.
    - step : A.3 / A.4 : telltale should prepare shutdown or cancellation.
    - step : B.1 timer signal for blink and duration TellTale
    - step : B.2 send Indication message to GTF or HMI for drawing telltale if HMI is ON.
    - step : C.1 telltale manager process indication (telltale) message from ODI manager. It's main function.
    - step : C.1.1 is the same of B.2
    - step : C.2 It draws all images for test.



## Internal Design
### Static Design
- The class diagram for the MgrTelltale is shown below:

#### Class Diagram
```puml class_brief.plantuml : Brief Class Diagram
CMgrTelltale <-up- CTelltaleBase
CTelltaleBase <|-- CBlink
CTelltaleBase <|-- CNormal
CTelltaleBase <|-- CRotate
CNormal o-- Telltale
Telltale <- FrameBuffer
FrameBuffer o-- fb_t

```
- CNormal : telltale with Image
- CBlink : Blink telltale (on and off toggle)
- CRotate : Rotate telltale (not blink) ex.) RED_GREEN

```puml class_detail.png : Detailed Class Diagram
!include ../UML/__ALL_only_class__.class

CMgrTelltale <-up- CTelltaleBase
CTelltaleBase <|-- CBlink
CTelltaleBase <|-- CNormal
CTelltaleBase <|-- CRotate
CNormal o-- Telltale
Telltale <- FrameBuffer
FrameBuffer o-- fb_t

```


### Dynamic Design

#### Total Sequence Design
```puml total_seq_design : Overall Sequence
participant CMgrTelltale << (C,#ADD1B2) >>
participant CReceiver << (C,#ADD1B2) >>
participant CMqReceiver << (C,#ADD1B2) >>
participant MgrTsk << (M,#FFFFFF) >>
participant MgrGTF << (M,#FFFFFF) >>
participant MgrODI << (M,#FFFFFF) >>


note over CMgrTelltale : LoadTelltale()
note over CReceiver : constructor(true) >> new CMqReceiver(ture);
note over CMqReceiver : constructor(true) >> create thread for processing Message Queue
note over CMgrTelltale : DoProcess()
CMgrTelltale ->> MgrTsk: SendMessage (IDM\_ALL\_MTSK_ALIVE )
CMgrTelltale ->> CReceiver : RegisterCallback(MgrTsk , MsgFromTsk)
CMgrTelltale ->> CReceiver : RegisterCallback(MgrGTF , MsgFromGTF)
CMgrTelltale ->> CReceiver : RegisterCallback(MgrODI , MsgFromODI)
CMgrTelltale ->> CReceiver : RegisterCallback(MgrAlert , MsgFromAlert)
activate CReceiver
hnote over CReceiver,CMqReceiver: CReceiver::DispatchMessageAdapt(code,cmd,value...)\n in different two threads
hnote over CReceiver,CMqReceiver: mutex lock \n run the msg each sending process\n (MsgFromTsk ...)
MgrTsk ->> CMqReceiver : msg from MgrTsk
hnote over CReceiver,CMqReceiver: MsgFromTsk () \n mutex unlock
deactivate CReceiver
opt MgrFromTsk()
    MgrTsk ->> CReceiver : cmd=IDM_PROCESS_MONITOR_START
    loop n
        activate CReceiver
        CReceiver ->> CReceiver : sendMsgQueue(cmd=IDM_TIMER_PULSE,\n data=IDMTIMER_TELLTALE_ALIVE_NOT_DEAD,\n src=TIMER_PULSE_CODE)
        note over CReceiver: Dispatch()->msgTimer()
        CReceiver ->> MgrTsk : SendMessage(MgrTsk , IDM_ALIVE_NOT_DEAD,0)
        deactivate CReceiver
    end
end
opt MgrFromGTF()
    MgrGTF->> CReceiver : cmd=IDM_MGTF_MTELLTALE_STATUS_REQ
    note over CReceiver: Check Current Status
    CReceiver ->> MgrODI : SendMessage(MgrODI, \nIDM_MTELLTALE_MODI_DISPLAY_LIST, \nTELLTALE_LIST...)
end
opt MgrFromODI()
    MgrODI->> CReceiver : cmd=IDM_MODI_MTELLTALE_INDICATION
    note over CReceiver: ProcessIndData() -> processTelltale()

    loop MAX 30
        alt dpid == DPID_SELF_DIAGNOSTIC_MODE_IN
            CReceiver ->> MgrODI : SendMessage(MgrODI,\n IDM_MTELLTALE_MODI_DIAG_MODE, value)
        else
            note over CReceiver : **Logic Part**  \n: AEBS/TMPS/LDW/HDC/ESP/ISG/ESC/EPS/4WD
            note over CReceiver : display Telltale with dpid,value
        end
    end
end
opt MgrFromAlert()
        alt cmd=IDM_MALERT_MTELLTALE_IGN_STATUS_IN && value == 0
            alt
                CReceiver ->> MgrGTF : Draw_HMI sendIndMsg() \n->  sendMessage(GTF,IDM_MTELL_MGTF_INDICATION,...);
            else
                note over CReceiver : Draw Directly
            end
        else
            note over CReceiver : Block Draw
        end
end
```

#### Interaction Design
```puml : Simple Sequence between ODI Manager and CMgrTelltale class
participant CReceiver << (C,#ADD1B2) >>
participant CMgrTelltale << (C,#ADD1B2) >>
participant MgrODI << (M,#FFFFFF) >>

opt __MsgFromODI()__
    MgrODI->> CReceiver : cmd=IDM_MODI_MTELLTALE_INDICATION
    CReceiver --> CMgrTelltale : IDM_MODI_MTELLTALE_INDICATION
    note right CMgrTelltale : CMgrTelltale::ProcessIndData(){\n  mIndDpIdData.clear()\n  processTelltale()  }

    group processTelltale()
        note right CMgrTelltale : set  std::map<uint32_t, byte> mIndDpIdData; from ODI_data
        loop  < ind_data_param.data_num (MAX 30)
            alt dpid == DPID_SELF_DIAGNOSTIC_MODE_IN
                CMgrTelltale ->> MgrODI : SendMessage(MgrODI, IDM_MTELLTALE_MODI_DIAG_MODE, value)
            else
                note right CMgrTelltale : Process Just Once for each series in related to BASIC case\n (AEBS/TMPS/LDW/HDC/ESP/ISG/ESC/EPS/4WD)

                loop Each Group
                    note right CMgrTelltale #aqua
            Group flag set : Just run once each group
            Choose the highest priority DPID
            displayTelltale(chosen DPID)
          end note
        end

            end
        end
    end

    CReceiver --> CMgrTelltale : IDM_MODI_MTELLTALE_ALLTEST
    note right CMgrTelltale : SymbolDrawTest(u32Value);\n   // All Draw Test : must be delete UT \n        // coordinate test \n        // 0 : test mode end \n        // 1 : day theme \n        // 2 : night theme \n        // 3 : tiltimg \n        // 4 : all draw test 
end
```

- process Telltale in CMgrTelltale class
```puml : [1] process Telltale in CMgrTelltale class
participant CMgrTelltale << (C,#ADD1B2) >>
participant Telltale << (C,#ADD1B2) >>

[--> CMgrTelltale : processTelltale()
    note right CMgrTelltale : reset group flag
    loop Indications from ODI
        note right CMgrTelltale
            process simulator command
            process diagnostic command
        end note
        note right CMgrTelltale : find group
        alt In Group
            note right CMgrTelltale #aqua
                Find the highest DPID (LXID) in chosen group
                Run the highest DPID (Normal/Blink/Rotate)
                SetTimer in case of Blink or Rotate -> msgTimer()
            end note
        else    Not in Group
            note right CMgrTelltale #aqua
                Run this DPID (Normal/Blink/Rotate)
                SetTimer in case of Blink or Rotate -> msgTimer()
            end note
        end
    end
```

- Timer Sequence
```puml TimerSequence.png : [1] Timer Sequence
participant CMgrTelltale << (C,#ADD1B2) >>
participant Telltale << (C,#ADD1B2) >>
participant MgrTsk << (M,#FFFFFF) >>

[--> CMgrTelltale : SetTimer()
[-[#0000FF]-> CMgrTelltale :   msgTimer()
    alt ALIVE_NOT_DEAD
        CMgrTelltale --> MgrTsk :  send ALIVE msg
    else  BLINK
        note right CMgrTelltale : toggle telltale \n BLINK->TimerAct();
        CMgrTelltale --> Telltale :  telltale->setOnOff(ture or false)
    else  ROTATE
        note right CMgrTelltale : rotate telltale \n ROTATE->TimerAct();
        CMgrTelltale --> Telltale :  telltale->setOnOff(ture or false)
    end
````

