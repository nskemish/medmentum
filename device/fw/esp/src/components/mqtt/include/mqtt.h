#ifndef MQTT_CLIENT_H
#define MQTT_CLIENT_H

/**
 * @brief Inicijalizacija MQTT klijenta
 * @param broker_url URL MQTT brokera (npr. "mqtt://broker.hivemq.com")
 * @param username Korisničko ime za broker (NULL ako nije potrebno)
 * @param password Lozinka za broker (NULL ako nije potrebno)
 */
void mqtt_client_init(const char* broker_url, const char* username, const char* password);

/**
 * @brief Publikovanje poruke na MQTT topic
 * @param topic Naziv topica
 * @param data Podaci za slanje
 * @param qos QoS nivo (0, 1 ili 2)
 * @return msg_id ID poruke ili -1 ako nije uspelo
 */
int mqtt_publish(const char* topic, const char* data, int qos);

/**
 * @brief Pretplata na MQTT topic
 * @param topic Naziv topica
 * @param qos QoS nivo (0, 1 ili 2)
 * @return msg_id ID poruke ili -1 ako nije uspelo
 */
int mqtt_subscribe(const char* topic, int qos);

/**
 * @brief Callback za primljene MQTT poruke
 * @param topic Naziv topica
 * @param data Sadržaj poruke
 * @param len Dužina poruke
 */
typedef void (*mqtt_message_callback_t)(const char* topic, const char* data, int len);

/**
 * @brief Postavljanje callback funkcije za primljene poruke
 * @param callback Funkcija koja će biti pozvana kada stigne poruka
 */
void mqtt_set_callback(mqtt_message_callback_t callback);

#endif // MQTT_CLIENT_H