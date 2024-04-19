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
#include <string.h>


guiStateEnum guiState = INFO;
infoSubstateEnum infoSubstate = BOARD;

void guiDrawBottomBox(char buttonText[][5])
{
	ssd1306_Line(0, 52, 127, 52, White);
	ssd1306_Line(32, 52, 32, 63, White);
	ssd1306_Line(64, 52, 64, 63, White);
	ssd1306_Line(96, 52, 96, 63, White);


	ssd1306_SetCursor(2, 54);
	ssd1306_WriteString(buttonText[0], Font_7x10, White);

	ssd1306_SetCursor(35, 54);
	ssd1306_WriteString(buttonText[1], Font_7x10, White);

	ssd1306_SetCursor(67, 54);
	ssd1306_WriteString(buttonText[2], Font_7x10, White);

	ssd1306_SetCursor(99, 54);
	ssd1306_WriteString(buttonText[3], Font_7x10, White);
}

void guiStateMachine(guiInfoStruc *guiInfo)
{
	static uint8_t buttonState[4] = {0};
	static uint8_t prevButtonState[4] = {0};
	memcpy(buttonState, guiInfo->buttons, sizeof(buttonState));
	for(uint8_t i = 0; i < sizeof(buttonState); i++)
	{
		if(buttonState[i] == 1 && prevButtonState[i] == 0)
		{
			//button pressed
			if(i == 0)
			{
				infoSubstate++;
				if(infoSubstate == LAST)
				{
					infoSubstate = 0;
				}
			}

		}
	}
	memcpy(prevButtonState, buttonState, sizeof(buttonState));


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
	char buttonText[4][5] =
	{ "HOME", "RECD", "STOP", "CALB" };

	switch (infoSubstate)
	{
	case BOARD:
		//
		ssd1306_Fill(Black);
		strcpy(buttonText[0], "MPU ");
		guiDrawBottomBox(buttonText);

		char timeString[20] = "";
		snprintf(timeString, 20, "UTC: %02d:%02d:%02d",
				guiInfo->boardStats.sTime.Hours,
				guiInfo->boardStats.sTime.Minutes,
				guiInfo->boardStats.sTime.Seconds);
		ssd1306_SetCursor(0, 0);
		ssd1306_WriteString(timeString, Font_7x10, White);

		char voltageString[15];
		if (guiInfo->boardStats.usbVoltage > 2.0)
		{
			//do not display battery voltage, charging
			strcpy(voltageString, "BATT: CHARGING");
			ssd1306_SetCursor(0, 10);
			ssd1306_WriteString(voltageString, Font_7x10, White);
		}
		else
		{
			snprintf(voltageString, 15, "BATT: %.2f V  ",
					guiInfo->boardStats.battVoltage);
			ssd1306_SetCursor(0, 10);
			ssd1306_WriteString(voltageString, Font_7x10, White);
		}

		char tempString[17];
		snprintf(tempString, 17, "TEMP: %.2f degC",
				guiInfo->boardStats.mcuTemp);
		ssd1306_SetCursor(0, 20);
		ssd1306_WriteString(tempString, Font_7x10, White);

		ssd1306_UpdateScreen();
		osDelay(100);

		break;
	case MPU6050:
		//
		ssd1306_Fill(Black);
		strcpy(buttonText[0], "ADIS");
		guiDrawBottomBox(buttonText);

		ssd1306_UpdateScreen();
		osDelay(100);
		break;
	case ADIS:
		//
		ssd1306_Fill(Black);
		strcpy(buttonText[0], "LSM ");
		guiDrawBottomBox(buttonText);

		ssd1306_UpdateScreen();
		osDelay(100);
		break;
	case LSM:
		//
		ssd1306_Fill(Black);
		strcpy(buttonText[0], "GNSS");
		guiDrawBottomBox(buttonText);

		ssd1306_UpdateScreen();
		osDelay(100);
		break;
	case GNSS:
		//
		ssd1306_Fill(Black);
		strcpy(buttonText[0], "HOME");
		guiDrawBottomBox(buttonText);
		char fixType[6][19] =
		{ "GPS: No Fix       ", "GPS: DR only      ", "GPS: 2D-Fix       ",
				"GPS: 3D-Fix       ", "GPS: Time only fix" };
		ssd1306_SetCursor(0, 00);
		ssd1306_WriteString(fixType[guiInfo->gnss.fixType], Font_7x10, White);

		ssd1306_UpdateScreen();
		osDelay(100);
		break;
	case LAST:
		break;

	}

}



