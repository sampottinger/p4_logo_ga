/**
 * Tools for encoding colors into genes for a genetic algorithm.
 *
 * @license MIT
 * @author A Samuel Pottinger
 */


/**
 * Utility to convert between genes and imges.
 */
class ColorCoding {
  private final Map<Integer, Integer> colorToCodeMapping;
  private final Map<Integer, Integer> codeToColorMapping;
  private final int targetWidth;
  private final int targetHeight;
  private final int numCodes;
  
  /**
   * Create a coding that supports a target ("true") image being learned.
   * 
   * @param target The image that will be learned.
   */
  public ColorCoding(PImage target) {
    targetWidth = target.width;
    targetHeight = target.height;
    
    Set<Integer> uniqueColors = new HashSet<>();
    
    int numPixels = target.pixels.length;
    for (int i = 0; i < numPixels; i++) {
      uniqueColors.add(target.pixels[i]);
    }
    
    colorToCodeMapping = new HashMap<>();
    codeToColorMapping = new HashMap<>();
    int newNumCodes = 0;
    for (Integer uniqueColor : uniqueColors) {
      colorToCodeMapping.put(uniqueColor, newNumCodes);
      codeToColorMapping.put(newNumCodes, uniqueColor);
      newNumCodes++;
    }
    
    numCodes = newNumCodes;
  }
  
  /**
   * Convert a set of genes or codes to an image.
   *
   * @param codes The genes to be converted to an image.
   * @return The image encoded by the given genes.
   */
  public PImage decodeImage(List<Integer> codes) {
    PImage newImage = new PImage(targetWidth, targetHeight);
    
    int numCodes = codes.size();
    for (int i = 0; i < numCodes; i++) {
      int code = codes.get(i);
      int pixel = codeToColorMapping.get(code);
      newImage.pixels[i] = pixel;
    }
    
    return newImage;
  }
  
  /**
   * Convert an image to a set of genes or codes.
   *
   * @param image The image to be encoded into genes.
   * @return The given image as a set of genes.
   */
  public List<Integer> encodeImage(PImage image) {
    List<Integer> codes = new ArrayList<>();
    
    int numPixels = image.pixels.length;
    for (int i = 0; i < numPixels; i++) {
      int pixel = image.pixels[i];
      int code = colorToCodeMapping.get(pixel);
      codes.add(code);
    }
    
    return codes;
  }
  
  /**
   * Get the number of codes used.
   *
   * @return Number of colors in logo.
   */
  public int getNumCodes() {
    return numCodes;
  }
  
}
