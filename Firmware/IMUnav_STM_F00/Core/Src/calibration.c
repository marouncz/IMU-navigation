/*
 * calibration.c
 *
 *  Created on: Apr 21, 2024
 *      Author: marou
 */

#include "main.h"
#include "ssd1306.h"
#include "ssd1306_fonts.h"
#include "gui.h"
#include <stdio.h>
#include "cmsis_os2.h"
#include <string.h>
#include "calibration.h"


void calibrateAccel(void)
{
	extern osThreadId_t adisTaskHandle;
	extern osThreadId_t mpuTaskHandle;

	osThreadSuspend(adisTaskHandle);
	osThreadSuspend(mpuTaskHandle);


	char buttonText[4][5] =
	{ "    ", "    ", "    ", "NEXT" };
	ssd1306_Fill(Black);
	guiDrawBottomBox(buttonText);

	char calibHeaderString[22] = "CALIBRATION RUNNING";
	ssd1306_SetCursor(0, 0);
	ssd1306_WriteString(calibHeaderString, Font_6x8, White);


    char calibrationMessage[8][22] = {
        "You will be asked to ",
        "lay the IMU on a flat ",
        "surface on all of its ",
        "6 faces sequentially. ",
        "After each \"NEXT\" ",
        "button press, you will",
        "have 5 seconds to ",
        "position the unit.",
    };

	for(int i = 0; i<8; i++)
	{
		ssd1306_SetCursor(0, i*8);
		ssd1306_WriteString(calibrationMessage[i], Font_6x8, White);
	}

	ssd1306_UpdateScreen();

	osDelay(5000);
	osThreadResume(adisTaskHandle);
	osThreadResume(mpuTaskHandle);


}
