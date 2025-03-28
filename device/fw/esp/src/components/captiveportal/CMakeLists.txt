idf_component_register(SRCS "captiveportal.c"
					PRIV_REQUIRES esp_wifi nvs_flash esp_http_server esp_https_server dns_server
					INCLUDE_DIRS "include"
                    EMBED_FILES "static/index.html" "static/image.svg")