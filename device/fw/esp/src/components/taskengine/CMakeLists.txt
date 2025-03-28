idf_component_register(SRCS "taskengine.c"
					PRIV_REQUIRES captiveportal mqtt wifitask servotask 
                    INCLUDE_DIRS "include")

