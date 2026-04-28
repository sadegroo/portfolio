+++
title = "Inverted Pendulum Stabilisation with BLDC Motor and STM32"
date = 2026-04-28
draft = true
tags = ["embedded", "control", "STM32", "BLDC"]
summary = "Stabilising an inverted pendulum on a BLDC actuator driven by an STM32 with field-oriented control."
+++

<!--
DRAFT — placeholder structure. Replace each section's placeholder text with
real content before flipping `draft = false`.
-->

## Overview

<!--
PLACEHOLDER — what to put here:

- 1–2 paragraphs setting the scene. What is the system? Why did you build it?
- Headline result in plain language ("balances within ±2° at the upright
  equilibrium for >5 minutes from a soft push").
- A photo or short clip of the working setup if you have one.
- Link to the GitHub repo and any prior writeups.
-->

Placeholder: short pitch + headline result + repo link.

## Hardware Setup

<!--
PLACEHOLDER — what to put here:

- Mechanical: pendulum geometry, mass, mount; how you measured / chose them.
- Actuator: BLDC motor model, stator/rotor counts, gear ratio (if any),
  reflected inertia.
- Sensors: rotor position (AS5600? AS5048? hall? encoder?), pendulum angle
  (encoder? IMU?), bandwidth and resolution.
- Power: bus voltage, current limits, safety mechanisms (fuse, e-stop).
- MCU + driver board: STM32 part number, gate driver IC (DRV8323? L6234?),
  shunt resistor placement, any ADC oddities.
- A wiring diagram (svg/png in `static/img/`).
-->

Placeholder: hardware bill of materials + photos/diagrams.

## Control Architecture

<!--
PLACEHOLDER — what to put here:

- Block diagram: torque loop (FOC) → speed loop → position loop → balance
  controller. SimpleFOC / your own implementation?
- FOC specifics: SVPWM vs sinusoidal, current sensing scheme, observer or
  sensor-based commutation, sample rate, bandwidth measurements.
- Outer balance loop: LQR, PID, sliding mode? State estimator? Show the
  state vector and gains.
- Real-time scheduling on the STM32: timer ISRs, DMA setup, jitter budget.
- Tuning methodology: model-based + handwave correction, system identification,
  trial and error?
-->

Placeholder: control block diagram + loop bandwidths + tuning notes.

## Results

<!--
PLACEHOLDER — what to put here:

- Plots: angle vs time, motor current, controller output. Disturbance
  rejection (push test).
- Quantitative: settling time, steady-state error, robustness margins.
- Failure modes you found and how you fixed them (or worked around them).
- Video link if you have one.
-->

Placeholder: plots + numbers + a short video.

## Source Code

<!--
PLACEHOLDER — what to put here:

- Direct link to the repo (and the specific tag/commit referenced by this
  writeup, so it doesn't bit-rot).
- Build instructions: toolchain, OpenOCD/ST-Link command, expected output
  on the serial console.
- Files worth reading first (FOC loop, balance controller, scheduler).
- License + reuse notes.
-->

Placeholder: repo URL + build instructions + reading guide.
