+++
title = "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum"
date = 2026-04-28
draft = false
tags = ["embedded", "control", "STM32", "BLDC", "stepper", "MATLAB", "digital twin", "education"]
summary = "A Simulink digital twin, an STM32 motor driver in two flavours (stepper and brushless), and a student competition, all built around a 25 cm pendulum that refuses to fall over."
+++

<!--
DRAFTING NOTES (for Sander, before publish):

- Photo/video markers below use this convention:
    📷  = still photo opportunity
    🎥  = short video / animated GIF opportunity
  Each marker has a short brief on what to capture and why.
- Hugo `figure` and `youtube` shortcodes are pre-typed but commented out.
  Drop the asset into `content/posts/bldc-pendulum/` (this is a page bundle,
  assets go next to index.md) and uncomment the line.
- MATLAB screenshots that also appear in the digtwin_labo README are
  duplicated by hand: copy the file into both repos when updating.
- Tone target: confident, concrete, lightly personal. Cut anything that
  sounds like marketing. Add lab anecdotes where I'm being too clean.
- Prose written for a technically curious general audience, not a control
  specialist, which keeps the post share-able beyond the field.
- One concrete number per paragraph, max. More than that and it reads like
  a datasheet.
-->

<!--
📷 HERO IMAGE (the post's lead visual).
What:   The pendulum upright (or close to it), ideally mid-recovery from a
        push, motor visible. Slightly off-axis composition; lab background
        is fine if uncluttered.
Why:    The reader sees the *result* in 200 ms before reading a word.
Spec:   Landscape 16:9, ≥ 1600 px wide. Compress to ~250 KB.
File:   content/posts/bldc-pendulum/hero.png
-->
{{< figure src="hero.png" alt="The inverted pendulum balancing upright on the BLDC drive on the open campus day KU Leuven @ Geel, 25 April 2026" >}}

A 25 cm aluminium rod pivots freely on a vertical motor shaft. Left alone, it falls over in roughly half a second. With the right control loop running, it stands upright indefinitely, and recovers from a push. This is the textbook "inverted pendulum" problem, and it has been a favourite of control engineering courses for half a century. What follows is what I built around it.

## Why a pendulum, of all things?

The inverted pendulum is the *Hello, World!* of nonlinear control. The upright position is an unstable equilibrium point, and with a well-designed controller, we can bring the system to that point and keep it there.  The hardware is simple,  fits on a desk, and the failure mode is dramatic but not destructive: the rod just falls over, but might swing around vigorously a few times as the controller tries to fight gravity. The inverted pendulum sytem strikes a balance where the theory is rich enough to teach, the hardware is cheap enough to scale, and the demo is satisfying enough to remember.

What's less common is building the whole stack around it: not just a controller that works, but a lab project that covers symbolic dynamics, physical modelling and simulation, state estimation, embedded firmware, and a way to grade students on how well they pulled it off.

## The setup: one kit, two rigs

The mechanics start from ST's [STEVAL-EDUKIT01](https://www.st.com/en/evaluation-tools/steval-edukit01.html), an off-the-shelf rotary inverted pendulum kit. The kit ships with a stepper motor and an L6474 driver, and that "stock" rig is the one most students get hands-on with first. I built a second variant that swaps the actuator for a brushless DC motor: a maxon ECX FLAT 42 M on ST's X-NUCLEO-IHM08M1 power board. Both versions share the same NUCLEO-F401RE controller, the same kit frame, and the same 2400 CPR optical encoder on the pendulum joint. The BLDC variant adds a second encoder (8192 CPR, on the motor shaft) for field-oriented commutation, which the stepper handles open-loop through microsteps.

The two rigs aren't redundant; they're a pedagogical pair. The stepper is the cheap, simple, "it just works" option that ships in the box. The BLDC is the higher-bandwidth, closer-to-a-real-servo option. A final perk of the BLDC setup is the use of slip ring contacts in the pendulum encoder wire, which allows the motor shaft to rotate freely and indefinitely. Above the firmware, the framework (Pi, Simulink model, grading) treats them identically.

|                  | Stepper rig                    | BLDC rig                                 |
|------------------|--------------------------------|------------------------------------------|
| Motor            | Bipolar stepper (kit)          | maxon ECX FLAT 42 M                      |
| Driver board     | X-NUCLEO-IHM01A1 (L6474)       | X-NUCLEO-IHM08M1 (FOC + shunt sensing)   |
| Control rate     | 1 kHz, acceleration command    | 16 kHz, torque command                   |
| Motor encoder    | none (open-loop microsteps)    | 8192 CPR                    |
| Pendulum encoder | 2400 CPR (shared)              | 2400 CPR (shared)                        |
| Firmware repo    | [stepper firmware →](https://github.com/sadegroo/NUCLEO-F401RE-invpend-SPIslave-stepper) | [BLDC firmware →](https://github.com/sadegroo/NUCLEO-F401RE-invpend-SPIslave-BLDC) |

That's it for hardware: a microcontroller, a driver board, a motor, an encoder or two, and a Raspberry Pi sitting next to it as the brains.

<!--
📷 HARDWARE WIDE SHOT
What:   The full rig on the bench. NUCLEO + IHM08M1 stack visible, motor
        + encoder mount, pendulum arm at rest (hanging down), Pi off to
        the side connected by SPI ribbon. Annotate with callouts in
        post-processing if you have time.
Why:    Anchors the prose. Readers need a mental model of the physical
        thing before the architecture diagram lands.
Spec:   Landscape, well-lit, ~1400 px wide.
File:   content/posts/bldc-pendulum/rig-overview.jpg
-->
{{< figure src="hardware_picture.png" alt="The assembled BLDC rig: NUCLEO controller and IHM08M1 driver stacked on the kit base, maxon brushless motor on top, aluminium pendulum arm hanging at rest" caption="The BLDC rig, assembled and at rest." >}}

## Brain and muscle

The architecture splits the work between two computers, on purpose.

**The STM32 is the muscle.** Its job is "make the motor do exactly what you ask for, and don't catch fire." On the BLDC rig that means ST's Motor Control SDK running field-oriented control at 16 kHz, with shunt-resistor current sensing on the IHM08M1 and PI loops on the q- and d-axis currents The Pi sends torque commands and receives encoder angles. On the stepper rig it's simpler: the L6474 handles current regulation in hardware, and the firmware exposes an acceleration command at 1 kHz instead. Either way, the firmware itself doesn't know there's a pendulum at all. Every cycle it bundles the latest pendulum encoder reading into an 8-byte SPI packet, ships it to the Pi, and waits for the next command back. Packets are CRC-protected; five corrupted in a row and the motor stops.

**The Raspberry Pi is the brain.** It runs the higher-level control: an LQR balance controller for keeping the rod upright, plus an energy-based swing-up controller that pumps energy into the system from the rod-down rest state until it's near vertical, where the LQR takes over. Crucially, the Pi runs this as Simulink-generated C code, deployed straight from MATLAB.

This split has a teaching payoff: students can prototype their own swing-up logic in Simulink and Stateflow, sketching state machines and trying different control strategies, without recompiling a single line of embedded firmware. THey can also change the model structure and parameters, if they decide it does not sufficiently represent reality.

<!--
🎥 ARCHITECTURE ANIMATION (optional but high-impact).
What:   Either an animated SVG or a short screen capture showing the
        signal flow: pendulum → encoder → STM32 → SPI → Pi → controller
        → torque command → SPI → STM32 → FOC → motor → pendulum.
        Loop the cycle, ~5 sec, no audio.
Why:    Architecture diagrams in textbooks are dead. A loop showing the
        1 kHz cycle in motion makes the closed-loop nature visceral.
Spec:   GIF or short MP4, ≤ 2 MB, looping.
File:   content/posts/bldc-pendulum/loop-architecture.gif
Alt:    Static SVG block diagram is a fine fallback. Keep it minimal.
-->
<!-- {{< figure src="loop-architecture.gif" alt="Animated control loop: pendulum sensors flow up to the Pi, torque commands flow back down to the motor" caption="One full control cycle, 1 kHz." >}} -->

## The digital twin

Here's the part I'm proudest of: the *same Simulink model* drives both the simulation and the real hardware.

The model contains the pendulum's nonlinear equations of motion (implicit in Simulink, but also derived symbolically with Euler-Lagrange for controller and observer design), an Unscented Kalman Filter that reconstructs the full 4-D state (two angles plus two angular velocities) from the encoder readings, and the LQR + swing-up controllers. The simulated plant itself is built in Simscape Multibody: joints, transforms, and rigid bodies that mirror the bench geometry.

{{< figure src="simulink_multibody_model.png" alt="Simscape Multibody block diagram of the pendulum: revolute joints, rigid transforms, and brick body blocks wired into state outputs" caption="The simulated plant in Simscape Multibody, mirroring the geometry, joints, and dynamics of the bench rig." >}}

A Simulink "variant subsystem" sits in the middle: when you simulate, it routes the actuator command into the Multibody plant; when you deploy, it routes it out through the SPI interface to the real STM32. Those are the two targets in the title: *simulation* and *real hardware*, from one model file. (The choice of stepper vs BLDC at the bottom of the stack is a second variant switch, layered underneath: torque-out for one rig, acceleration-out for the other.)

{{< figure src="simulink_variant_blocks.png" alt="The variant subsystem in Simulink: top branch labelled SIMULATION wraps a 3D pendulum render; bottom branch labelled PHYSICAL SYSTEM wraps the same render. Both branches have identical input and output ports" caption="The variant subsystem itself: top = simulated plant; bottom = SPI bridge to the real bench. Same ports, same controller upstream." >}}

In practice this means: tune the controller in simulation, hit one button, and the same controller is now running on the Pi commanding the real motor, with no hand-translation step in between.

<!--
📷 SIDE-BY-SIDE: SIM vs. HARDWARE
What:   A single plot with two traces overlaid: pendulum angle vs. time
        during a swing-up, one from the Simulink simulation, one from a
        real run captured via Simulink's Data Inspector. They should
        track each other within a few degrees.
Why:    This is the "the digital twin is real" payoff shot. One image
        proves the pitch.
Spec:   PNG, ~1200 × 700, light background, large legible axis labels.
        Title: "Simulation vs. Hardware: Swing-up trajectory".
File:   content/posts/bldc-pendulum/sim-vs-hardware.png
-->
<!-- {{< figure src="sim-vs-hardware.png" alt="Pendulum angle over time: simulation in blue, real hardware in orange, tracking within a few degrees" caption="Simulink against the bench. The gap between them is the homework." >}} -->

## A teaching lab built around it

The whole stack (firmware, model, controllers, scoring tool) is set up as a course lab. Student teams get the framework and a brief: design a controller that swings the pendulum from rest to upright as fast as possible, *and* whose simulation matches the real hardware as closely as possible.

Two metrics, deliberately in tension. You can win on speed by being aggressive with the swing-up energy law, but if your model isn't accurate enough to predict where the rod will end up, you'll overshoot the catch window for the LQR and lose. You can win points on accuracy by meticulously tuning the model parameters and structure to match reality, but then you have less time to make a fast controller. The good teams have to do both: identify the plant accurately *and* push the controller hard.

A grading script consumes each team's submission (`.mldatx` files captured from the Simulink Data Inspector during their best hardware run), measures swing-up time, computes the Symmetric Mean Absolute Percentage Error between sim and hardware, and ranks the teams.

{{< figure src="scoring_theta.png" alt="Team Theta scoring plot, stepper rig: hardware swings far wider than the simulation predicts" caption="Team Theta (stepper rig): 4.68 s to upright, SMAPE 119%." >}}

{{< figure src="scoring_pi.png" alt="Team Pi scoring plot, stepper rig: hardware and simulation traces track closely until the catch" caption="Team Pi (stepper rig): 5.74 s to upright, SMAPE 68%." >}}

Last cohort, two teams ran the stepper rig and tied at four points each by hitting opposite ends of the trade-off. Team Theta got the rod up a full second faster, but their digital twin spent the run drifting away from the real system (they did not spend as much time tuning the model parameters); a SMAPE near 120% means sim and hardware barely agreed on amplitude. Team Pi conceded that second and earned it back on accuracy: the two traces hug each other almost to the catch. Same total score, two opposite engineering bets.

It's the part of the project I think about most. The hardware and the maths are well understood; teaching is where the value gets made or lost. Wrapping a competition around the digital-twin workflow forces students to take the simulation seriously, because their grade depends on its accuracy, not just on whether their controller eventually works.

## What it looks like running

Numbers don't quite carry the *feel* of the rig in motion (the BLDC variant, in this clip): the way the rod jitters with micro-corrections at the apex, the soft hum of the motor commutating at 16 kHz, the moment a push test shoves the rod off vertical and the controller catches it before it falls. 

<!--
🎥 SWING-UP CLIP
What:   ~10 sec video. Pendulum at rest, hanging down. Hit the trigger
        button. Energy-based controller pumps it up over 2–3 seconds.
        LQR catches it at the top. Brief settle. Done.
        Front-on view, 1080p, 60fps if possible (slows down nicely).
        Audio of the motor humming is a bonus, since it sounds like the
        project feels.
Why:    This is the post's centrepiece. Anything else is supporting cast.
Spec:   ≤ 30 sec, ≤ 5 MB after compression. Self-host if practical;
        embedding from YouTube is fine.
Embed:  Self-hosted MP4: use raw HTML5 <video> tag.
        YouTube/Vimeo: use {{< youtube ID >}} or {{< vimeo ID >}}.
File:   content/posts/bldc-pendulum/swingup.mp4
-->
<figure>
  <video controls preload="metadata" width="100%" src="swingup.mp4"></video>
  <figcaption>Swing-up: rest to upright, then hold.</figcaption>
</figure>

The portability of the rig is illustrated by means of demonstrating it on my kitchen table. Please ignore the clutter.

<figure>
  <video controls preload="metadata" width="100%" src="stepper_swingup.mp4"></video>
  <figcaption>Same swing-up on the stepper rig. Uses empirical controller and takes longer</figcaption>
</figure>

How hard you can poke the rod before the LQR runs out of authority?
<!--
🎥 PUSH TEST CLIP
What:   Pendulum balanced upright. Hand comes in from off-frame, gives
        the rod a tap. Recovery. Then a harder tap. Then one shove too
        many. Controller can't catch it, rod swings down.
Why:    Robustness under disturbance is what separates a balancing demo
        from an actual controller. Showing where the controller fails
        is more honest (and more compelling) than only showing recovery.
File:   content/posts/bldc-pendulum/pushtest.mp4
-->
<figure>
  <video controls preload="metadata" width="100%" src="pushtest.mp4"></video>
  <figcaption>Push test: a finger tap, a harder one, and finally one shove too many.</figcaption>
</figure>

And here's the same loop in pure simulation. Swing-up trigger, Mechanics Explorer mirroring the model in 3D, two setpoint nudges, then the drop button:

<figure>
  <video controls preload="metadata" width="100%" src="simulink_simulation.mp4"></video>
  <figcaption>Pure-simulation run: same controller, same gains, no motor.</figcaption>
</figure>

If you want to try it yourself, the Simulink model runs end-to-end on the same controller, gains, and code path as on hardware. You won't feel the motor sing, but the trajectories will match.
You will need MATLAB, Simulink and some add-ons. It's free if you are a student at KU Leuven, but you may not bee so lucky.

## Try it / source

The repositories that make up the project are public:

- **Firmware (BLDC variant):** [`sadegroo/NUCLEO-F401RE-invpend-SPIslave-BLDC`](https://github.com/sadegroo/NUCLEO-F401RE-invpend-SPIslave-BLDC)
- **Firmware (stepper variant):** [`sadegroo/NUCLEO-F401RE-invpend-SPIslave-stepper`](https://github.com/sadegroo/NUCLEO-F401RE-invpend-SPIslave-stepper)
- **MATLAB framework + digital twin:** [`sadegroo/digtwin_labo`](https://github.com/sadegroo/digtwin_labo)

Build instructions, hardware bill of materials, and the lab worksheets live in each repo's README. Both firmware variants use a modern CMake build (no STM32CubeIDE required), and the MATLAB project opens with a single `digtwin_labo.prj` double-click.

<!--
TODO BEFORE PUBLISH:
1. Replace the date if you publish later than 2026-04-28.
2. Optional: add a footer link to the lab handout PDF if it's something
   you're happy to share publicly.
3. Fill the remaining placeholder visual (sim-vs-hardware overlay):
   uncomment the corresponding {{< figure >}} line when it lands.
-->
