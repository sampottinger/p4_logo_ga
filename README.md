P4 Logo GA
================================================================================
Genetic algorithm which learns the Processing 4 icon.

<br>

Purpose
--------------------------------------------------------------------------------
Given 4 times 10 raised to the 1348th power unique pictures that could be drawn in this size, a genetic algorithm reproducing and mutating 100 individuals starts from 100 random images to learn what the new Processing 4 logo is given only the percent of pixels correct. Specifically, each individual is mutated at each generation and the chance of reproduction is proportional to how close the individual is to the actual new logo.

<br>

Local Environment Setup
--------------------------------------------------------------------------------
Requires the Processing 4 beta at https://processing.org/download.

<br>

Execution
--------------------------------------------------------------------------------
Simply load and execute the sketch. Behavior can be configured through `const.pde` with the following options:

 - DRAW_PER_SAVE: Number of draws shown in the UI prior to saving a frame for output video if enabled.
 - MAX_MUTATE: The maximum mutation probability (1 / MAX_MUTATE).
 - MUTATION_MAX_INDEX: The maximum index of a candidate eligible for mutation.
 - NUM_GENERATIONS_PER_DRAW: Number of generations to compute before showing the user a draw.
 - NUM_MUTATE: Number of candidates to make through mutation in each generation.
 - NUM_RANDOM: Number of candidates to make through random genetics in each generation.
 - NUM_REPRODUCE: Number of candidates to make through reproduction in each generation.
 - NUM_START: Number of candidates in the first generation.
 - NUM_TOP_RETAIN: Number of top candidates to retain unchanged between generation.
 - SAVE_FRAMES: Flag indicating if frames should be saved for animation / video.
 - STOP_GRADE: The score at which frames should stop being written to disk.

One will also need to provide the Processing 4 icon (or similar) in the data folder as `target_simple.png` and may need to change the sketch size in `p4_logo_ga.pde`.

<br>

License and Open Source
--------------------------------------------------------------------------------
Released under the MIT license (see LICENSE.md). No third party libraries beyond Processing standard runtime.
