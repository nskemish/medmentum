#include "freertos/FreeRTOS.h"
#include "freertos/task.h"
#include "esp_log.h"
#include "mcpwm_prelude.h"

#include "servotask.h"
#include "esp_log.h"

static const char *TAG = "Servo360";

#define SERVO_TIMEBASE_HZ   1000000 // 1MHz = 1μs rezolucija
#define SERVO_PERIOD_TICKS  20000   // 20ms period (standard za servo)

void servoinit(servocfg *servo, int gpio_num) {
    // Konfiguracija tajmera
    mcpwm_timer_config_t timer_cfg = {
        .group_id = 0,
        .clk_src = MCPWM_TIMER_CLK_SRC_DEFAULT,
        .resolution_hz = SERVO_TIMEBASE_HZ,
        .period_ticks = SERVO_PERIOD_TICKS,
        .count_mode = MCPWM_TIMER_COUNT_MODE_UP,
    };
    ESP_ERROR_CHECK(mcpwm_new_timer(&timer_cfg, &servo->timer));

    // Konfiguracija operatora
    mcpwm_operator_config_t oper_cfg = { .group_id = 0 };
    ESP_ERROR_CHECK(mcpwm_new_operator(&oper_cfg, &servo->oper));

    // Poveži timer i operator
    ESP_ERROR_CHECK(mcpwm_operator_connect_timer(servo->oper, servo->timer));

    // Komparator (određuje širinu pulsa)
    mcpwm_comparator_config_t cmp_cfg = { .flags.update_cmp_on_tez = true };
    ESP_ERROR_CHECK(mcpwm_new_comparator(servo->oper, &cmp_cfg, &servo->comparator));

    // Generator (izlaz na GPIO)
    mcpwm_generator_config_t gen_cfg = { .gen_gpio_num = gpio_num };
    ESP_ERROR_CHECK(mcpwm_new_generator(servo->oper, &gen_cfg, &servo->generator));

    // Postavi akcije:
    // - VISOK nivo na početku periode
    // - NISK nivo kada komparator dostigne vrednost
    ESP_ERROR_CHECK(mcpwm_generator_set_action_on_timer_event(
        servo->generator,
        MCPWM_GEN_TIMER_EVENT_ACTION(MCPWM_TIMER_DIRECTION_UP, MCPWM_TIMER_EVENT_EMPTY, MCPWM_GEN_ACTION_HIGH)
    ));
    ESP_ERROR_CHECK(mcpwm_generator_set_action_on_compare_event(
        servo->generator,
        MCPWM_GEN_COMPARE_EVENT_ACTION(MCPWM_TIMER_DIRECTION_UP, servo->comparator, MCPWM_GEN_ACTION_LOW)
    ));

    // Pokreni timer
    ESP_ERROR_CHECK(mcpwm_timer_enable(servo->timer));
    ESP_ERROR_CHECK(mcpwm_timer_start_stop(servo->timer, MCPWM_TIMER_START_NO_STOP));
}

void servosetspeed(servocfg *servo, uint32_t pulse_width_us) {
    ESP_ERROR_CHECK(mcpwm_comparator_set_compare_value(servo->comparator, pulse_width_us));
}

void servostop(servocfg *servo) {
    servosetspeed(servo, SERVO_STOP_US);
}

void servofull_cw(servocfg *servo) {
    servosetspeed(servo, SERVO_FULL_CW_US);
}

void servofull_ccw(servocfg *servo) {
    servosetspeed(servo, SERVO_FULL_CCW_US);
}