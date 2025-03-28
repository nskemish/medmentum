/* MQTT (over TCP) Example

   This example code is in the Public Domain (or CC0 licensed, at your option.)

   Unless required by applicable law or agreed to in writing, this
   software is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
   CONDITIONS OF ANY KIND, either express or implied.
*/

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <inttypes.h>
#include "esp_system.h"
#include "nvs_flash.h"
#include "esp_event.h"
#include "esp_netif.h"
#include "esp_log.h"
#include "mqtt_client.h"
#include "mqtt.h"


static const char *TAG = "MQTT_CLIENT";
static esp_mqtt_client_handle_t client = NULL;
static mqtt_message_callback_t message_callback = NULL;

static void mqtt_event_handler(void *handler_args, esp_event_base_t base, 
                             int32_t event_id, void *event_data)
{
    esp_mqtt_event_handle_t event = event_data;
    
    switch ((esp_mqtt_event_id_t)event_id) {
    case MQTT_EVENT_CONNECTED:
        ESP_LOGI(TAG, "MQTT Connected");
        break;
        
    case MQTT_EVENT_DISCONNECTED:
        ESP_LOGI(TAG, "MQTT Disconnected");
        break;

    case MQTT_EVENT_DATA:
        ESP_LOGI(TAG, "MQTT Message Received");
        if (message_callback) {
            // Kopiraj topic i podatke zbog null-termination
            char topic[event->topic_len + 1];
            memcpy(topic, event->topic, event->topic_len);
            topic[event->topic_len] = '\0';
            
            char data[event->data_len + 1];
            memcpy(data, event->data, event->data_len);
            data[event->data_len] = '\0';
            
            message_callback(topic, data, event->data_len);
        }
        break;

    default:
        break;
    }
}

void mqtt_client_init(const char* broker_url, const char* username, const char* password)
{
    esp_mqtt_client_config_t mqtt_cfg = {
        .broker.address.uri = broker_url,
    };
    
    if (username && password) {
        mqtt_cfg.credentials.username = username;
        mqtt_cfg.credentials.authentication.password = password;
    }

    client = esp_mqtt_client_init(&mqtt_cfg);
    esp_mqtt_client_register_event(client, ESP_EVENT_ANY_ID, mqtt_event_handler, NULL);
    esp_mqtt_client_start(client);
}

int mqtt_publish(const char* topic, const char* data, int qos)
{
    if (!client) return -1;
    return esp_mqtt_client_publish(client, topic, data, 0, qos, 0);
}

int mqtt_subscribe(const char* topic, int qos)
{
    if (!client) return -1;
    return esp_mqtt_client_subscribe(client, topic, qos);
}

void mqtt_set_callback(mqtt_message_callback_t callback)
{
    message_callback = callback;
}