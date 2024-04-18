/*
 * gui.c
 *
 *  Created on: Apr 16, 2024
 *      Author: marou
 */

#include "main.h"
#include "ssd1306.h"
#include "ssd1306_fonts.h"
#include "gui.h"
#include <stdio.h>
#include "cmsis_os2.h"

guiStateEnum guiState = INFO;
infoSubstateEnum infoSubstate = BOARD;

void guiDrawBottomBox(void)
{
	ssd1306_Line(0, 52, 127, 52, White);
	ssd1306_Line(32, 52, 32, 63, White);
	ssd1306_Line(64, 52, 64, 63, White);
	ssd1306_Line(96, 52, 96, 63, White);
}

void guiStateMachine(guiInfoStruc *guiInfo)
{
	switch (guiState)
	{
	case INFO:
		//gui handler for info screen
		printInfoScreen(guiInfo);

		break;
	case RECORD:
		//gui handler for recording screen
		break;
	case STOP:
		//gui handler for stop screen
		break;
	case CALIBRATION:
		//gui handler for calibration screen
		break;

	}

}

void printInfoScreen(guiInfoStruc *guiInfo)
{
	ssd1306_SetCursor(0, 32);
	ssd1306_WriteString("UTC: ", Font_7x10, White);
	char timeString[20] = "";


	sprintf(timeString, "%02d:%02d:%02d", guiInfo->boardStats.sTime.Hours, guiInfo->boardStats.sTime.Minutes,
			guiInfo->boardStats.sTime.Seconds);

	ssd1306_WriteString(timeString, Font_7x10, White);

	char voltageString[13];

	snprintf(voltageString, 13, "BATT: %.2f V", guiInfo->boardStats.battVoltage);

	ssd1306_SetCursor(0, 10);
	ssd1306_WriteString(voltageString, Font_7x10, White);
	osDelay(100);

	ssd1306_UpdateScreen();
}



