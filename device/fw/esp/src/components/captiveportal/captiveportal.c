#include <strings.h>
#include <sys/_intsup.h>
#include <sys/param.h>
#include "esp_event.h"
#include "esp_log.h"
#include "esp_mac.h"
#include "esp_wifi_types_generic.h"
#include "freertos/idf_additions.h"
#include "http_parser.h"
#include "nvs_flash.h"
#include "esp_wifi.h"
#include "esp_netif.h"
#include "lwip/inet.h"
#include "esp_http_server.h"
#include "dns_server.h"
#include <stdbool.h>
#include <time.h>
#include "captiveportal.h"
#include <string.h>
#include <stdio.h>

static const char *TAG = "Captive Portal";
static httpd_handle_t server = NULL;
static dns_server_handle_t dns_server = NULL;
static wifi_credentials_t s_credentials = {0};

static void wifi_event_handler(void *arg, esp_event_base_t event_base,
                             int32_t event_id, void *event_data) {

    
    if (event_id == WIFI_EVENT_AP_STACONNECTED) {
        wifi_event_ap_staconnected_t *event = (wifi_event_ap_staconnected_t *)event_data;

    } else if (event_id == WIFI_EVENT_AP_STADISCONNECTED) {
        wifi_event_ap_stadisconnected_t *event = (wifi_event_ap_stadisconnected_t *)event_data;

    }

}

// Inicijalizacija WiFi SoftAP
static void wifi_init_softap() {
    wifi_init_config_t cfg = WIFI_INIT_CONFIG_DEFAULT();
    ESP_ERROR_CHECK(esp_wifi_init(&cfg));
    ESP_ERROR_CHECK(esp_event_handler_register(WIFI_EVENT, ESP_EVENT_ANY_ID, &wifi_event_handler, NULL));

    wifi_config_t wifi_config = {
        .ap = {
            .ssid = "MedMentum",
            .ssid_len = strlen("MedMentum"),
            .password = "",
            .max_connection = 1,
            .authmode = WIFI_AUTH_OPEN
        },
    };

    ESP_ERROR_CHECK(esp_wifi_set_mode(WIFI_MODE_AP));
    ESP_ERROR_CHECK(esp_wifi_set_config(ESP_IF_WIFI_AP, &wifi_config));
    ESP_ERROR_CHECK(esp_wifi_start());

    esp_netif_ip_info_t ip_info;
    esp_netif_get_ip_info(esp_netif_get_handle_from_ifkey("WIFI_AP_DEF"), &ip_info);

    char ip_addr[16];
    inet_ntoa_r(ip_info.ip.addr, ip_addr, 16);
    
}


// Funkcija za postavljanje URL-a za captive portal preko DHCP-a
static void dhcp_set_captiveportal_url(void) {
    // Dobijanje IP adrese pristupne tačke za redirekciju
    esp_netif_ip_info_t ip_info;
    esp_netif_get_ip_info(esp_netif_get_handle_from_ifkey("WIFI_AP_DEF"), &ip_info);

    char ip_addr[16];
    inet_ntoa_r(ip_info.ip.addr, ip_addr, 16);
    ESP_LOGI(TAG, "SoftAP podešen sa IP: %s", ip_addr);

    // Pretvaranje IP adrese u URI
    char* captiveportal_uri = (char*) malloc(32 * sizeof(char));
    assert(captiveportal_uri && "Neuspešna alokacija captiveportal_uri");
    strcpy(captiveportal_uri, "http://");
    strcat(captiveportal_uri, ip_addr);

    // Dobijanje handle-a za konfigurisanje DHCP-a
    esp_netif_t* netif = esp_netif_get_handle_from_ifkey("WIFI_AP_DEF");

    // Postavljanje DHCP opcije 114
    ESP_ERROR_CHECK_WITHOUT_ABORT(esp_netif_dhcps_stop(netif));
    ESP_ERROR_CHECK(esp_netif_dhcps_option(netif, ESP_NETIF_OP_SET, ESP_NETIF_CAPTIVEPORTAL_URI, captiveportal_uri, strlen(captiveportal_uri)));
    ESP_ERROR_CHECK_WITHOUT_ABORT(esp_netif_dhcps_start(netif));
}

void urldecode(char *dst, const char *src) {
    unsigned char a, b;  // Promenjeno u unsigned char
    while (*src) {
        if ((*src == '%') && (src[1]) && (src[2]) && 
            isxdigit((unsigned char)src[1]) &&  // Eksplicitna konverzija
            isxdigit((unsigned char)src[2])) {  // Eksplicitna konverzija
            a = src[1];
            b = src[2];
            if (a >= 'a') a -= 'a'-'A';
            if (a >= 'A') a -= ('A' - 10);
            else a -= '0';
            if (b >= 'a') b -= 'a'-'A';
            if (b >= 'A') b -= ('A' - 10);
            else b -= '0';
            *dst++ = 16*a + b;
            src += 3;
        } else if (*src == '+') {
            *dst++ = ' ';
            src++;
        } else {
            *dst++ = *src++;
        }
    }
    *dst = '\0';
}

extern const char index_start[] asm("_binary_index_html_start");
extern const char index_end[] asm("_binary_index_html_end");
extern const char image_start[] asm("_binary_image_svg_start");
extern const char image_end[] asm("_binary_image_svg_end");


static esp_err_t getindex(httpd_req_t *req) {
    extern const char index_start[] asm("_binary_index_html_start");
    extern const char index_end[] asm("_binary_index_html_end");

    httpd_resp_set_type(req, "text/html");
    httpd_resp_send(req, index_start, index_end - index_start);
    return ESP_OK;
}

static const httpd_uri_t index_url = {
    .uri = "/",            // URL putanja
    .method = HTTP_GET,         // Tip HTTP metode
    .handler = getindex    // Funkcija za obradu zahtjeva
};



static esp_err_t getsvg(httpd_req_t *req) {
    extern const char image_start[] asm("_binary_image_svg_start");
    extern const char image_end[] asm("_binary_image_svg_end");
    
    httpd_resp_set_type(req, "image/svg+xml");
    httpd_resp_send(req, image_start, image_end - image_start);
    return ESP_OK;
}

static const httpd_uri_t svg_url = {
    .uri = "/image.svg",
    .method = HTTP_GET,
    .handler = getsvg
};

static esp_err_t getsubmit(httpd_req_t *req) {
    char content[256];
    int ret = httpd_req_recv(req, content, sizeof(content)-1);
    if (ret <= 0) {
        if (ret == HTTPD_SOCK_ERR_TIMEOUT) {
            httpd_resp_send_408(req);
        }
        return ESP_FAIL;
    }
    content[ret] = '\0';

    char *ssid_start = strstr(content, "ssid=");
    char *pass_start = strstr(content, "password=");

    if (ssid_start && pass_start) {
        ssid_start += 5;
        pass_start += 9;

        // Parsiranje SSID
        char *ssid_end = strchr(ssid_start, '&');
        size_t ssid_len = ssid_end ? (size_t)(ssid_end - ssid_start) : strlen(ssid_start);
        ssid_len = ssid_len < MAX_SSID_LEN ? ssid_len : MAX_SSID_LEN-1;
        
        // Parsiranje passworda
        size_t pass_len = strlen(pass_start);
        pass_len = pass_len < MAX_PASS_LEN ? pass_len : MAX_PASS_LEN-1;

        // Čuvanje kredencijala
        strncpy(s_credentials.ssid, ssid_start, ssid_len);
        s_credentials.ssid[ssid_len] = '\0';
        
        strncpy(s_credentials.password, pass_start, pass_len);
        s_credentials.password[pass_len] = '\0';
        
        s_credentials.received = true;
        
      
        captiveportal_stop();
    }

    httpd_resp_send(req, "OK", HTTPD_RESP_USE_STRLEN);
    return ESP_OK;
}

static const httpd_uri_t submit_url = {
    .uri = "/submit",            // URL putanja
    .method = HTTP_POST,         // Tip HTTP metode
    .handler = getsubmit    // Funkcija za obradu zahtjeva
};

// HTTP Error (404) Handler - Redirekcija svih zahteva na root stranicu
esp_err_t http_404_error_handler(httpd_req_t *req, httpd_err_code_t err)
{
    // Postavljanje statusa
    httpd_resp_set_status(req, "302 Temporary Redirect");
    // Redirekcija na "/" root direktorijum
    httpd_resp_set_hdr(req, "Location", "/");
    // iOS zahteva sadržaj u odgovoru
    httpd_resp_send(req, "Redirect to captive portal", HTTPD_RESP_USE_STRLEN);

    ESP_LOGI(TAG, "Redirecting to root");
    return ESP_OK;
}


static httpd_handle_t start_webserver(void)
{
    httpd_handle_t server = NULL;
    httpd_config_t config = HTTPD_DEFAULT_CONFIG();
    config.max_open_sockets = 13;
    config.lru_purge_enable = true;

    ESP_LOGI(TAG, "Pokretanje servera na portu: '%d'", config.server_port);
    if (httpd_start(&server, &config) == ESP_OK) {
        // Registruj sve URI handlere
        httpd_register_uri_handler(server, &index_url);
        httpd_register_uri_handler(server, &svg_url);
        httpd_register_uri_handler(server, &submit_url);  // OVO JE KLJUČNI DODATAK
        httpd_register_err_handler(server, HTTPD_404_NOT_FOUND, http_404_error_handler);
    }
    return server;
}

// Glavna funkcija aplikacije
void captiveportal_init() {
    // Inicijalizacija mreže
    ESP_ERROR_CHECK(esp_netif_init());
    ESP_ERROR_CHECK(esp_event_loop_create_default());
    ESP_ERROR_CHECK(nvs_flash_init());
    esp_netif_create_default_wifi_ap();
    
    // Pokreni WiFi AP
    wifi_init_softap();
    start_webserver();
    dhcp_set_captiveportal_url();


    // DNS server
    dns_server_config_t dns_config = DNS_SERVER_CONFIG_SINGLE("*", "WIFI_AP_DEF");
    dns_server = start_dns_server(&dns_config);

    // Pokreni portal task
}


// Zaustavljanje portala
void captiveportal_stop() {
    if (server) {
        httpd_stop(server);
        server = NULL;
    }
    
    if (dns_server) {
        stop_dns_server(dns_server);
        dns_server = NULL;
    }
        
}

// Dobijanje kredencijala
bool get_wifi_credentials(char *ssid, char *password, size_t max_len) {
    if (!s_credentials.received) return false;
    
    if (ssid) strlcpy(ssid, s_credentials.ssid, max_len);
    if (password) strlcpy(password, s_credentials.password, max_len);
    
    return true;
}

// Provera statusa
bool is_captive_portal_active() {
    return (server != NULL);
}