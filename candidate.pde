/**
 * Logic for running genetic algorithm on individuals ("candidate" images).
 *
 * @license MIT
 * @author A Samuel Pottinger
 */


/**
 * Single generation of a set of candidates.
 *
 * Single generation of a set of candidates that can reproduce and mutate to
 * create the next generation.
 */
class CandidatePool {
  
  private final List<Candidate> candidates;
  private final float totalGrade;
  
  /**
   * Create a pool of random candidates.
   */
  public CandidatePool() {
    candidates = new ArrayList<Candidate>();
    
    for (int i = 0; i < NUM_START; i++) {
      addRandom(); 
    }
    
    sort();
    totalGrade = calcTotalGrade(candidates);
  }
  
  /**
   * Create a new generation from a previous generation.
   *
   * @param prior THe prior generation from which to create a new generation from
   *   mutation, reproduction, etc.
   */
  public CandidatePool(CandidatePool prior) {
    candidates = new ArrayList<>();
  
    // Retain the top
    for (int i = 0; i < NUM_TOP_RETAIN; i++) {
      addPrior(prior.get(i));
    }
    
    // Reproduce on score
    for (int i = 0; i < NUM_REPRODUCE; i++) {
      addReproduce(prior);
    }
    
    // Mutate
    for (int i = 0; i < NUM_MUTATE; i++) {
      addMutate(prior);
    }
    
    // Random
    for (int i = 0; i < NUM_REPRODUCE; i++) {
      addRandom();
    }
    
    sort();
    totalGrade = calcTotalGrade(candidates);
  }
  
  /**
   * Get the best candidate from this generation.
   *
   * @return The best candidate in this generation.
   */
  public Candidate getBest() {
    return candidates.get(0);
  }
  
  /**
   * Get the ith candidate from this generation.
   *
   * @param i The rank of the candidate to return. Passing zero will get the best
   *   candidate, one the second best, and so on.
   * @return The candidate at the given rank (ties broken). 
   */
  public Candidate get(int i) {
    return candidates.get(i);
  }
  
  /**
   * Run performance proportional reproduction.
   *
   * @return The newly generated candidate.
   */
  public Candidate reproduce() {
    int index1 = (int) random(0, NUM_TOP_RETAIN);
    Candidate candidate1 = get(index1);
    Candidate candidate2 = selectRandomCandidateProportionally();
    return candidate1.reproduce(candidate2);
  }
  
  /**
   * Get the overall score for this generation.
   *
   * @return Sum of grades for all candidates in generation.
   */
  public float getTotalGrade() {
    return totalGrade;
  }
  
  /**
   * Sort all candidates in descending order by grade.
   */
  private void sort() {
    candidates.sort((a, b) -> b.compareTo(a));
  }
  
  /**
   * Add in a candiate from a prior generation as is.
   *
   * @param prior The candidate from the prior generation to include.
   */
  private void addPrior(Candidate prior) {
    candidates.add(prior);
  }
 
  /**
   * Get a random top candidate from the prior generation and mutate.
   *
   * Get a random top candidate from the prior generation and mutate, putting
   * them into this generation.
   *
   * @param priorPool The prior generation.
   */
  private void addMutate(CandidatePool priorPool) {
    int mutationIndex = (int) random(0, MUTATION_MAX_INDEX);
    Candidate priorCandidate = priorPool.get(mutationIndex);
    candidates.add(priorCandidate.mutate());
  }
  
  /**
   * Ask the prior generation to reproduce to make a new candidate.
   *
   * Ask the prior generation to reproduce to make a new candidate for this
   * generation.
   *
   * @param priorPool The prior generation.
   */
  private void addReproduce(CandidatePool priorPool) {
    if (priorPool.getTotalGrade() > 0) {
      candidates.add(priorPool.reproduce());
    } else {
      addRandom();
    }
  }
  
  /**
   * Add a new random candidate to this generation.
   */
  private void addRandom() {
    candidates.add(new Candidate());
  }
  
  /**
   * Calculate the total score for a set of candidates.
   *
   * @param target The set of candidates to grade.
   * @retun Sum of scores for the given set of candidates.
   */
  private float calcTotalGrade(List<Candidate> target) {
    return target.stream()
      .map((x) -> x.grade())
      .reduce((a, b) -> a + b)
      .get();
  }
  
  /**
   * Get a random candidate.
   *
   * @return A randomly selected candidate where probability for an individual
   *   is propostional to grade of that candidate.
   */
  private Candidate selectRandomCandidateProportionally() {
    float randomVal = random(totalGrade);
    
    float runningTotal = 0;
    int i = 0;
    int numCandidates = candidates.size();
    Candidate retCandidate = null;
    
    while (i < numCandidates && runningTotal < randomVal) {
      retCandidate = candidates.get(i);
      runningTotal += retCandidate.grade();
      i++;
    }
    
    return retCandidate;
  }

}


/**
 * Candidate representing a possible logo that can reproduce and mutate.
 */
class Candidate implements Comparable<Candidate> {
  private final List<Integer> candidateCodes;
  
  /**
   * Create a new candidate as a random image.
   */
  public Candidate() {
    candidateCodes = new ArrayList<>();
    
    for (int i = 0; i < numPixels; i++) {
      candidateCodes.add(getRandomColor());
    }
  }

  /**
   * Create a new candidate with the given codes.
   *
   * @param newCodes The codes representing the colors or pixels of the logo
   *   encoded using the active coding. These are also the "genes" of the
   *   candidate.
   */
  public Candidate(List<Integer> newCodes) {
    candidateCodes = newCodes;
  }
  
  /**
   * Get the codes or genes of this candidate.
   *
   * @return The codes representing the colors or pixels of the logo encoded
   *   using the active coding. These are also the "genes" of the candidate.
   */
  public List<Integer> getCodes() {
    return candidateCodes;
  }
  
  /**
   * Decode and draw this candidate.
   */
  public void draw() {
    PImage candidateImage = coding.decodeImage(getCodes());
    image(candidateImage, 0, 0);
  }
  
  /**
   * Get a score for how accurate or "fit" this candidate is.
   *
   * @return The score for this candidate (percent of pixels correct).
   */
  public float grade() {
    float numCorrect = 0;
    
    List<Integer> thisCodes = getCodes();
    List<Integer> targetCodes = targetCandidate.getCodes();
    
    for (int i = 0; i < numPixels; i++) {
      numCorrect += targetCodes.get(i) == thisCodes.get(i) ? 1 : 0;
    }
    
    return numCorrect / numPixels;
  }
  
  /**
   * Reproduce with another candidate.
   *
   * @param other The candidate with which this candidate should reproduce.
   * @return The new candidate.
   */
  public Candidate reproduce(Candidate other) {
    List<Integer> newCodes = new ArrayList<>();
    List<Integer> thisCodes = getCodes();
    List<Integer> otherCodes = other.getCodes();
    
    for (int i = 0; i < numPixels; i++) {
      int newValue;
      
      if (random(1) < 0.5) {
        newValue = thisCodes.get(i);
      } else {
        newValue = otherCodes.get(i);
      }
      
      newCodes.add(newValue);
    }
    
    return new Candidate(newCodes);
  }
  
  /**
   * Compare to another candidate.
   *
   * @param other The candidate against which this candidate should be compared.
   * @return Positive integer if this candidate has a higher grade, 0 if the
   *   same, and negative if less.
   */
  public int compareTo(Candidate other) {
    Float thisScore = grade();
    Float otherScore = other.grade();
    return thisScore.compareTo(otherScore);
  }
  
  /**
   * Copy and randomly mutate the genes of this candidate.
   *
   * @return This candidate after mutation.
   */
  public Candidate mutate() {
    List<Integer> newCodes = new ArrayList<>();
    
    for (int code : candidateCodes) {
      int newCode;
      if ((int) random(0, mutateRate) == 0) {
        newCode = getRandomColor();
      } else {
        newCode = code;
      }
      
      newCodes.add(newCode);
    }
    
    return new Candidate(newCodes);
  }
  
  /**
   * Get a random color that appears in the logo.
   *
   * @return Integer corresponding to a color in the active encoding.
   */
  private int getRandomColor() {
    return (int) random(0, coding.getNumCodes());
  }

}
