/**
 * Sketch which learns the Processing 4 icon through genetic algorithm.
 *
 * Given 4 times 10 raised to the 1348th power unique pictures that could be
 * drawn in this size, a genetic algorithm reproducing and mutating 100
 * individuals starts from 100 random images to learn what the new Processing 4
 * logo is given only the percent of pixels correct.
 * 
 * Specifically, each individual is mutated at each generation and the chance of
 * reproduction is proportional to how close the individual is to the actual new
 * logo.
 *
 * @license MIT License
 * @author A Samuel Pottinger
 */

import java.util.*;

PImage targetImage;
Candidate targetCandidate;
int numPixels;
CandidatePool candidates;
ColorCoding coding;

int mutateRate = 5;
float lastGrade = 0;
int drawCount = 0;
int saveCount = 0;


/**
 * Load target image and create initial candidate pool.
 */
void setup() {
  size(64, 70);
  
  prepareTargetImage();
  
  candidates = new CandidatePool();
  
  frameRate(8);
}


/**
 * Run new generation(s) and draw best candidate.
 */
void draw() {
  // Draw best candidate.
  Candidate bestCandidate = candidates.getBest();
  bestCandidate.draw();
  
  // Determine if mutation should slow down.
  float newGrade = bestCandidate.grade();
  if (newGrade == lastGrade) {
    mutateRate = min(mutateRate + 1, MAX_MUTATE);
  }
  lastGrade = newGrade;
  
  // Save if appropriate
  boolean isSaveDraw = drawCount % DRAW_PER_SAVE == 0;
  boolean stillSearching = newGrade < STOP_GRADE;
  if (SAVE_FRAMES && isSaveDraw && stillSearching) {
    String destination = String.format(
      "output/%s.png",
      nf(saveCount, 4)
    );
    save(destination);
    saveCount++;
  }
  
  // Run generations
  for (int i = 0; i < NUM_GENERATIONS_PER_DRAW; i++) {
    candidates = new CandidatePool(candidates);
  }
  
  // Increment draw count
  drawCount++;
}


/**
 * Load target image and initialize target candidate / coding.
 */
void prepareTargetImage() {
  // Load image
  targetImage = loadImage("target_simple.png");
  targetImage.loadPixels();
  numPixels = targetImage.pixels.length;
  
  // Create coding
  coding = new ColorCoding(targetImage);
  
  // Create target candidate for comparison
  targetCandidate = new Candidate(
    coding.encodeImage(targetImage)
  );
}
