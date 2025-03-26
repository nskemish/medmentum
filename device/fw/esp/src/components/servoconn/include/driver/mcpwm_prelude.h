/*
 * SPDX-FileCopyrightText: 2022-2023 Espressif Systems (Shanghai) CO LTD
 *
 * SPDX-License-Identifier: Apache-2.0
 */

/**
 * @brief MCPWM peripheral contains many submodules, whose drivers are scattered in different header files.
 *        This header file serves as a prelude, contains every thing that is needed to work with the MCPWM peripheral.
 */

#pragma once

#include "mcpwm_timer.h"
#include "mcpwm_oper.h"
#include "mcpwm_cmpr.h"
#include "mcpwm_gen.h"
#include "mcpwm_fault.h"
#include "mcpwm_sync.h"
#include "mcpwm_cap.h"
#include "mcpwm_etm.h"
