#ifndef SERVOTASK_H
#define SERVOTASK_H

#include "../../servotask/include/driver/mcpwm_prelude.h"

// Definicije za 360° servo
#define SERVO_FULL_CW_US      500   // Puna brzina u jednom smeru (CW)
#define SERVO_STOP_US        1500   // Stop
#define SERVO_FULL_CCW_US    2500   // Puna brzina u drugom smeru (CCW)

// Struktura za kontrolu servo motora
typedef struct {
    mcpwm_timer_handle_t timer;
    mcpwm_oper_handle_t oper;
    mcpwm_cmpr_handle_t comparator;
    mcpwm_gen_handle_t generator;
} servocfg;

// Funkcije za upravljanje servom
void servoinit(servocfg *servo, int gpio_num);
void servosetspeed(servocfg *servo, uint32_t pulse_width_us);
void servostop(servocfg *servo);
void servofull_cw(servocfg *servo);
void servofull_ccw(servocfg *servo);

#endif // SERVO_360_H