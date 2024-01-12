/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
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

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f4xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define hubI2C hi2c2
#define gpsUART huart2
#define oledI2C hfmpi2c1
#define LED1_Pin GPIO_PIN_4
#define LED1_GPIO_Port GPIOE
#define LED2_Pin GPIO_PIN_5
#define LED2_GPIO_Port GPIOE
#define LED3_Pin GPIO_PIN_6
#define LED3_GPIO_Port GPIOE
#define USB_VOLTAGE_ADC_Pin GPIO_PIN_0
#define USB_VOLTAGE_ADC_GPIO_Port GPIOA
#define BATT_VOLTAGE_Pin GPIO_PIN_1
#define BATT_VOLTAGE_GPIO_Port GPIOA
#define GPS_RX_Pin GPIO_PIN_2
#define GPS_RX_GPIO_Port GPIOA
#define GPS_TX_Pin GPIO_PIN_3
#define GPS_TX_GPIO_Port GPIOA
#define GPS_RST_Pin GPIO_PIN_4
#define GPS_RST_GPIO_Port GPIOA
#define PWR_OFF_Pin GPIO_PIN_15
#define PWR_OFF_GPIO_Port GPIOE
#define HUB_SCL_Pin GPIO_PIN_10
#define HUB_SCL_GPIO_Port GPIOB
#define HUB_RESET_Pin GPIO_PIN_12
#define HUB_RESET_GPIO_Port GPIOB
#define OLED_SCL_Pin GPIO_PIN_14
#define OLED_SCL_GPIO_Port GPIOD
#define OLED_SDA_Pin GPIO_PIN_15
#define OLED_SDA_GPIO_Port GPIOD
#define HUB_SDA_Pin GPIO_PIN_12
#define HUB_SDA_GPIO_Port GPIOC

/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */
