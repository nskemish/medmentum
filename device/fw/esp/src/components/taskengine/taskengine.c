#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "captiveportal.h"
#include "hal/gpio_types.h"
#include "servotask.h"
#include "soc/gpio_num.h"
#include "wifitask.h"
#include "mqtt.h"
#include <stdbool.h>
#include <time.h>
#include "esp_intr_alloc.h"        
#include "esp_attr.h"            
#include "driver/rtc_io.h"  
#include "driver/gpio.h"


#define GPIO_INPUT_PIN      GPIO_NUM_12

static const char *TAG = "TaskEngine";

// Globalne promenljive za praćenje stanja
static bool wifi_credentials_received = false;
static bool wifi_connected = false;
static bool mqtt_connected = false;

volatile bool enable_button = false;
volatile bool start_servo_flag = false;


// Handler za MQTT poruke
static void mqtt_message_handler(const char* topic, const char* data, int len)
{
    ESP_LOGI(TAG, "Primljena MQTT poruka:\nTopic: %s\nData: %.*s", topic, len, data);
}

void startservo2(){
	servocfg servo;
	servoinit(&servo, 15);
	ESP_LOGI("MAIN", "Puna brzina u CW smeru (otvaranje fioke)");
    servofull_ccw(&servo);
    vTaskDelay(pdMS_TO_TICKS(7000));  // 2 sekunde

    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
    vTaskDelay(pdMS_TO_TICKS(1000));  // 1 sekunda
    
    ESP_LOGI("MAIN", "Puna brzina u CCW smeru (otvaranje fioke)");
    servofull_cw(&servo);
    vTaskDelay(pdMS_TO_TICKS(7000));  // 2 sekunde
    
    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
}

void startservo4(){
	servocfg servo;
	servoinit(&servo, 2);
	ESP_LOGI("MAIN", "Puna brzina u CW smeru (otvaranje fioke)");
    servofull_ccw(&servo);
    vTaskDelay(pdMS_TO_TICKS(7000));  // 2 sekunde

    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
    vTaskDelay(pdMS_TO_TICKS(1000));  // 1 sekunda
    
    ESP_LOGI("MAIN", "Puna brzina u CCW smeru (otvaranje fioke)");
    servofull_cw(&servo);
    vTaskDelay(pdMS_TO_TICKS(7000));  // 2 sekunde
    
    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
    vTaskDelay(pdMS_TO_TICKS(500));
    
}

void startservofio(){
	servocfg servo;
	servoinit(&servo, 4);
	ESP_LOGI("MAIN", "Puna brzina u CW smeru (otvaranje fioke)");
    servofull_ccw(&servo);
    vTaskDelay(pdMS_TO_TICKS(3000));  // 2 sekunde

    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
    vTaskDelay(pdMS_TO_TICKS(15000));  // 1 sekunda
    
    ESP_LOGI("MAIN", "Puna brzina u CCW smeru (otvaranje fioke)");
    servofull_cw(&servo);
    vTaskDelay(pdMS_TO_TICKS(3000));  // 2 sekunde
    
    ESP_LOGI("MAIN", "Stop");
    servostop(&servo);
    vTaskDelay(pdMS_TO_TICKS(500));
    
}

void servostarter(void){
	//servo police D5
	startservo2();
	vTaskDelay(pdMS_TO_TICKS(500));
	startservo4();
	vTaskDelay(pdMS_TO_TICKS(500));
	startservofio();
}


void internetstack(void)
{
	
    // 1. Inicijalizacija sistema
    ESP_LOGI(TAG, "Pokrećem sistem...");
    
    // 2. Pokretanje Captive Portala
    ESP_LOGI(TAG, "Pokrećem Captive Portal...");
    captiveportal_init();
    
    // 3. Glavna petlja čekanja WiFi kredencijala
    while(1) {
        char ssid[32] = {0};
        char password[64] = {0};
        
        // Provera da li su kredencijali primljeni preko portala
        if (get_wifi_credentials(ssid, password, sizeof(ssid))) {
            ESP_LOGI(TAG, "Primljeni WiFi kredencijali:");
            ESP_LOGI(TAG, "SSID: %s", ssid);
            ESP_LOGI(TAG, "Password: %s", password);
            
            // Zaustavi Captive Portal
            captiveportal_stop();
            wifi_credentials_received = true;
            
            // 4. Povezivanje na WiFi
            ESP_LOGI(TAG, "Pokušavam povezivanje na WiFi...");
            wifi_init(); // Ovo postavlja kredencijale iz captive portala
            wifi_connect();
            
            break; // Izlaz iz petlje čekanja kredencijala
        }
        
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
    
    // 5. Čekanje WiFi konekcije
    while(wifi_credentials_received && !wifi_connected) {
        if (is_wifi_connected()) {
            wifi_connected = true;
            ESP_LOGI(TAG, "WiFi uspešno povezan!");
        }
        vTaskDelay(1000 / portTICK_PERIOD_MS);
    }
    
    // 6. Pokretanje MQTT nakon WiFi konekcije
    if (wifi_connected) {

        ESP_LOGI(TAG, "Pokrećem MQTT klijent...");
        mqtt_client_init("mqtt://164.92.187.3", "ognjen", "elektropionir");
        mqtt_set_callback(mqtt_message_handler);
        mqtt_subscribe("device/commands", 1);
        mqtt_connected = true;
    }
    
    // 7. Glavna radna petlja (sa MQTT komunikacijom)
    int counter = 0;
    while(1) {
        if (wifi_connected && mqtt_connected) {
            // Slanje periodičnih status poruka
            char msg[50];
            snprintf(msg, sizeof(msg), "Status %d", counter++);
            mqtt_publish("device/status", msg, 1);
            ESP_LOGI(TAG, "Poslata MQTT poruka: %s", msg);
        }
        
        // Provera WiFi i MQTT stanja
        wifi_connected = is_wifi_connected();
        
        if (wifi_connected && !mqtt_connected) {
            // Ponovno pokretanje MQTT ako je WiFi povratak
            mqtt_client_init("mqtt://164.92.187.3", "ognjen", "elektropionir");
            mqtt_subscribe("device/commands", 1);
            mqtt_connected = true;
        }
        
        vTaskDelay(5000 / portTICK_PERIOD_MS);
    }
    
}

void button_task(void *arg) {
    gpio_set_direction(GPIO_INPUT_PIN , GPIO_MODE_INPUT);
    gpio_set_pull_mode(GPIO_INPUT_PIN , GPIO_PULLDOWN_ENABLE);  // Dugme aktivno LOW

    bool last_button_state = 0;  // Inicijalno HIGH (nije pritisnuto)
    while (1) {
        bool current_button_state = gpio_get_level(GPIO_INPUT_PIN );
        
        if (current_button_state == 1 && last_button_state == 0) {
            ESP_LOGI(TAG, "Dugme pritisnuto!");
            
            if (wifi_connected) {
                servostarter();  // Pokreni servo samo ako je WiFi povezan
            } else {
                ESP_LOGE(TAG, "WiFi NIJE povezan! Servo se ne pokreće.");
            }
        }
        last_button_state = current_button_state;
        vTaskDelay(20 / portTICK_PERIOD_MS);  // Debounce delay (20ms)
    }
}

void TaskEngine(){
	internetstack();
	xTaskCreate(button_task, "button_task", 2048, NULL, 10, NULL);
}

