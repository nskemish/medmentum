/*
 * SPDX-FileCopyrightText: 2010-2022 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: CC0-1.0
 */

#include <stdio.h>
#include "wificonn.h"
#include "captiveportal.h"
#include "freertos/FreeRTOS.h"
#include "servoconn.h"
#include "esp_log.h"

void app_main() {
    // Pokreni captive portal
    captiveportal_init();
    
    servomain();
    
    // Glavna petlja
    while(1) {
        // Proveri da li imamo kredencijale
        if(get_wifi_credentials(NULL, NULL, 0)) {
            // Inicijalizuj WiFi sa dobijenim kredencijalima
            wifi_init();
            
            // Pokušaj povezivanje
            if(wifi_connect()) {
                // Čekaj konekciju
                while(!is_wifi_connected()) {
                    vTaskDelay(1000 / portTICK_PERIOD_MS);
                }
                ESP_LOGI("Main", "Uspesno povezan na WiFi!");
                break;
            }
        }
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
    
    // Ostatak programa...
}