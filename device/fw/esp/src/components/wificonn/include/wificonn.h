#ifndef WIFICONN_H
#define WIFICONN_H

#include <stdbool.h>

void wifi_init();
bool wifi_connect();
bool is_wifi_connected();

#endif