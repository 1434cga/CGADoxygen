```text
This is example/A
```

# Introduction
## Revision History
| Version | Date       | Comment         | Author                             | Approver |
| ------- | ---------- | --------------- | ---------------------------------- | -------- |
| 0.9     | 2018-08-17 | Initial Release | Charles.Lee <cheoljoo.lee@lge.com> |          |

## Purpose
- This document is a Software Requirement Specification (SRS) of ODI Manager . This SRS is a result which describes software requirements analyzed by LGE. Each software requirement in this document is traced from the System Requirements Specifications (SysRS).

## Scope
- SW Overview, SW Main Features
- External Interface Requirements
- Functional Requirements
- Quality Attributes (Non-functional requirements)
- Constraints

## Audience
- The target audience of this document is:
	- OEM (Customer) , Requirement engineer, S ystem/ Software architect, Component developer, Test Engineer

# SW Overview
- The Telltale Manager(MgrTelltale) is responsible for processing Telltale indication from VP.
	- The MgrTelltale parses the raw data packet from VP and process the data to send HMI layer.
	- It interacts with various external components such as MgrTsk, MgrGTF, MgrODI.

## SW Main Features
- Receive messages from MgrTsk and start monitoring.
- It communicates with ODI Manager to get or send the CAN siganls.
- It communicates with HMI manager to show the telltale.

# External Interface Requirements
## SW Context
- The SW context diagram shows the interface between MgrODI and the following external components .
	- ![external_design](./outplantuml/HLD_md_1_external_design.png)

## SW Interface

|	No | Source |Interface Name |Description |UC_ID|
|---|---|----|---|---|
| 1 | | MgrTsk | Send keep alive message | |
| 2 |  | MgrODI | Send data to ODI and receive indication from ODI | |
| 3 |  | MgrHMI | Send indication data to MgrGTF  | |

# Functional Requirements

| FR                | Description                           | Limitation | OEM Dependency |
| ----------------- | ------------------------------------- | ---------- | ---------- |
| CMTELLTALE-FR-001 | Keep the Telltale Image               |            |            |
| CMTELLTALE-FR-002 | Show the Normal Telltale without blinking    |            |            |
| CMTELLTALE-FR-003 | Show the Blink Telltale               |            |            |
| CMTELLTALE-FR-004 | Show the Telltale with Duration |            |            |
| CMTELLTALE-FR-005 | Show the RED_GREEEN Telltale          |            |            |
| CMTELLTALE-FR-006 | Show the Telltale with priority       |            |            |
| CMTELLTALE-FR-007 | Transfer the Sound Signal             |            |            |
| CMTELLTALE-FR-008 | Change the location easily  |            |            |
| CMTELLTALE-FR-009 | Change the images easily    |            |            |
| CMTELLTALE-FR-010 | Keep alive     |            |            |
| CMTELLTALE-FR-011 | Draw the images or Send indication order     |            |            |
| CMTELLTALE-FR-012 | Communicate with VP     |            |            |

# Quality Attributes

# Design Constraints
## Business Constraints

## Technical Constraints

## Standard & Regulations



