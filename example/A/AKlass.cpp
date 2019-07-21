
#include "Inc/Cmn/CGlobalData.h"
//#include "ODI/ODILut.h"

#include "MgrGTFCmd.h"
#include "MgrTskCmd.h"
#include "MgrAlertCmd.h"

#include "Cmn/Utils/CTimer.h"
#include "Inc/GTF/GTFDef.h"

//#include <Version.h>
//#include <Version_var.h>

#include "CMgrTelltale.h"
#include "LXID.h"

namespace family {

/**
 * @brief AKlass Constructor
 * @details if mStartStatus is LXID_ON , Draw it.
 *
 * @startuml
 * participant CReceiver
 * opt MsgFromAlert1()
 *  alt cmd=IDM_MALERT_MTELLTALE_IGN_STATUS_IN && value == 0
 *     alt
 *            CReceiver ->> MgrGTF : Draw_HMI sendIndMsg() ->  sendMessage(GTF,IDM_MTELL_MGTF_INDICATION,...)
 *      else
 *          note right CReceiver : Draw Directly
 *      end
 *  else
 *      note right CReceiver : mbBlockDraw = false
 *  end
 * end
 * @enduml
 *
@cond SRS
 * @SRS{CMTELLTALE-FR-001 , Do it by yourself.}
 * @SRS{CMTELLTALE-NFR-002 , Constructor }
@endcond 
 *
 * @HLD{"ABCD2","Do it by yourself."}
 *
 * @LLD{ABCD3,Do it by yourself.}
 *
 * @step{"1.1 Initialization"}
 * @step{"1.2 This is total.
 *		<br>How are you?"}
 * @step{"1.3 AKlass This is total.
 *		How are you?"}
 *
 * @step{"1.4 This is total."}
 *
 *
 * @algorithm Troll-01  AKlass This is example of algorithm
 *		Do not that!
 *
 * @code{.cpp}  Title:AKlass-011
 *	mId = id;
	mType = BLINK_TELLTALE;
	for( std::vector<int32_t>::iterator vit = blink.begin() ; vit != blink.end() ; vit++){
		CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "    : blink(%d) %s\n",*vit,getStringLXID((TELLTALE) *vit));
	}
 * @endcode
 *
 * @verbatim  Title:AKlass-02
	mVerbatim = BLINK_TELLTALE;
	for( std::vector<int32_t>::iterator vit = blink.begin() ; vit != blink.end() ; vit++){
	}
 * @endverbatim
 *
 * @warning AK_Warning Message
 */
AKlass::AKlass(TELLTALE id , int32_t startstatus, std::vector<int32_t> blink , int32_t freq , int32_t durationmax , int32_t afterduration)
{
	//: mId(id), mStartStatus(startstatus), mFreq(freq), mDurationMax(durationmax) , mAfterDuration(afterduration) , mDrawStatus((int32_t) LXID_OFF)

	mId = id;
	mType = BLINK_TELLTALE;

	mDrawStatus = (int32_t) LXID_OFF;
	mBlinkStatus = (int32_t) LXID_OFF;
	mDurationCnt = 0;
	mFreq = freq;
	mDurationMax = durationmax;
	mAfterDuration = afterduration;
	mStartStatus = startstatus;

	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "%s_%d : id(%d) %s\n",__PRETTY_FUNCTION__,__LINE__,id,getStringLXID((TELLTALE) id));

	for( std::vector<int32_t>::iterator vit = blink.begin() ; vit != blink.end() ; vit++){
		CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "    : blink(%d) %s\n",*vit,getStringLXID((TELLTALE) *vit));
	}
	mBlink = blink;

	if(mStartStatus == (int32_t) LXID_ON){
		Run((int32_t) LXID_ON);
	}

// CGA_VARIANT:AKlass:AKlass():variant START

    /*  
     * Write your own code 
    */

// CGA_VARIANT:AKlass:AKlass():variant END

}

/**
 * @brief AKlass Destructor
 *  what is this (this line will be continue to brief)
 *
 * @since{2,16}
 * @since{3,16}
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
 * @warning AKDestructor Warining
 */
AKlass::~AKlass() { }

/**
 * @brief Run() will blink the telltale or send command to HMI according to isOn Status.
 * @param [in] isOn LXID_ON or LXID_OFF
 * @note    start the blink
 *			set the timer for blinking
 * @return The Result whether start the blink
 * @retval LXID_SUCCESS success to draw or send indication msg
 * @retval LXID_ERROR fail to draw or send indication msg
 * @see AKlass::TimerAct()
 * @SRS{CMTELLTALE-NFR-002 , Run}
 */
int32_t AKlass::Run(int32_t isOn)
{
	int32_t ret = LXID_ERROR;
	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "%s : %s T(%d) : BlinkStatus(%d) isOn(%d)\n",__PRETTY_FUNCTION__,getStringLXID(mId),mType,mBlinkStatus,isOn);

	if(isOn == LXID_ERROR) return LXID_ERROR;

	if(mBlinkStatus == isOn){
		CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "DUPLICATE order : status(%d) isOn(%d) mDurationCnt(%d -> 0)\n",mBlinkStatus,isOn,mDurationCnt);
		// Call New start??  clear -> Draw; (Only ON)
		if(LXID_ON == isOn){
			mDurationCnt = 0;
		}
		return LXID_ERROR;
	} else {
		if((int32_t) LXID_ON == isOn){
			Draw(isOn);
#ifndef _LOCAL_TEST_
			// Call Timer Function with mFreq
			// Call create timer
			// set timer point32_ter
			CTimer::GetInstance()->SetTimer(mId,0,mFreq,true);
#endif // _LOCAL_TEST_
		} else {
			Clear();
		}
		ret = LXID_SUCCESS;
	}

	mBlinkStatus = isOn;
	return ret;
// @CGA_VARIANT_START{":AKlass:Run(int32_t)"}
    /*  
     * Write your own code 
    */
// @CGA_VARIANT_END{":AKlass:Run(int32_t)"}
}

/**
 * @brief Draw shows the telltales or send basic command to HMI according to isOn Status.
 * @details timer will toggle with isOn parameter repeatedly in TimerAct().
 * @param [in] isOn LXID_ON or LXID_OFF
 * @return void
 *
 * @SRS{CMTELLTALE-NFR-003 , Do it by yourself.}
 * @SRS{CMTELLTALE-NFR-004 , Do it by yourself.}
 *
@cond UML
 * @startuml
 * participant CReceiver
 * opt MsgFromAlert2()
 *  alt cmd=IDM_MALERT_MTELLTALE_IGN_STATUS_IN && value == 0
 *     alt
 *            CReceiver ->> MgrGTF : Draw_HMI sendIndMsg() ->  sendMessage(GTF,IDM_MTELL_MGTF_INDICATION,...)
 *      else
 *          note right CReceiver : Draw Directly
 *      end
 *  else
 *      note right CReceiver : mbBlockDraw = false
 *  end
 * end
 * @enduml
@endcond
 *
 * @step{"2.1 Initialization"}
 * @step{"2.2 This is total.
 *		<br>How are you?"}
 * @step{"2.3 AKlass This is total.
 *		How are you?"}
 *
 */
void AKlass::Draw(int32_t isOn)
{
	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG" "%s : %s T(%d) : status(%d) isOn(%d)\n",__PRETTY_FUNCTION__,getStringLXID(mId),mType,mDrawStatus,isOn);

	for( std::vector<int32_t>::iterator vit = mBlink.begin() ; vit != mBlink.end() ; vit++){
		CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "    : blink(%d) %s\n",*vit,getStringLXID((TELLTALE) *vit));
		gMapBaseTelltale[*vit]->Run(isOn);      // or Draw()
	}
	mDrawStatus = isOn;
}

/**
 * @brief TimerAct() will toggle the parameter isOn of Draw(isOn) for blinking.
 * @return int32_t
 * @retval LXID_SUCCESS success of blinking
 * @retval LXID_ERROR when blink is off
 */
int32_t AKlass::TimerAct()
{
	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG" "%s : %s T(%d) : status(%d)\n",__PRETTY_FUNCTION__,getStringLXID(mId),mType,mDrawStatus);
	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG" "  mDurationMax(%d) mDurationCnt(%d) mAfterDuration(%d) mBlinkSatus(%d)\n",mDurationMax,mDurationCnt,mAfterDuration,mBlinkStatus);
	if(mBlinkStatus == LXID_OFF){
		CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG:" "PANIC ; ERROR : does not synchronize\n    We will change int32_to SetTimer(... false);\n");
		return LXID_ERROR;
	}
#ifndef _LOCAL_TEST_
	if( (mDurationMax != ALWAYS_ON) && (mDurationMax < mDurationCnt)){
		Clear();
		if((int32_t) LXID_ON == mAfterDuration){
			Draw((int32_t) LXID_ON);
		}
		return LXID_SUCCESS;
	} else {
		mDurationCnt++;
		Draw(!mDrawStatus);
	}
#endif // _LOCAL_TEST_

	return LXID_SUCCESS;
}

/**
 * @brief Clear()  will clear.
 * @since{4,17}
 * @return void
 */
void AKlass::Clear()
{
	CDebug::GetInstance()->DebugPrint(DEBUG_REPETITION,"DEBUG" "%s : %s T(%d) : status(%d)\n",__PRETTY_FUNCTION__,getStringLXID(mId),mType,mDrawStatus);
#ifndef _LOCAL_TEST_
	// Call Kill Timer
	CTimer::GetInstance()->KillTimer(mId);
#endif // _LOCAL_TEST_
	Draw((int32_t) LXID_OFF);
	mDrawStatus = (int32_t) LXID_OFF;
	mBlinkStatus = (int32_t) LXID_OFF;
	mDurationCnt = 0;
}




}
