```text
Default in CGADoxygen
```

# Introduction
## Revision History
| Version | Date       | Comment         | Author                             | Approver |
| ------- | ---------- | --------------- | ---------------------------------- | -------- |
| 0.1     | 2018-08-17 | Initial Release | Who.Lee <who.lee@gmail.com>        |          |

## Purpose
- Purpose

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
- Overview
	- Overview in detail

## SW Main Features
- Features

# External Interface Requirements
## SW Context
- The SW context diagram shows the interface between following external components .
	- ![external_design](./outplantuml/CLASSStatic.png)

## SW Interface

|No | Source |Interface Name |Description                                       |Remarks|
|---|--------|---------------|--------------------------------------------------|-------|
| 1 |        | MgrAAA        | Send keep alive message                          |       |
| 2 |        | MgrBBB        | Send data to CCC and receive indication from CCC |       |
| 3 |        | MgrCCC        | Send indication data to MgrAAA                   |       |

# Functional Requirements

| FR              | Description                                | Limitation | OEM Dependency |
| --------------- | ------------------------------------------ | ---------- | -------------- |
| CMODULE-FR-001  | Keep the Image                             |            |                |
| CMODULE-FR-002  | Show the Normal Status                     |            |                |
| CMODULE-FR-003  | Show the Blink Status                      |            |                |
| CMODULE-NFR-001 | Draw the images within 1 second            |            |                |

# Quality Attributes

# Design Constraints
## Business Constraints

## Technical Constraints

## Standard & Regulations



