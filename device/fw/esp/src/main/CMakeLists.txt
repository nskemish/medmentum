idf_component_register(SRCS "main.c"
                    PRIV_REQUIRES spi_flash captiveportal nvs_flash taskengine
                    INCLUDE_DIRS ".")
