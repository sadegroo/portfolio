+++
title = "One Simulink Model, Two Targets: A Digital Twin for an Inverted Pendulum"
date = 2026-04-28
draft = false
tags = ["embedded", "control", "STM32", "BLDC", "MATLAB", "digital twin", "education"]
summary = "A field-oriented BLDC drive, a Simulink digital twin, and a student competition, all built around a 25 cm pendulum that refuses to fall over."
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
- Shared MATLAB screenshots (also used in the digtwin_labo README) come in
  via `bash scripts/sync-from-digtwin-labo.sh`. They land here with a
  `shared-` prefix; do not edit them in place — edit upstream and re-sync.
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
{{< figure src="hero.png" alt="The inverted pendulum balancing upright on the BLDC drive" >}}

A 25 cm aluminium rod pivots freely on a brushless motor's shaft. Left alone, it falls over in roughly half a second. With the right control loop running, it stands upright indefinitely, and recovers from a push, a poke, or a deliberate flick. This is the textbook "inverted pendulum" problem, and it has been a favourite of control engineering courses for half a century. What follows is what I built around it.

## Why a pendulum, of all things?

The inverted pendulum is the *Hello, World!* of nonlinear control. It's unstable in open loop, easy to model, hard to stabilise without using everything you know. Sensors are cheap, hardware fits on a desk, and the failure mode is dramatic but not destructive: the rod just falls over. It hits the sweet spot where the theory is rich enough to teach, the hardware is cheap enough to scale, and the demo is satisfying enough to remember.

What's less common is building the whole stack around it: not just a controller that works, but a teaching framework that covers symbolic dynamics, simulation, state estimation, embedded firmware, and a way to grade students on how well they pulled it off. That's what this project is.

## The setup, in two minutes

The mechanical part is ST's [STEVAL-EDUKIT01](https://www.st.com/en/evaluation-tools/steval-edukit01.html), an off-the-shelf rotary inverted pendulum kit, originally designed around a stepper motor. I swapped the actuator for a brushless DC motor (a maxon ECX FLAT 42 M, 24 V, 8 pole pairs) driven by ST's X-NUCLEO-IHM08M1 power board on a NUCLEO-F401RE.

Two encoders close the loop:
- a **2048 CPR differential encoder** on the motor shaft, for commutation,
- a **2400 CPR optical encoder** on the pendulum joint, for "where is the rod right now."

That's it for hardware: a microcontroller, a motor driver, a motor, two encoders, and a Raspberry Pi sitting next to it as the brains.

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
<!-- {{< figure src="rig-overview.jpg" alt="The bench setup: NUCLEO board, motor driver, motor with pendulum arm, and Raspberry Pi" caption="The whole rig fits on a desk." >}} -->

## Brain and muscle

The architecture splits the work between two computers, on purpose.

**The STM32 is the muscle.** It runs ST's Motor Control SDK at 16 kHz: field-oriented control on the brushless motor, current sensing through the IHM08M1's shunt resistors, PI loops on the q- and d-axis currents. At this layer the firmware doesn't know there's a pendulum at all. Its job is "make the motor produce exactly the torque you ask for, and don't catch fire." Every millisecond, it bundles the latest pendulum encoder reading into an 8-byte SPI packet, ships it to the Pi, and waits for a torque command back. Packets are CRC-protected; if five in a row arrive corrupted, the motor stops.

**The Raspberry Pi is the brain.** It runs the higher-level control: an LQR balance controller for keeping the rod upright, plus an energy-based swing-up controller that pumps energy into the system from the rod-down rest state until it's near vertical, where the LQR takes over. Crucially, the Pi runs this as Simulink-generated C code, deployed straight from MATLAB.

This split has a teaching payoff: students can prototype their own swing-up logic in Simulink and Stateflow, sketching state machines and trying different energy-pumping strategies, without recompiling a single line of embedded firmware. They aren't in an advanced control class. The goal isn't an elegant LQR derivation, it's an empirical recipe that gets the pendulum upright. The firmware stays a stable, debugged platform underneath, and the experimentation happens where it's comfortable.

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

The model contains the pendulum's nonlinear equations of motion (derived symbolically with Euler-Lagrange, cached and reused), an Unscented Kalman Filter that reconstructs the full 4-D state (two angles plus two angular velocities) from just the two encoder readings, and the LQR + swing-up controllers. A Simulink "variant subsystem" sits in the middle: when you simulate, it routes torque commands into the nonlinear plant block; when you deploy, it routes them out through the SPI interface to the real STM32.

In practice this means: tune the controller in simulation, hit one button, and the same controller is now running on the Pi commanding the real motor. No translation step. No "well it worked in MATLAB but…" The same blocks, the same gains, the same code path.

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

Two metrics, deliberately in tension. You can win on speed by being aggressive with the swing-up energy law, but if your model isn't accurate enough to predict where the rod will end up, you'll overshoot the catch window for the LQR and lose. You can win on fidelity by sandbagging, simulating a slow, conservative trajectory that's easy to match, but then you lose on time. The good teams have to do both: identify the plant accurately *and* push the controller hard.

A grading script consumes each team's submission (`.mldatx` files captured from the Simulink Data Inspector during their best hardware run), measures swing-up time, computes the Symmetric Mean Absolute Percentage Error between sim and hardware, and ranks the teams.

<!--
📷 COMPETITION RESULTS / LEADERBOARD
What:   Either a screenshot of the rendered competition_results .xlsx (or a
        MATLAB bar chart of the same data), showing Team Lambda's BLDC
        result alongside the four stepper teams' times. Anonymise team
        member names if needed.
Why:    Concrete proof of the pedagogical loop closing: "the framework
        was used, and here's what came out."
Spec:   Clean screenshot, light background.
File:   content/posts/bldc-pendulum/competition-leaderboard.png
-->
<!-- {{< figure src="competition-leaderboard.png" alt="Competition leaderboard ranking student teams by swing-up time and simulation fidelity" caption="Last cohort's results." >}} -->

It's the part of the project I think about most. The hardware and the maths are well understood; teaching is where the value gets made or lost. Wrapping a competition around the digital-twin workflow forces students to take the simulation seriously, because their grade depends on its accuracy, not just on whether their controller eventually works.

## What it looks like running

Numbers don't quite carry the *feel* of the rig in motion: the way the rod jitters with micro-corrections at the apex, the soft hum of the motor commutating at 16 kHz, the moment a push-test pendulum shoves over and the controller catches it just before commitment.

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
<video controls preload="metadata" width="100%" src="swingup.mp4"></video>

<!--
🎥 PUSH RECOVERY CLIP (secondary, if you have time).
What:   ~5 sec. Pendulum balanced upright. A finger comes in from
        off-frame, gives the rod a sharp tap. Rod jumps, motor whirrs,
        rod settles back to vertical. Slo-mo (120 fps → 30 fps playback)
        is gorgeous here.
Why:    Robustness under disturbance is what separates a balancing demo
        from an actual controller. Showing it makes the point.
Spec:   Slo-mo MP4, ≤ 5 sec at playback speed.
File:   content/posts/bldc-pendulum/push-recovery.mp4
-->
<!-- <video controls width="100%" src="push-recovery.mp4"></video> -->

If you want to play with it without building hardware, the Simulink model runs end-to-end in pure simulation; it's the variant-subsystem trick described above, in reverse. You won't feel the motor sing, but you'll see the same trajectories.

## Try it / source

The two repositories that make up the project are public:

- **Firmware (STM32):** [`sadegroo/invpend_BLDC`](https://github.com/sadegroo/invpend_BLDC) <!-- TODO: confirm repo URL/visibility before publishing -->
- **MATLAB framework + digital twin:** [`sadegroo/digtwin_labo`](https://github.com/sadegroo/digtwin_labo) <!-- TODO: confirm repo URL/visibility before publishing -->

Build instructions, hardware bill of materials, and the lab worksheets live in each repo's README. The firmware uses a modern CMake build (no STM32CubeIDE required) and the MATLAB project opens with a single `digtwin_labo.prj` double-click.

<!--
TODO BEFORE PUBLISH:
1. Confirm both GitHub repo URLs above (or unpublish if either is private).
2. Replace the date if you publish later than 2026-04-28.
3. Optional: add a footer link to the lab handout PDF if it's something
   you're happy to share publicly.
4. Fill the four remaining placeholder visuals (rig wide shot,
   sim-vs-hardware overlay, leaderboard, push-recovery clip) — uncomment
   the corresponding {{< figure >}} or <video> line as each lands.
-->
