/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * File Name          : freertos.c
  * Description        : Code for freertos applications
  ******************************************************************************
  * @attention
  *
  * Copyright (c) 2024 STMicroelectronics.
  * All rights reserved.
  *
  * This software is licensed under terms that can be found in the LICENSE file
  * in the root directory of this software component.
  * If no LICENSE file comes with this software, it is provided AS-IS.
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "FreeRTOS.h"
#include "task.h"
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
#include "i2c.h"
#include "ssd1306.h"
#include "ssd1306_tests.h"
#include "w25q_mem.h"
#include "spi.h"
#include "adis.h"
#include "ssd1306_fonts.h"
#include "lsm.h"
#include "fatfs.h"

/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */

/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/
/* USER CODE BEGIN Variables */

/* USER CODE END Variables */
/* Definitions for defaultTask */
osThreadId_t defaultTaskHandle;
const osThreadAttr_t defaultTask_attributes = {
  .name = "defaultTask",
  .stack_size = 1024 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for keepaliveTask */
osThreadId_t keepaliveTaskHandle;
const osThreadAttr_t keepaliveTask_attributes = {
  .name = "keepaliveTask",
  .stack_size = 1280 * 4,
  .priority = (osPriority_t) osPriorityLow,
};
/* Definitions for hubTask */
osThreadId_t hubTaskHandle;
const osThreadAttr_t hubTask_attributes = {
  .name = "hubTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityLow1,
};
/* Definitions for gpsTask */
osThreadId_t gpsTaskHandle;
const osThreadAttr_t gpsTask_attributes = {
  .name = "gpsTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityBelowNormal,
};
/* Definitions for oledTask */
osThreadId_t oledTaskHandle;
const osThreadAttr_t oledTask_attributes = {
  .name = "oledTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for powerTask */
osThreadId_t powerTaskHandle;
const osThreadAttr_t powerTask_attributes = {
  .name = "powerTask",
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityLow2,
};
/* Definitions for adisTask */
osThreadId_t adisTaskHandle;
const osThreadAttr_t adisTask_attributes = {
  .name = "adisTask",
  .stack_size = 1000 * 4,
  .priority = (osPriority_t) osPriorityRealtime3,
};
/* Definitions for lsmTask */
osThreadId_t lsmTaskHandle;
const osThreadAttr_t lsmTask_attributes = {
  .name = "lsmTask",
  .stack_size = 512 * 4,
  .priority = (osPriority_t) osPriorityRealtime2,
};
/* Definitions for loggerTask */
osThreadId_t loggerTaskHandle;
const osThreadAttr_t loggerTask_attributes = {
  .name = "loggerTask",
  .stack_size = 512 * 4,
  .priority = (osPriority_t) osPriorityNormal2,
};
/* Definitions for adisQ */
osMessageQueueId_t adisQHandle;
const osMessageQueueAttr_t adisQ_attributes = {
  .name = "adisQ"
};
/* Definitions for lsmQ */
osMessageQueueId_t lsmQHandle;
const osMessageQueueAttr_t lsmQ_attributes = {
  .name = "lsmQ"
};
/* Definitions for loggerQ */
osMessageQueueId_t loggerQHandle;
const osMessageQueueAttr_t loggerQ_attributes = {
  .name = "loggerQ"
};

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */

/* USER CODE END FunctionPrototypes */

void StartDefaultTask(void *argument);
void StartKeepaliveTask(void *argument);
void StartHubTask(void *argument);
void StartGpsTask(void *argument);
void StartOledTask(void *argument);
void StartPowerTask(void *argument);
void StartAdisTask(void *argument);
void StartLsmTask(void *argument);
void StartLoggerTask(void *argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/* Hook prototypes */
void configureTimerForRunTimeStats(void);
unsigned long getRunTimeCounterValue(void);

/* USER CODE BEGIN 1 */
/* Functions needed when configGENERATE_RUN_TIME_STATS is on */
__weak void configureTimerForRunTimeStats(void)
{

}

__weak unsigned long getRunTimeCounterValue(void)
{
return 0;
}
/* USER CODE END 1 */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* USER CODE BEGIN RTOS_MUTEX */
  /* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
  /* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
  /* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of adisQ */
  adisQHandle = osMessageQueueNew (4, sizeof(adisDataStruc), &adisQ_attributes);

  /* creation of lsmQ */
  lsmQHandle = osMessageQueueNew (4, sizeof(lsmDataStruc), &lsmQ_attributes);

  /* creation of loggerQ */
  loggerQHandle = osMessageQueueNew (10, sizeof(loggerStruc), &loggerQ_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
  /* add queues, ... */

  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of defaultTask */
  defaultTaskHandle = osThreadNew(StartDefaultTask, NULL, &defaultTask_attributes);

  /* creation of keepaliveTask */
  keepaliveTaskHandle = osThreadNew(StartKeepaliveTask, NULL, &keepaliveTask_attributes);

  /* creation of hubTask */
  hubTaskHandle = osThreadNew(StartHubTask, NULL, &hubTask_attributes);

  /* creation of gpsTask */
  gpsTaskHandle = osThreadNew(StartGpsTask, NULL, &gpsTask_attributes);

  /* creation of oledTask */
  oledTaskHandle = osThreadNew(StartOledTask, NULL, &oledTask_attributes);

  /* creation of powerTask */
  powerTaskHandle = osThreadNew(StartPowerTask, NULL, &powerTask_attributes);

  /* creation of adisTask */
  adisTaskHandle = osThreadNew(StartAdisTask, NULL, &adisTask_attributes);

  /* creation of lsmTask */
  lsmTaskHandle = osThreadNew(StartLsmTask, NULL, &lsmTask_attributes);

  /* creation of loggerTask */
  loggerTaskHandle = osThreadNew(StartLoggerTask, NULL, &loggerTask_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
  /* add threads, ... */
  /* USER CODE END RTOS_THREADS */

  /* USER CODE BEGIN RTOS_EVENTS */
  /* add events, ... */
  /* USER CODE END RTOS_EVENTS */

}

/* USER CODE BEGIN Header_StartDefaultTask */
/**
  * @brief  Function implementing the defaultTask thread.
  * @param  argument: Not used
  * @retval None
  */
/* USER CODE END Header_StartDefaultTask */
void StartDefaultTask(void *argument)
{
  /* USER CODE BEGIN StartDefaultTask */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END StartDefaultTask */
}

/* USER CODE BEGIN Header_StartKeepaliveTask */
FRESULT res; /* FatFs function common result code */
uint32_t byteswritten, bytesread; /* File write/read counts */
uint8_t wtext[] = "0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789"; /* File write buffer */
uint8_t rtext[_MAX_SS];/* File read buffer */
/**
* @brief Function implementing the keepaliveTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartKeepaliveTask */
void StartKeepaliveTask(void *argument)
{
  /* USER CODE BEGIN StartKeepaliveTask */
//	W25Q_Init();		 // init the chip
//		//W25Q_EraseSector(0); // erase 4K sector - required before recording
//
//		// make test data
//		u8_t byte = 0x65;
//		u8_t byte_read = 0;
//		u8_t in_page_shift = 0;
//		u8_t page_number = 0;
//		// write data
//		W25Q_ProgramByte(byte, in_page_shift, page_number);
//		// read data
//		W25Q_ReadByte(&byte_read, in_page_shift, page_number);
//
//		// make example structure
//		struct STR {
//			u8_t abc;
//			u32_t bca;
//			char str[4];
//			fl_t gg;
//		} _str, _str2;
//
//
//		// fill instance
//		_str.abc = 0x20;
//		_str.bca = 0x3F3F4A;
//		_str.str[0] = 'a';
//		_str.str[1] = 'b';
//		_str.str[2] = 'c';
//		_str.str[3] = '\0';
//		_str.gg = 0.658;
//
//
//		u16_t len = sizeof(_str);	// length of structure in bytes
//
//		// program structure
//		W25Q_ProgramData((u8_t*) &_str, len, 1+in_page_shift, page_number);
//		// read structure to another instance
//		W25Q_ReadData((u8_t*) &_str2, len, 1+in_page_shift, page_number);
//
//		//W25Q_EraseChip();
		uint8_t testBuff[256] = {};

//		 if(f_mount(&SDFatFS, (TCHAR const*)SDPath, 0) != FR_OK)
//		  {
//		      Error_Handler();
//		  }
//		  else
//		  {
////		      if(f_mkfs((TCHAR const*)SDPath, FM_ANY, 0, rtext, sizeof(rtext)) != FR_OK)
////		      {
////		          Error_Handler();
////		      }
////		      else
////		      {
//		          //Open file for writing (Create)
//		          if(f_open(&SDFile, "STM32.TXT", FA_CREATE_ALWAYS | FA_WRITE) != FR_OK)
//		          {
//		              Error_Handler();
//		          }
//		          else
//		          {
//
//
//
//		              //Write to the text file
//		              res = f_write(&SDFile, wtext, strlen((char *)wtext), (void *)&byteswritten);
//		              for(int i = 0; i <100; i++)
//		              {
//		            	  f_write(&SDFile, wtext, strlen((char *)wtext), (void *)&byteswritten);
//		              }
//		              if((byteswritten == 0) || (res != FR_OK))
//		              {
//		                  Error_Handler();
//		              }
//		              else
//		              {
//
//
//
//		                  f_close(&SDFile);
//		              }
//		          }
////		      }
//		  }
//		  f_mount(&SDFatFS, (TCHAR const*)NULL, 0);







		//W25Q_Sleep();	// go to sleep

	
  /* Infinite loop */
  for(;;)
  {
	HAL_GPIO_TogglePin(LED1_GPIO_Port, LED1_Pin);
    osDelay(500);
  }
  /* USER CODE END StartKeepaliveTask */
}

/* USER CODE BEGIN Header_StartHubTask */
/**
* @brief Function implementing the hubTask thread.
* @param argument: Not used
* @retval None
*/

#define HUB_ADDRESS 0b0101100<<1
#define FFH_CMD 0b1
/* USER CODE END Header_StartHubTask */
void StartHubTask(void *argument)
{
  /* USER CODE BEGIN StartHubTask */
	HAL_GPIO_WritePin(HUB_RESET_GPIO_Port, HUB_RESET_Pin, 1);
	osDelay(10);
	static uint8_t hubTxBuffer[17] = {16, 0x24, 0x04, 0x14, 0x25, 0xB3, 0x0B, 0x00, 0x00, 0x00, 0b11100, 0b10, 0b10, 0x01, 0x32, 0x32,};
	HAL_I2C_Init(&hubI2C);


	HAL_I2C_Mem_Write(&hubI2C, HUB_ADDRESS, 0x00, 1, hubTxBuffer, 17, 10);

	hubTxBuffer[0] = 1;
	hubTxBuffer[1] = FFH_CMD;
	HAL_I2C_Mem_Write(&hubI2C, HUB_ADDRESS, 0xff, 1, hubTxBuffer, 2, 10);


  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END StartHubTask */
}

/* USER CODE BEGIN Header_StartGpsTask */
/**
* @brief Function implementing the gpsTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartGpsTask */
void StartGpsTask(void *argument)
{
  /* USER CODE BEGIN StartGpsTask */
	HAL_GPIO_WritePin(GPS_RST_GPIO_Port, GPS_RST_Pin, 1);
	osDelay(10);
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END StartGpsTask */
}

/* USER CODE BEGIN Header_StartOledTask */
/**
* @brief Function implementing the oledTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartOledTask */
void StartOledTask(void *argument)
{
  /* USER CODE BEGIN StartOledTask */
	ssd1306_Init();
	ssd1306_WriteString("IMUnav_STM_F00", Font_7x10 , White);
	ssd1306_UpdateScreen();
  /* Infinite loop */
  for(;;)
  {
    osDelay(10000);

  }
  /* USER CODE END StartOledTask */
}

/* USER CODE BEGIN Header_StartPowerTask */
volatile uint16_t adcDataDMA[4];
#define USB_CHANNEL 0
#define BAT_CHANNEL 1
#define TMP_CHANNEL 2
#define REF_CHANNEL 3
#define ADCIIRCOEFF 0.3



/**
* @brief Function implementing the powerTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartPowerTask */
void StartPowerTask(void *argument)
{
  /* USER CODE BEGIN StartPowerTask */
	HAL_ADC_Init(&analogADC);

	float supplyVoltage = 3.3;
	float mcuTemp = 25;
	float battVoltage = 3.7;
	float usbVoltage = 5;
	float battVoltageFilt = 3.7;





	//minimum temperature sensor sampling time 10us, slope 2.5mv/degC, 0.76V at 25degC


  /* Infinite loop */
  for(;;)
  {
	  HAL_ADC_Start_DMA(&analogADC, (uint32_t*) adcDataDMA, 4);
	  osDelay(100);

	  supplyVoltage = *VREFINT_CAL_ADDR * VREFINT_CAL_VREF / adcDataDMA[REF_CHANNEL]/1000.0;
	  mcuTemp = -279.0 + 400.0*(supplyVoltage*adcDataDMA[TMP_CHANNEL]/4095.0);
	  usbVoltage = (supplyVoltage*adcDataDMA[USB_CHANNEL]/4095.0)*(33.0+27.0)/33.0;
	  battVoltage = (supplyVoltage*adcDataDMA[BAT_CHANNEL]/4095.0)*(33.0+27.0)/33.0;

	  battVoltageFilt = ADCIIRCOEFF * battVoltage + (1.0-ADCIIRCOEFF)*battVoltageFilt;


	  if(battVoltageFilt < 3.5) // batttery low voltage
	  {
		  HAL_GPIO_WritePin(PWR_OFF_GPIO_Port, PWR_OFF_Pin, 1);
		  while(1)
		  {
			  //

		  }
	  }




	  osDelay(1000);

  }
  /* USER CODE END StartPowerTask */
}

/* USER CODE BEGIN Header_StartAdisTask */


/**
* @brief Function implementing the adisTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartAdisTask */
void StartAdisTask(void *argument)
{
  /* USER CODE BEGIN StartAdisTask */
	adisReset();
	adisInit();
	adisDataStruc adisLog;
	loggerStruc loggerData;





	/* Infinite loop */
  for(;;)
  {
	  adisLog = adisRead();
	  loggerData.adisData = adisLog;
	  //osMessageQueuePut(adisQHandle,  &adisLog, 1, osWaitForever);
	  if(osMessageQueueGetCount(lsmQHandle)>0)
	  {
		  osMessageQueueGet(lsmQHandle, &loggerData.lsmData, NULL, osWaitForever);
	  }
	  else
	  {
		  //loggerData.lsmData = NULL;

	  }
	  osMessageQueuePut(loggerQHandle,  &loggerData, 1, osWaitForever);


  }
  /* USER CODE END StartAdisTask */
}

/* USER CODE BEGIN Header_StartLsmTask */

/**
* @brief Function implementing the lsmTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartLsmTask */
void StartLsmTask(void *argument)
{
  /* USER CODE BEGIN StartLsmTask */
	lsmDataStruc lsmLog;

	osDelay(1000);
	lsmInit();
	osDelay(100);

  /* Infinite loop */
  for(;;)
  {

	  lsmLog = lsmRead();
	  osMessageQueuePut(lsmQHandle,  &lsmLog, 1, osWaitForever);


  }
  /* USER CODE END StartLsmTask */
}

/* USER CODE BEGIN Header_StartLoggerTask */
loggerStruc loggerStore[10];
loggerStruc loggerStoreFS;
/**
* @brief Function implementing the loggerTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartLoggerTask */
void StartLoggerTask(void *argument)
{
  /* USER CODE BEGIN StartLoggerTask */
	uint8_t buffer[sizeof(loggerStoreFS)];
	if (f_mount(&SDFatFS, (TCHAR const*) SDPath, 0) != FR_OK)
	{
		Error_Handler();
	}
	else
	{

		//Open file for writing (Create)
		if (f_open(&SDFile, "imuData.bin", FA_CREATE_ALWAYS | FA_WRITE) != FR_OK)
		{
			Error_Handler();
		}
		else
		{

//			//Write to the text file
//			f_write(&SDFile, wtext, strlen((char*) wtext),
//					(void*) &byteswritten);

		}

	}

	uint32_t i = 0;
	while(i<10000)
	{
		osMessageQueueGet(loggerQHandle, &loggerStoreFS, NULL, osWaitForever);
		memcpy(buffer, &loggerStoreFS, sizeof(loggerStoreFS));
		f_write(&SDFile, buffer, sizeof(loggerStoreFS),
							(void*) &byteswritten);
		i++;
	}

	f_close(&SDFile);
	f_mount(&SDFatFS, (TCHAR const*) NULL, 0);
	MX_USB_DEVICE_Init();
	i = 0;
  /* Infinite loop */
  for(;;)
  {

    osDelay(1);
    osMessageQueueGet(loggerQHandle, &loggerStore[i], NULL, osWaitForever);
    i++;
    if(i==10)
    {
    	i=0;
    }
  }
  /* USER CODE END StartLoggerTask */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin)
{
	if (GPIO_Pin == ADIS_DR_Pin)
	{
		if (adisReady())
		{
			adisTriggerDMA();
		}
	}

	if (GPIO_Pin == LSM_INTMAG_Pin)
	{
		lsmTriggerDMA();

	}
}
/* USER CODE END Application */

