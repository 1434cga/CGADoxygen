

#ifndef SRC_MGRTELLTALE_INC_LXID_AKLASS_H_
#define SRC_MGRTELLTALE_INC_LXID_AKLASS_H_

#include "LXID_Base.h"
#include "LXID_CTelltaleBase.h"

namespace family {

/**
 * @class AKlass
 * @brief Telltale class for Blink Telltale
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

    //! [AK_TIME]
    int32_t mFreq;                          ///< frequency : milli-seconds
    int32_t mDurationMax;                   ///< calculate maximum count of frequency(ms) with duration(second)
    int32_t mAfterDuration;                 ///< Is it ON after duration? ON:draw Image , OFF:Clear Image
    // Timer variable
    //! [AK_TIME]
};


#endif  // SRC_MGRTELLTALE_INC_LXID_AKLASS_H_


}
