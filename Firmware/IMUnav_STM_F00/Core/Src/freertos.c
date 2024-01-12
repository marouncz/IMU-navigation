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
  .stack_size = 128 * 4,
  .priority = (osPriority_t) osPriorityNormal,
};
/* Definitions for keepaliveTask */
osThreadId_t keepaliveTaskHandle;
const osThreadAttr_t keepaliveTask_attributes = {
  .name = "keepaliveTask",
  .stack_size = 128 * 4,
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

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */

/* USER CODE END FunctionPrototypes */

void StartDefaultTask(void *argument);
void StartKeepaliveTask(void *argument);
void StartHubTask(void *argument);
void StartGpsTask(void *argument);
void StartOledTask(void *argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

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
/**
* @brief Function implementing the keepaliveTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartKeepaliveTask */
void StartKeepaliveTask(void *argument)
{
  /* USER CODE BEGIN StartKeepaliveTask */
	W25Q_Init();		 // init the chip
		//W25Q_EraseSector(0); // erase 4K sector - required before recording

		// make test data
		u8_t byte = 0x65;
		u8_t byte_read = 0;
		u8_t in_page_shift = 0;
		u8_t page_number = 0;
		// write data
		//W25Q_ProgramByte(byte, in_page_shift, page_number);
		// read data
		W25Q_ReadByte(&byte_read, in_page_shift, page_number);

		// make example structure
		struct STR {
			u8_t abc;
			u32_t bca;
			char str[4];
			fl_t gg;
		} _str, _str2;


		// fill instance
		_str.abc = 0x20;
		_str.bca = 0x3F3F4A;
		_str.str[0] = 'a';
		_str.str[1] = 'b';
		_str.str[2] = 'c';
		_str.str[3] = '\0';
		_str.gg = 0.658;


		u16_t len = sizeof(_str);	// length of structure in bytes

		// program structure
		//W25Q_ProgramData((u8_t*) &_str, len, 1+in_page_shift, page_number);
		// read structure to another instance
		W25Q_ReadData((u8_t*) &_str2, len, 1+in_page_shift, page_number);

		W25Q_Sleep();	// go to sleep

	
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
  /* Infinite loop */
  for(;;)
  {
    osDelay(1000);
  }
  /* USER CODE END StartOledTask */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */

/* USER CODE END Application */

