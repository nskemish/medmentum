#ifndef WIFITASK_H
#define WIFITASK_H

#include <stdbool.h>

void wifi_init();
bool wifi_connect();
bool is_wifi_connected();

#endif