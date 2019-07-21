```text
Default in CGADoxygen
```

# About This Document
## Document Information


| Issuing authority  | LG VC Smart SW Platform Team      |
| ------------------ | --------------------------------- |
| Configuration ID   |                                   |
| Status of document | In Progress / Approved / Released |

## Revision History
| Version | Date       | Comment         | Author                             | Approver |
| ------- | ---------- | --------------- | ---------------------------------- | -------- |
| 0.1     | 2018-07-20 | Initial Release | Who.Lee <Who.lee@lge.com>          |          |



## Purpose
- This document specifies the Software Detailed Design (SDD) for the XXX service including the static design, dynamic design, and algorithm design.

## Scope
- This document identifies the class consisting of each component from SAD, and describes the behaviors of those classes to accomplish the requirements upon them.

## Audience
- The target audience of this document is:
	- Software architect who will evaluate the design of the software
	- Component developer who will implement the design in actual code
	- Native application developers who need to use MgrXXX service
	- Cheetah project participants who want to understand the low level design of the MgrXXX service
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
| MgrXXX[^1]      | XXX Manager      |

[^1]: XXX manager


# MgrXXX Component
## External Design
- XXX manager shows the telltale on the display or sends signal to HMI.  Main functions of XXX Manager.
	- Receive messages from MgrTsk and start monitoring.
	- It communicates with ODI Manager to get or send the CAN siganls.
	- It communicates with HMI manager to show the telltale.

### Static Design
- [Figure] shows the relationship between MgrXXX and other external Managers..

```
![alt PLANTUML HLD.md 2 external_design](./outplantuml/HLD_md_1_external_design.png)
```


### Dynamic Design
- sequence diagram
- Step
    - step : A.1 Description
    - step : A.2 Description
    - step : A.3 / A.4 : Description
    - step : B.1 Description
    - step : B.2 Description
    - step : C.1 Description
    - step : C.1.1 Description
    - step : C.2 Description



## Internal Design
### Static Design
- The class diagram for the MgrXXX is shown below:
    - show all classes box

#### Class Relations
- [Figure] Brief Class Diagram

```
![alt PLANTUML HLD.md 3 class_brief](./outplantuml/HLD_md_2_class_brief.png)
```

    - Explanation of this class relations

- [Figure] Detailed Class Diagram

```
![alt PLANTUML HLD.md 4 class_detail.png](./outplantuml/HLD_md_3_class_detail_png.png)
```

    - Explanation of this figure


### Dynamic Design

#### Sequence Design
- [Figure] Overall Sequence

```
![alt PLANTUML HLD.md 5 total_seq_design](./outplantuml/HLD_md_4_total_seq_design.png)
```


#### Interaction Design
- [Figure] Simple Sequence between AAA Manager and CMgrXXX class

```
![alt PLANTUML HLD.md 6 ](./outplantuml/HLD_md_5_.png)
```

- processes in CMgrXXX class
	- [Figure] process XXX in CMgrXXX class

```
![alt PLANTUML HLD.md 7 ](./outplantuml/HLD_md_6_.png)
```




