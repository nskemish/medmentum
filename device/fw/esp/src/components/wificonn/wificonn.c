#include <stdbool.h>
#include <string.h>
#include "wificonn.h"
#include "esp_log.h"
#include "captiveportal.h"
#include "esp_wifi.h"

static const char* TAG = "WiFiManager";

void wifi_init() {
    wifi_config_t wifi_config = {0};
    
    // Dobij kredencijale iz captive portala
    if(get_wifi_credentials((char*)wifi_config.sta.ssid, (char*)wifi_config.sta.password, 
                          sizeof(wifi_config.sta.ssid))) {
        
        ESP_LOGI(TAG, "Povezivanje na WiFi: %s", wifi_config.sta.ssid);
        
        // Inicijalizacija WiFi u STA modu
        esp_netif_create_default_wifi_sta();
        wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
        ESP_ERROR_CHECK(esp_wifi_init(&cfg));
        
        // Postavi WiFi konfiguraciju
        ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_STA));
        ESP_ERROR_CHECK(esp_wifi_set_config(ESP_IF_WIFI_STA, &wifi_config));
        ESP_ERROR_CHECK(esp_wifi_start());
    } else {
        ESP_LOGE(TAG, "Nema WiFi kredencijala!");
    }
}

bool wifi_connect() {
    esp_err_t err = esp_wifi_connect();
    if (err == ESP_OK) {
        ESP_LOGI(TAG, "Pokrenuto povezivanje na WiFi");
        return true;
    }
    ESP_LOGE(TAG, "Greška pri povezivanju: %s", esp_err_to_name(err));
    return false;
}

bool is_wifi_connected() {
    wifi_ap_record_t ap_info;
    return (esp_wifi_sta_get_ap_info(&ap_info) == ESP_OK);
}