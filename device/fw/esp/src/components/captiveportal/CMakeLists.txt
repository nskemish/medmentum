idf_component_register(SRCS "captiveportal.c"
					PRIV_REQUIRES esp_wifi dns_server nvs_flash esp_http_server esp_https_server
                    INCLUDE_DIRS "include"
                    EMBED_FILES "static/index.html" "static/image.svg"
					EMBED_TXTFILES "cert/servercert.pem" "cert/prvtkey.pem")