#ifndef CAPTIVEPORTAL_H
#define CAPTIVEPORTAL_H

#include <stdbool.h>
#include <stddef.h>

#define MAX_SSID_LEN 32
#define MAX_PASS_LEN 64

// Struktura za cuvanje kredencijala
typedef struct {
    char ssid[MAX_SSID_LEN];
    char password[MAX_PASS_LEN];
    bool received;
} wifi_credentials_t;

// Funkcija za dobijanje kredencijala

void init_captive_portal(void);
void captiveportal_init();
void captiveportal_stop();
bool get_wifi_credentials(char *ssid, char *password, size_t max_len);
bool is_captive_portal_active();
#endif