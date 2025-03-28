idf_component_register(SRCS "mqtt.c"
                    PRIV_REQUIRES nvs_flash esp_event mqttlibs esp_netif mqtt
                    INCLUDE_DIRS "include")
