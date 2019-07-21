

#ifndef SRC_MGRTELLTALE_INC_LXID_AKLASS_H_
#define SRC_MGRTELLTALE_INC_LXID_AKLASS_H_

#include "LXID_Base.h"
#include "LXID_CTelltaleBase.h"

namespace family {

/**
 * @brief Telltale class for Blink Telltale
 *  what is this (this line will be continue to brief)
 *
 * @details 1 multiple line.
 *    this is 2 of multiple line. (this line will be continue to detail)
 *
 * @startuml
 *  == this is basic ==
 *  A --> B
 *  C --> B
 * @enduml
 * 
 * This is normal description1 (this is details)
 * This is normal description2 (this is details)
 *
 * @details   ML-1 : 1
 *    ML-1 : 2  (this line will be ocntinue to details)
 * @details   ML-2 : 1
 *    ML-2 : 2  (this line will be ocntinue to details)
 * @details   ML-3 : 1 (this line will be another line)
 * @details   ML-4 : 1 (this line will be another line)
 * @details   ML-5 : 1 (this line will be another line)
 *
 * @startuml
 *  == this UML will be show in sequ.css.html version ==
 *  D --> E
 *  C --> F
 *  A --> F
 *  B --> F
 *  D --> F
 * @enduml
 * 
 * @details Auto-generated Code
 * @note Abstract Fractory Pattern
 * @note Blink telltale has information of blink.
 *          ex.) LXIDs , duration , frequency , base LXIDs to show image
 * @date 2016.06.20.
 * @author Charles.Lee (cheoljoo.lee@lge.com)
 */
class AKlass : public CTelltaleBase
{
public:
    AKlass(TELLTALE id , int32_t startstatus, std::vector<int32_t> blink , int32_t freq , int32_t durationmax , int32_t afterduration);
    ~AKlass();
    int32_t Run(int32_t isOn);
    void Draw(int32_t isOn);
    void Clear();
    int32_t mBlinkStatus;                   ///< ON or Off in Run()
    int32_t mDurationCnt;                   ///< the count of frequency(ms)
    ///< if mDurationCnt > mDurationMax , stop blink
#ifndef _UNIT_TEST_
private:
#endif // _UNIT_TEST_
    int32_t TimerAct();
    std::vector<int32_t> mBlink;            ///< LXID vector (basically it has only one.)
    ///< exception case : right / left direction blink should run simultaneously.

    int32_t mFreq;                          ///< frequency : milli-seconds
    int32_t mDurationMax;                   ///< calculate maximum count of frequency(ms) with duration(second)
    int32_t mAfterDuration;                 ///< Is it ON after duration? ON:draw Image , OFF:Clear Image
    // Timer variable

};


#endif  // SRC_MGRTELLTALE_INC_LXID_AKLASS_H_


}
