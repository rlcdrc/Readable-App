import 'package:flutter/material.dart';
import 'main.dart'; 
import 'lesson_page.dart';

class QuizPage extends StatefulWidget {
  final String subject;
  final String quizId;
  final VoidCallback onFinish;

  const QuizPage({
    super.key, 
    required this.quizId, 
    required this.onFinish,
    required this.subject,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0; // Track which question we are on
  int correctAnswersCount = 0; // Track correct answers for accuracy
  int? selectedIndex;

  // 3. UPDATED DATA MAPPING (Added 'correctIndex')
final Map<String, List<Map<String, dynamic>>> quizData = {
// --- READING COMPREHENSION CATEGORY ---

// 1. THE BIG PICTURE (Main Idea & Themes)
"main_idea": [
    {"question": "In Leo's story, what was the 'Golden Key' representing?", "options": ["The Title", "The Main Idea", "The Character's name", "A real gold key"], "correctIndex": 1, "category": "MAIN IDEA"},
    {"question": "What is the primary purpose of a 'Main Idea'?", "options": ["To confuse the reader", "To tell the whole story", "To summarize the core message", "To name characters"], "correctIndex": 2, "category": "MAIN IDEA"},
    {"question": "Where is the main idea often found?", "options": ["Only at the end", "In the first few sentences", "In the glossary", "Nowhere"], "correctIndex": 1, "category": "MAIN IDEA"},
    {"question": "A good summary must always include:", "options": ["The main idea", "Every single detail", "The author's bio", "A drawing"], "correctIndex": 0, "category": "MAIN IDEA"},
    {"question": "If a story is about a cat finding a home, the main idea is:", "options": ["Dogs are better", "A cat's journey to belonging", "How to buy pet food", "The weather"], "correctIndex": 1, "category": "MAIN IDEA"},
  ],

  // 2. STORY STRUCTURE (Beginning/Middle/End)
  "structure": [
    {"question": "When Leo was climbing the 'Mountain' of his journey, which part was he in?", "options": ["The Beginning", "The Middle", "The End", "The Preface"], "correctIndex": 1, "category": "STRUCTURE"},
    {"question": "The part of the story where characters and the setting are introduced is the:", "options": ["Middle", "Resolution", "Beginning", "Climax"], "correctIndex": 2, "category": "STRUCTURE"},
    {"question": "What usually happens in the 'Middle' of a story?", "options": ["The story ends", "The main character faces a big challenge", "The credits roll", "Nothing happens"], "correctIndex": 1, "category": "STRUCTURE"},
    {"question": "The 'End' of a story is where:", "options": ["The problem is solved", "The story starts", "New characters appear", "The book is lost"], "correctIndex": 0, "category": "STRUCTURE"},
    {"question": "Why is a story structure like a map?", "options": ["It has colors", "It shows the path from start to finish", "It is made of paper", "It tells you the temperature"], "correctIndex": 1, "category": "STRUCTURE"},
  ],

  // 3. INFERENCES (Reading Between the Lines)
  "inference": [
    {"question": "Leo saw wet footprints and guessed it was raining. What skill did he use?", "options": ["Reading aloud", "Vocabulary", "Inference", "Summarizing"], "correctIndex": 2, "category": "INFERENCE"},
    {"question": "An inference is a 'smart guess' based on:", "options": ["Random luck", "Clues and what you already know", "The length of the book", "The author's name"], "correctIndex": 1, "category": "INFERENCE"},
    {"question": "If Leo sees a character shivering and wearing a heavy coat, he can infer:", "options": ["It is very hot", "The character is cold", "The character is happy", "It is lunchtime"], "correctIndex": 1, "category": "INFERENCE"},
    {"question": "Inferences help a reader find:", "options": ["Hidden meanings not directly stated", "Spelling errors", "The page numbers", "The price of the book"], "correctIndex": 0, "category": "INFERENCE"},
    {"question": "Which is an inference? 'The sky is dark, so...'", "options": ["I am eating", "It might rain", "The sky is blue", "I am running"], "correctIndex": 1, "category": "INFERENCE"},
  ],

  // 4. VOCABULARY (Context Clues)
  "vocab": [
    {"question": "How did Leo figure out what 'Luminous' meant?", "options": ["He asked a robot", "He used context clues from the sign", "He guessed randomly", "He looked at the floor"], "correctIndex": 1, "category": "VOCABULARY"},
    {"question": "What are 'Context Clues'?", "options": ["The page numbers", "Words around an unknown word that help define it", "The pictures in the book", "The title of the chapter"], "correctIndex": 1, "category": "VOCABULARY"},
    {"question": "If a sign says 'The frigid air made him freeze,' what does 'frigid' mean?", "options": ["Very hot", "Very cold", "Smelly", "Bright"], "correctIndex": 1, "category": "VOCABULARY"},
    {"question": "Using context clues is like being a:", "options": ["Cook", "Detective", "Pilot", "Singer"], "correctIndex": 1, "category": "VOCABULARY"},
    {"question": "Why are context clues useful?", "options": ["They help you read faster", "They help you understand new words without a dictionary", "They make the book colorful", "They help you find the exit"], "correctIndex": 1, "category": "VOCABULARY"},
  ],

  // 5. CHARACTERS (Traits & Motives)
  "chars": [
    {"question": "If a robot shares its oil because it wants to help, 'helping' is its...?", "options": ["Trait", "Motive", "Name", "Height"], "correctIndex": 1, "category": "CHARACTERS"},
    {"question": "A character 'Trait' describes:", "options": ["What a character looks like only", "Who the character is on the inside", "Where the character lives", "The character's favorite food"], "correctIndex": 1, "category": "CHARACTERS"},
    {"question": "A character 'Motive' explains:", "options": ["How fast they run", "Why a character acts the way they do", "Their hair color", "Their name"], "correctIndex": 1, "category": "CHARACTERS"},
    {"question": "If Leo returns a lost book because he is honest, 'honest' is a:", "options": ["Motive", "Trait", "Setting", "Title"], "correctIndex": 1, "category": "CHARACTERS"},
    {"question": "Understanding motives helps readers predict:", "options": ["The weather", "What a character might do next", "The number of pages", "The author's age"], "correctIndex": 1, "category": "CHARACTERS"},
  ],

  // 6. POINT OF VIEW (First vs Third)
  "pov": [
    {"question": "When Leo wrote 'I feel brave' in his diary, what POV was he using?", "options": ["2nd Person", "3rd Person", "1st Person", "None"], "correctIndex": 2, "category": "POV"},
    {"question": "In 1st Person POV, the narrator is:", "options": ["A character inside the story", "Someone watching from outside", "The reader", "The book itself"], "correctIndex": 0, "category": "POV"},
    {"question": "Which keyword is a sign of 1st Person POV?", "options": ["He", "They", "I", "It"], "correctIndex": 2, "category": "POV"},
    {"question": "In 3rd Person POV, the narrator uses words like:", "options": ["I and Me", "He, She, and They", "You", "Mine"], "correctIndex": 1, "category": "POV"},
    {"question": "Who is telling the story in 3rd Person POV?", "options": ["The main character", "An outside observer", "The villain", "The robot"], "correctIndex": 1, "category": "POV"},
  ],

  // 7. CAUSE & EFFECT (Logic)
  "cause_effect": [
    {"question": "Leo tripped over a wire (Cause). What was the Effect?", "options": ["He found a book", "The lights went out", "He met a robot", "He ate lunch"], "correctIndex": 1, "category": "LOGIC"},
    {"question": "The 'Cause' is the event that:", "options": ["Happens last", "Makes something else happen", "Is the most boring", "Has no result"], "correctIndex": 1, "category": "LOGIC"},
    {"question": "The 'Effect' is the event that:", "options": ["Happens first", "Is the result of a cause", "Is always a secret", "Never changes"], "correctIndex": 1, "category": "LOGIC"},
    {"question": "Which word often signals a cause/effect relationship?", "options": ["Blue", "Because", "Slowly", "Sometimes"], "correctIndex": 1, "category": "LOGIC"},
    {"question": "If Leo studies hard and gets an A, the 'Cause' is:", "options": ["Getting an A", "Studying hard", "The teacher", "The desk"], "correctIndex": 1, "category": "LOGIC"},
  ],

  // 8. FACT VS OPINION
  "fact_opinion": [
    {"question": "Which of these from Leo's world is a FACT?", "options": ["The library is scary", "The library is 100 years old", "Leo is a cool kid", "Robots are better than humans"], "correctIndex": 1, "category": "FACTS"},
    {"question": "A 'Fact' is something that:", "options": ["Someone feels", "Can be proven true", "Is always funny", "Changes every day"], "correctIndex": 1, "category": "FACTS"},
    {"question": "An 'Opinion' is something that:", "options": ["Is a proven truth", "Shows how someone feels or thinks", "Is found in a math book", "Never changes"], "correctIndex": 1, "category": "FACTS"},
    {"question": "Which of these is an OPINION?", "options": ["The sun is a star", "Reading is the best hobby", "Water freezes at 0°C", "Leo has two hands"], "correctIndex": 1, "category": "FACTS"},
    {"question": "Can an opinion be proven true for everyone?", "options": ["Yes", "No", "Only on Tuesdays", "If it's in a book"], "correctIndex": 1, "category": "FACTS"},
  ],

  // 9. SUMMARIZING (Short Versions)
  "summary": [
    {"question": "Why did Leo give his friends a summary instead of the full story?", "options": ["He forgot", "To give the short version of main parts", "To lie", "He was tired"], "correctIndex": 1, "category": "SUMMARY"},
    {"question": "A summary should include:", "options": ["Every single detail", "Only the main points", "Only the ending", "The author's middle name"], "correctIndex": 1, "category": "SUMMARY"},
    {"question": "When you summarize, you make the story:", "options": ["Longer", "Shorter", "Confusing", "Invisible"], "correctIndex": 1, "category": "SUMMARY"},
    {"question": "A good summary answers which questions?", "options": ["Who, What, Where, When, Why", "How many words are there", "What color is the cover", "Who printed the book"], "correctIndex": 0, "category": "SUMMARY"},
    {"question": "Summarizing helps you:", "options": ["Forget the story", "Check your understanding", "Count the pages", "Buy more books"], "correctIndex": 1, "category": "SUMMARY"},
  ],

  // 10. THEMES (The Big Lesson)
  "theme": [
    {"question": "What was the 'Theme' of Leo's adventure?", "options": ["Reading is boring", "Courage helps us overcome fear", "Always carry an umbrella", "Robots need oil"], "correctIndex": 1, "category": "THEME"},
    {"question": "A story's 'Theme' is:", "options": ["The name of the character", "The big lesson or message", "The location", "The price"], "correctIndex": 1, "category": "THEME"},
    {"question": "Which of these is a common theme?", "options": ["Apple pie", "Friendship is valuable", "The year 2024", "Blue shoes"], "correctIndex": 1, "category": "THEME"},
    {"question": "Does the author usually tell you the theme directly?", "options": ["Yes, on the first page", "No, you usually have to figure it out", "Yes, in the credits", "Themes don't exist"], "correctIndex": 1, "category": "THEME"},
    {"question": "To find the theme, look at:", "options": ["The character's shoes", "What the characters learned", "The font size", "The table of contents"], "correctIndex": 1, "category": "THEME"},
  ],

  // --- SCIENCE CATEGORY ---

  // 1. THE SOLAR SYSTEM (Celestial Mechanics)
"space": [
    {"question": "What percentage of the Solar System's total mass is contained within the Sun?", "options": ["50.5%", "75.2%", "99.8%", "88.9%"], "correctIndex": 2, "category": "ASTRONOMY"},
    {"question": "What triggered the formation of the Solar System 4.6 billion years ago?", "options": ["A volcanic eruption", "The gravitational collapse of a molecular cloud", "A collision between two galaxies", "A massive solar flare"], "correctIndex": 1, "category": "ASTRONOMY"},
    {"question": "Which of these is a 'Terrestrial' planet with a solid silicate surface?", "options": ["Jupiter", "Saturn", "Venus", "Neptune"], "correctIndex": 2, "category": "ASTRONOMY"},
    {"question": "What separates the inner Terrestrial planets from the outer Jovian planets?", "options": ["The Kuiper Belt", "The Oort Cloud", "The Asteroid Belt", "The Event Horizon"], "correctIndex": 2, "category": "ASTRONOMY"},
    {"question": "Where are icy bodies and plutoids primarily found in our system?", "options": ["The Sun's core", "The Kuiper Belt", "The Mercury crust", "The Venusian atmosphere"], "correctIndex": 1, "category": "ASTRONOMY"},
  ],

  // 2. PHOTOSYNTHESIS (Bioenergetics)
  "plants": [
    {"question": "During photosynthesis, what is the specific role of sunlight in the chloroplasts?", "options": ["To create carbon dioxide", "To split water molecules", "To freeze the glucose", "To absorb oxygen"], "correctIndex": 1, "category": "BIOENERGETICS"},
    {"question": "Which pigment is responsible for absorbing blue and red light waves?", "options": ["Hemoglobin", "Chlorophyll", "Melanin", "Carotene"], "correctIndex": 1, "category": "BIOENERGETICS"},
    {"question": "What is the primary high-energy sugar produced during the Calvin Cycle?", "options": ["Lactose", "Fructose", "Glucose", "Sucrose"], "correctIndex": 2, "category": "BIOENERGETICS"},
    {"question": "What is released as a byproduct when water molecules are split?", "options": ["Hydrogen gas", "Oxygen", "Nitrogen", "Methane"], "correctIndex": 1, "category": "BIOENERGETICS"},
    {"question": "Photosynthesis converts light energy into what other form of energy?", "options": ["Kinetic energy", "Chemical energy", "Thermal energy", "Nuclear energy"], "correctIndex": 1, "category": "BIOENERGETICS"},
  ],

  // 3. THE WATER CYCLE (Hydrology)
  "water": [
    {"question": "What is the term for water that seeps into the ground to recharge underground aquifers?", "options": ["Runoff", "Sublimation", "Infiltration", "Condensation"], "correctIndex": 2, "category": "HYDROLOGY"},
    {"question": "What process occurs when solar energy breaks molecular bonds in liquid water?", "options": ["Precipitation", "Evaporation", "Freezing", "Deposition"], "correctIndex": 1, "category": "HYDROLOGY"},
    {"question": "Condensation requires water vapor to form around what?", "options": ["Microscopic particles like dust", "Vacuum pockets", "Large rocks", "Pure oxygen"], "correctIndex": 0, "category": "HYDROLOGY"},
    {"question": "What is the primary driver of the hydrologic cycle besides gravity?", "options": ["Moon's tides", "Solar radiation", "Wind speed", "Volcanic activity"], "correctIndex": 1, "category": "HYDROLOGY"},
    {"question": "Water that does not infiltrate the ground and returns to the ocean is called:", "options": ["Aquifer", "Surface Runoff", "Vapor", "Sleet"], "correctIndex": 1, "category": "HYDROLOGY"},
  ],

  // 4. STATES OF MATTER (Kinetic Theory)
  "matter": [
    {"question": "Which state of matter consists of an ionized gas where electrons are stripped from atoms?", "options": ["Liquid", "Plasma", "Solid", "Gas"], "correctIndex": 1, "category": "PHYSICS"},
    {"question": "What happens during 'Sublimation'?", "options": ["Liquid turns to gas", "Solid turns directly to gas", "Gas turns to solid", "Solid turns to liquid"], "correctIndex": 1, "category": "PHYSICS"},
    {"question": "In which state do particles vibrate in a rigid lattice due to strong forces?", "options": ["Gas", "Liquid", "Solid", "Plasma"], "correctIndex": 2, "category": "PHYSICS"},
    {"question": "What determines the physical state of matter?", "options": ["Color", "The kinetic energy of its particles", "The shape of the container", "The age of the atoms"], "correctIndex": 1, "category": "PHYSICS"},
    {"question": "Which state allows particles to flow while maintaining a constant volume?", "options": ["Solid", "Gas", "Liquid", "Plasma"], "correctIndex": 2, "category": "PHYSICS"},
  ],

  // 5. THE HUMAN HEART (Hemodynamics)
  "heart": [
    {"question": "Why is the muscle wall of the left ventricle thicker than the right?", "options": ["It stores more blood", "It pumps blood only to the lungs", "It pumps blood to the entire body", "It protects the heart valves"], "correctIndex": 2, "category": "ANATOMY"},
    {"question": "Which circuit sends deoxygenated blood to the lungs?", "options": ["Systemic Circuit", "Pulmonary Circuit", "Electrical Circuit", "Lymphatic Circuit"], "correctIndex": 1, "category": "ANATOMY"},
    {"question": "Where do the electrical impulses that coordinate heart contractions begin?", "options": ["The Left Ventricle", "The SA Node", "The Heart Valves", "The Aorta"], "correctIndex": 1, "category": "ANATOMY"},
    {"question": "What is the primary purpose of the four heart valves?", "options": ["To produce oxygen", "To prevent backflow of blood", "To speed up the heart rate", "To filter nutrients"], "correctIndex": 1, "category": "ANATOMY"},
    {"question": "The right side of the heart deals primarily with what kind of blood?", "options": ["Oxygenated", "Deoxygenated", "Plasma-only", "Nutrient-poor"], "correctIndex": 1, "category": "ANATOMY"},
  ],

  // 6. GRAVITY & RELATIVITY (Modern Physics)
  "gravity": [
    {"question": "In General Relativity, how is gravity described?", "options": ["A magnetic pull", "A curvature of spacetime", "A chemical reaction", "A flow of electrons"], "correctIndex": 1, "category": "MODERN PHYSICS"},
    {"question": "What is the constant acceleration of gravity (g) on Earth's surface?", "options": ["5.5 m/s²", "9.8 m/s²", "1.2 m/s²", "100 m/s²"], "correctIndex": 1, "category": "MODERN PHYSICS"},
    {"question": "Which is the weakest of the four fundamental forces?", "options": ["Magnetism", "Strong Nuclear Force", "Gravity", "Weak Nuclear Force"], "correctIndex": 2, "category": "MODERN PHYSICS"},
    {"question": "Newtonian physics describes gravity as a:", "options": ["Force of attraction", "Visual illusion", "Gas", "Sound wave"], "correctIndex": 0, "category": "MODERN PHYSICS"},
    {"question": "Gravity governs large-scale structures like:", "options": ["Atoms", "Cell walls", "Galaxies and star orbits", "Microchips"], "correctIndex": 2, "category": "MODERN PHYSICS"},
  ],

  // 7. CELL BIOLOGY (Cytology)
  "cells": [
    {"question": "Which organelle is responsible for translating genetic code into protein structures?", "options": ["Mitochondria", "Nucleus", "Ribosomes", "Vacuoles"], "correctIndex": 2, "category": "CYTOLOGY"},
    {"question": "Which part of the cell functions as the 'command center' housing DNA?", "options": ["Golgi Apparatus", "Nucleus", "Cytoskeleton", "Ribosome"], "correctIndex": 1, "category": "CYTOLOGY"},
    {"question": "Mitochondria are the 'power plants' that produce energy in the form of:", "options": ["DNA", "ATP", "Glucose", "RNA"], "correctIndex": 1, "category": "CYTOLOGY"},
    {"question": "Which organelle is responsible for packaging proteins for transport?", "options": ["The Golgi Apparatus", "The Nucleus", "The Ribosome", "The Cell Wall"], "correctIndex": 0, "category": "CYTOLOGY"},
    {"question": "The network of protein fibers that helps a cell maintain its shape is the:", "options": ["Cell Membrane", "Cytoskeleton", "Endoplasmic Reticulum", "Cytoplasm"], "correctIndex": 1, "category": "CYTOLOGY"},
  ],

  // 8. ELECTRICITY (Electromagnetism)
  "electric": [
    {"question": "If you increase the resistance in a circuit while keeping voltage the same, what happens to the current?", "options": ["Current increases", "Current stays the same", "Current decreases", "Current stops entirely"], "correctIndex": 2, "category": "ELECTROMAGNETISM"},
    {"question": "What unit is used to measure the potential energy 'push' of a charge?", "options": ["Amperes", "Ohms", "Volts", "Watts"], "correctIndex": 2, "category": "ELECTROMAGNETISM"},
    {"question": "Materials like Copper that have low resistance are called:", "options": ["Insulators", "Conductors", "Resistors", "Ionizers"], "correctIndex": 1, "category": "ELECTROMAGNETISM"},
    {"question": "According to Ohm's Law (V=IR), current is inversely proportional to:", "options": ["Voltage", "Resistance", "Distance", "Brightness"], "correctIndex": 1, "category": "ELECTROMAGNETISM"},
    {"question": "Electricity is primarily the movement of which subatomic particle?", "options": ["Protons", "Neutrons", "Electrons", "Nuclei"], "correctIndex": 2, "category": "ELECTROMAGNETISM"},
  ],

// --- MATH CATEGORY ---

  // 1. ALGEBRAIC LOGIC
  "alg_1": [
    {"question": "What is the primary goal of the 'Equality Property' in Algebra?", "options": ["To make one side larger", "To keep the equation balanced", "To remove all variables", "To change the numbers"], "correctIndex": 1, "category": "ALGEBRA"},
    {"question": "In the equation x + 5 = 12, what is the first step to isolate x?", "options": ["Add 5 to both sides", "Multiply by 5", "Subtract 5 from both sides", "Divide by 12"], "correctIndex": 2, "category": "ALGEBRA"},
    {"question": "What does a variable (like x or y) represent in an equation?", "options": ["A fixed constant", "An unknown value", "The title of the math book", "A specific prime number"], "correctIndex": 1, "category": "ALGEBRA"},
    {"question": "If you multiply one side of an equation by 2, what must you do to the other side?", "options": ["Nothing", "Subtract 2", "Multiply it by 2", "Divide it by 2"], "correctIndex": 2, "category": "ALGEBRA"},
    {"question": "Algebra is often called the language of:", "options": ["Specifics", "Generalization", "History", "Biology"], "correctIndex": 1, "category": "ALGEBRA"},
  ],

  // 2. GEOMETRY & SPACE
  "geo_1": [
    {"question": "What does 'Volume' measure in geometry?", "options": ["The distance around a shape", "The space inside a 3D object", "The length of a line", "The sum of the angles"], "correctIndex": 1, "category": "GEOMETRY"},
    {"question": "What is the sum of the interior angles of any triangle?", "options": ["90°", "360°", "180°", "270°"], "correctIndex": 2, "category": "GEOMETRY"},
    {"question": "In Euclidean geometry, an 'Axiom' is defined as:", "options": ["A proven formula", "A self-evident truth", "A type of square", "A measuring tool"], "correctIndex": 1, "category": "GEOMETRY"},
    {"question": "The 2D space inside a boundary is called the:", "options": ["Perimeter", "Volume", "Area", "Radius"], "correctIndex": 2, "category": "GEOMETRY"},
    {"question": "Geometry is essential for which modern technology mentioned in the lesson?", "options": ["Microwaves", "Satellite navigation", "Steam engines", "Battery storage"], "correctIndex": 1, "category": "GEOMETRY"},
  ],

  // 3. NUMBER THEORY
  "numbers": [
    {"question": "What is a Prime Number?", "options": ["A number divisible by 2", "A number with only two divisors (1 and itself)", "Any very large number", "A number used only in geometry"], "correctIndex": 1, "category": "NUMBER THEORY"},
    {"question": "Why are primes called the 'atoms' of the number world?", "options": ["They are very small", "Every integer has a unique set of prime factors", "They are invisible", "They only exist in science"], "correctIndex": 1, "category": "NUMBER THEORY"},
    {"question": "Which field of digital security relies heavily on Prime Numbers?", "options": ["Social Media", "Cryptography (RSA encryption)", "Screen resolution", "Battery life"], "correctIndex": 1, "category": "NUMBER THEORY"},
    {"question": "Which of the following is a prime number?", "options": ["9", "15", "13", "21"], "correctIndex": 2, "category": "NUMBER THEORY"},
    {"question": "Number Theory is specifically the study of:", "options": ["Shapes", "Integers", "Waves", "Money"], "correctIndex": 1, "category": "NUMBER THEORY"},
  ],

  // 4. PROBABILITY
  "prob": [
    {"question": "What is the probability of an event that is absolutely certain to happen?", "options": ["0", "0.5", "1", "100"], "correctIndex": 2, "category": "PROBABILITY"},
    {"question": "According to the Law of Large Numbers, repeating an experiment makes results:", "options": ["More random", "Closer to the theoretical average", "Impossible to predict", "Always zero"], "correctIndex": 1, "category": "PROBABILITY"},
    {"question": "A probability of 0 indicates that an event is:", "options": ["Very likely", "Impossible", "Half-likely", "Certain"], "correctIndex": 1, "category": "PROBABILITY"},
    {"question": "Probability is vital for which of these industries?", "options": ["Cooking", "Insurance and forecasting", "Painting", "Music composition"], "correctIndex": 1, "category": "PROBABILITY"},
    {"question": "The probability scale ranges between which two numbers?", "options": ["-1 and 1", "0 and 10", "0 and 1", "1 and 100"], "correctIndex": 2, "category": "PROBABILITY"},
  ],

  // 5. STATISTICS
  "stats": [
    {"question": "In statistics, what is the 'Median'?", "options": ["The most frequent number", "The average", "The middle value in a set", "The highest number"], "correctIndex": 2, "category": "STATISTICS"},
    {"question": "What does 'Variance' help scientists understand?", "options": ["The middle value", "How spread out the data is", "The total sum", "The name of the participants"], "correctIndex": 1, "category": "STATISTICS"},
    {"question": "The 'Mean' of a data set is also known as the:", "options": ["Frequent value", "Average", "Difference", "Middle"], "correctIndex": 1, "category": "STATISTICS"},
    {"question": "Which statistical value represents the most frequent number in a set?", "options": ["Mean", "Median", "Mode", "Range"], "correctIndex": 2, "category": "STATISTICS"},
    {"question": "Statistics allows us to find trends in 'noisy' data, such as:", "options": ["The color of a car", "Medical trial results", "The length of a pencil", "The time of day"], "correctIndex": 1, "category": "STATISTICS"},
  ],

  // 6. PYTHAGOREAN THEOREM
  "pythag": [
    {"question": "The Pythagorean Theorem (a² + b² = c²) applies to which type of triangle?", "options": ["Equilateral", "Isosceles", "Right-angled", "Obtuse"], "correctIndex": 2, "category": "TRIGONOMETRY"},
    {"question": "In the formula a² + b² = c², what does 'c' represent?", "options": ["The shortest side", "The right angle", "The hypotenuse", "The area"], "correctIndex": 2, "category": "TRIGONOMETRY"},
    {"question": "Which modern technology uses this theorem to calculate distances between points?", "options": ["Bluetooth", "GPS", "Touchscreens", "Solar panels"], "correctIndex": 1, "category": "TRIGONOMETRY"},
    {"question": "If a=3 and b=4, what is c²?", "options": ["7", "12", "25", "50"], "correctIndex": 2, "category": "TRIGONOMETRY"},
    {"question": "The Pythagorean Theorem is the foundation for which other math branch?", "options": ["Statistics", "Trigonometry", "Probability", "Calculus"], "correctIndex": 1, "category": "TRIGONOMETRY"},
  ],

  // 7. CALCULUS: DERIVATIVES
  "deriv": [
    {"question": "What does a 'Derivative' represent in calculus?", "options": ["The total area", "The rate of change at a point", "A fixed number", "The sum of a set"], "correctIndex": 1, "category": "CALCULUS"},
    {"question": "If you have a graph of a car's position, the derivative tells you its:", "options": ["Color", "Exact velocity at any moment", "Fuel level", "Total distance"], "correctIndex": 1, "category": "CALCULUS"},
    {"question": "Calculus is often described as the math of:", "options": ["Still objects", "Motion", "History", "Shapes"], "correctIndex": 1, "category": "CALCULUS"},
    {"question": "Physicists use derivatives to model:", "options": ["Changing systems", "Fixed points", "The past", "Static shapes"], "correctIndex": 0, "category": "CALCULUS"},
    {"question": "A derivative measures how a function changes at:", "options": ["The beginning only", "The end only", "Any specific point", "No points"], "correctIndex": 2, "category": "CALCULUS"},
  ],

  // 8. CALCULUS: INTEGRALS
  "integ": [
    {"question": "Visually, an 'Integral' represents what on a graph?", "options": ["The highest point", "The slope of a line", "The area under a curve", "The starting point"], "correctIndex": 2, "category": "CALCULUS"},
    {"question": "If you know the speed of a rocket, the integral calculates the:", "options": ["Current speed", "Total distance traveled", "Weight of the rocket", "Angle of launch"], "correctIndex": 1, "category": "CALCULUS"},
    {"question": "While derivatives find change, integrals find:", "options": ["Total accumulation", "Subtraction", "Zero points", "Gradients"], "correctIndex": 0, "category": "CALCULUS"},
    {"question": "Integrals allow us to find the total of something over:", "options": ["A single point", "Time or space", "The alphabet", "A list of names"], "correctIndex": 1, "category": "CALCULUS"},
    {"question": "Calculus consists of two main parts: Derivatives and:", "options": ["Algebra", "Integrals", "Geometry", "Statistics"], "correctIndex": 1, "category": "CALCULUS"},
  ],

  // 9. FRACTIONS & RATIOS
  "ratios": [
    {"question": "If two ratios are equal, what are they called?", "options": ["Variables", "Proportions", "Integers", "Primes"], "correctIndex": 1, "category": "RATIOS"},
    {"question": "A ratio (like 3:1) is used to:", "options": ["Add two numbers", "Compare two quantities", "Find the area", "Measure temperature"], "correctIndex": 1, "category": "RATIOS"},
    {"question": "Architects use proportions for 'scaling,' which means:", "options": ["Painting the building", "Making small models behave like large buildings", "Measuring the weight", "Buying materials"], "correctIndex": 1, "category": "RATIOS"},
    {"question": "If a map ratio is 1:100, 1cm on the map equals how much in real life?", "options": ["1cm", "100cm", "10cm", "1000cm"], "correctIndex": 1, "category": "RATIOS"},
    {"question": "Proportions are essentially equations where:", "options": ["Ratios are compared", "Numbers are added", "Angles are measured", "Lines are drawn"], "correctIndex": 0, "category": "RATIOS"},
  ],

  // 10. TRIGONOMETRY
  "trig": [
    {"question": "Which functions are used to describe repeating cycles like sound waves?", "options": ["Addition and Subtraction", "Sine and Cosine", "Primes and Factors", "Limits and Bounds"], "correctIndex": 1, "category": "TRIGONOMETRY"},
    {"question": "Trigonometry studies the relationship between side lengths and:", "options": ["Colors", "Angles", "Weight", "Volume"], "correctIndex": 1, "category": "TRIGONOMETRY"},
    {"question": "Periodic cycles, such as ocean tides, are described by:", "options": ["Linear equations", "Sine waves", "Prime numbers", "Fractions"], "correctIndex": 1, "category": "TRIGONOMETRY"},
    {"question": "Trigonometry is essential for understanding which of these?", "options": ["Light waves", "History dates", "Plant growth", "Cooking recipes"], "correctIndex": 0, "category": "TRIGONOMETRY"},
    {"question": "A periodic cycle is one that:", "options": ["Never repeats", "Repeats over time", "Goes in a straight line", "Has no end"], "correctIndex": 1, "category": "TRIGONOMETRY"},
  ],

  // 11. FINANCIAL MATH
  "finance": [
    {"question": "What is 'Compound Interest'?", "options": ["Interest paid only once", "Interest earned on both principal and previous interest", "A fee for opening a bank account", "Tax paid to the government"], "correctIndex": 1, "category": "FINANCE"},
    {"question": "Compound interest leads to 'exponential growth,' which means:", "options": ["Money stays the same", "Money grows slowly and then very fast", "Money disappears", "Interest is never added"], "correctIndex": 1, "category": "FINANCE"},
    {"question": "The 'Principal' in financial math refers to:", "options": ["The bank manager", "The original amount of money", "The interest rate", "The total tax"], "correctIndex": 1, "category": "FINANCE"},
    {"question": "Interest is essentially the:", "options": ["Reward for saving or cost of borrowing", "Gift from the bank", "Math used in geometry", "Price of a wallet"], "correctIndex": 0, "category": "FINANCE"},
    {"question": "Which grows faster over long periods?", "options": ["Simple interest", "Compound interest", "No interest", "Cash under a mattress"], "correctIndex": 1, "category": "FINANCE"},
  ],

  // 12. LOGIC & SETS
  "logic": [
    {"question": "Which branch of math is the foundation for computer 'Boolean Logic'?", "options": ["Geometry", "Set Theory and Logic", "Calculus", "Statistics"], "correctIndex": 1, "category": "COMPUTER SCIENCE"},
    {"question": "In logic, what are the three main operators?", "options": ["Plus, Minus, Equals", "AND, OR, NOT", "Red, Blue, Green", "Start, Stop, Wait"], "correctIndex": 1, "category": "COMPUTER SCIENCE"},
    {"question": "Complex decisions in apps are broken down into simple:", "options": ["Numbers", "True or False statements", "Pictures", "Colors"], "correctIndex": 1, "category": "COMPUTER SCIENCE"},
    {"question": "A 'Set' in mathematics is used to:", "options": ["Measure length", "Group objects together", "Solve for x", "Draw a triangle"], "correctIndex": 1, "category": "COMPUTER SCIENCE"},
    {"question": "Logic and Sets form the basis of:", "options": ["Ancient history", "Modern computing", "Biology", "Physical sports"], "correctIndex": 1, "category": "COMPUTER SCIENCE"},
  ],

// --- HISTORY CATEGORY ---

  // 1. BIRTH OF CIVILIZATION
  "civ_1": [
    {"question": "Which transition allowed the first civilizations to build permanent cities?", "options": ["The discovery of electricity", "The shift from hunting to agriculture", "The invention of the internet", "The use of iron tools"], "correctIndex": 1, "category": "ANCIENT HISTORY"},
    {"question": "What are the 'four pillars' of civilization mentioned in the lesson?", "options": ["Fire, Water, Earth, Air", "Agriculture, Specialization, Government, Writing", "Hunting, Gathering, Nomadism, Tools", "Gold, Silver, Silk, Spices"], "correctIndex": 1, "category": "ANCIENT HISTORY"},
    {"question": "Where did the 'Neolithic Revolution' primarily occur?", "options": ["In mountain caves", "In river valleys like the Nile", "On isolated islands", "In the deep ocean"], "correctIndex": 1, "category": "ANCIENT HISTORY"},
    {"question": "How did early humans control water to support their cities?", "options": ["By building plastic pipes", "Through irrigation", "By moving the cities every day", "They didn't use water"], "correctIndex": 1, "category": "ANCIENT HISTORY"},
    {"question": "What is 'Specialization' in the context of early civilizations?", "options": ["Everyone doing the same job", "People developing different, specific jobs", "Growing only one type of plant", "Living in only one house"], "correctIndex": 1, "category": "ANCIENT HISTORY"},
  ],

  // 2. SYSTEMS OF GOVERNMENT
  "gov_1": [
    {"question": "What is the core idea of the 'Social Contract' theory?", "options": ["Kings have total power", "Government rule requires the consent of the governed", "Laws should never change", "Only rich people can vote"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "Ancient Athens is famous for introducing which system?", "options": ["Monarchy", "Direct Democracy", "Representative Republic", "Dictatorship"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "In a 'Representative Democracy' (like the Roman Republic), citizens:", "options": ["Vote on every law personally", "Elect officials to make decisions for them", "Have no say in the law", "Are all kings"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "The 'Social Contract' balances individual liberty with what?", "options": ["Individual wealth", "Social order", "Total chaos", "Royal power"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "Which ancient civilization developed the first 'Republic' model?", "options": ["The Vikings", "The Romans", "The Aztecs", "The Mesopotamians"], "correctIndex": 1, "category": "CIVICS"},
  ],

  // 3. THE SILK ROAD
  "silk_road": [
    {"question": "What was the most significant non-physical impact of the Silk Road?", "options": ["Faster horses", "Better clothing", "The diffusion of ideas and religions", "Larger ships"], "correctIndex": 2, "category": "GLOBALIZATION"},
    {"question": "The Silk Road connected which two general regions?", "options": ["The North and South Poles", "The East and the West", "Africa and Antarctica", "The Americas and Australia"], "correctIndex": 1, "category": "GLOBALIZATION"},
    {"question": "Which of these inventions traveled along the Silk Road to reach the West?", "options": ["The Steam Engine", "The Compass and Gunpowder", "The Internet", "The Telephone"], "correctIndex": 1, "category": "GLOBALIZATION"},
    {"question": "The Silk Road is considered the first major era of:", "options": ["Industrialization", "Globalization", "Isolationism", "Colonization"], "correctIndex": 1, "category": "GLOBALIZATION"},
    {"question": "Economic trade on the Silk Road acted as a primary engine for:", "options": ["Human progress", "Stopping travel", "Ending technology", "Reducing culture"], "correctIndex": 0, "category": "GLOBALIZATION"},
  ],

  // 4. THE RENAISSANCE
  "renaissance": [
    {"question": "How did the Printing Press impact the Renaissance?", "options": ["It made books more expensive", "It limited who could read", "It revolutionized the mass spread of information", "It was only used for art"], "correctIndex": 2, "category": "CULTURE"},
    {"question": "The philosophy of 'Humanism' emphasized the value of:", "options": ["Machines", "Human beings and their agency", "Only kings", "Animals"], "correctIndex": 1, "category": "CULTURE"},
    {"question": "Which famous polymath is mentioned as a product of this era?", "options": ["Albert Einstein", "Leonardo da Vinci", "Isaac Newton", "Thomas Edison"], "correctIndex": 1, "category": "CULTURE"},
    {"question": "The word 'Renaissance' literally means:", "options": ["The End", "Rebirth", "Darkness", "Revolution"], "correctIndex": 1, "category": "CULTURE"},
    {"question": "What era did the Renaissance follow?", "options": ["The Space Age", "The Middle Ages", "The Industrial Revolution", "The Bronze Age"], "correctIndex": 1, "category": "CULTURE"},
  ],

  // 5. THE INDUSTRIAL REVOLUTION
  "industrial": [
    {"question": "The Industrial Revolution shifted the global economy from agriculture to what?", "options": ["Hunting", "Hand-weaving", "Manufacturing", "Fishing"], "correctIndex": 2, "category": "ECONOMICS"},
    {"question": "Which invention allowed factories to produce goods at an unprecedented scale?", "options": ["The Printing Press", "The Steam Engine", "The Astrolabe", "The Compass"], "correctIndex": 1, "category": "ECONOMICS"},
    {"question": "What is 'Urbanization'?", "options": ["Moving from cities to farms", "Moving from rural areas to industrial cities", "Traveling across the ocean", "Learning to fly"], "correctIndex": 1, "category": "ECONOMICS"},
    {"question": "The shift from hand tools to power-driven machinery began in which century?", "options": ["12th", "15th", "18th", "21st"], "correctIndex": 2, "category": "ECONOMICS"},
    {"question": "What was a negative challenge created by the Industrial Revolution?", "options": ["Too much medicine", "Poor working conditions", "Lack of factories", "No more cities"], "correctIndex": 1, "category": "ECONOMICS"},
  ],

  // 6. THE AGE OF EXPLORATION
  "exploration": [
    {"question": "The Columbian Exchange refers to the transfer of what between the Old and New Worlds?", "options": ["Gold and Silver only", "Plants, animals, and technology", "Just sailors", "Religious books only"], "correctIndex": 1, "category": "WORLD HISTORY"},
    {"question": "Which two technologies helped explorers navigate the oceans?", "options": ["The Steam Engine and Car", "The Astrolabe and Caravel ship", "The Radio and GPS", "The Clock and Map"], "correctIndex": 1, "category": "WORLD HISTORY"},
    {"question": "What was the primary motive for 15th-century explorers?", "options": ["To find ice", "Direct access to gold and spices", "To prove the world was flat", "To escape their countries"], "correctIndex": 1, "category": "WORLD HISTORY"},
    {"question": "What was a negative result of the Columbian Exchange?", "options": ["The invention of the wheel", "The introduction of new diseases", "Too many potatoes in Europe", "The end of sailing"], "correctIndex": 1, "category": "WORLD HISTORY"},
    {"question": "The Age of Exploration connected which regions in a 'global loop'?", "options": ["Mars and Earth", "Americas, Africa, Europe, and Asia", "Only Spain and Portugal", "The North and South Poles"], "correctIndex": 1, "category": "WORLD HISTORY"},
  ],

  // 7. HUMAN RIGHTS EVOLUTION
  "rights": [
    {"question": "Which international organization was formed to establish the Universal Declaration of Human Rights?", "options": ["The Roman Empire", "The Silk Road Network", "The United Nations", "The Printing Guild"], "correctIndex": 2, "category": "CIVICS"},
    {"question": "The Magna Carta (1215) is significant because it:", "options": ["Gave the King more power", "Limited the power of kings", "Started the Industrial Revolution", "Was the first book printed"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "What did Enlightenment philosophers argue for?", "options": ["Natural Rights", "The right to stay in the Middle Ages", "The power of machines", "More wars"], "correctIndex": 0, "category": "CIVICS"},
    {"question": "The Universal Declaration states that all humans deserve:", "options": ["Free gold", "Life, liberty, and security", "To be kings", "Free ships"], "correctIndex": 1, "category": "CIVICS"},
    {"question": "The evolution of human rights has established that rights apply to everyone regardless of:", "options": ["Their age", "Nationality, race, or religion", "Their favorite food", "Where they go on vacation"], "correctIndex": 1, "category": "CIVICS"},
  ],

// --- ENGLISH CATEGORY ---

  // 1. THE POWER OF PARTS (Parts of Speech)
  "speech_1": [
    {"question": "Which part of speech acts as the 'glue' to join words or clauses?", "options": ["Nouns", "Adverbs", "Conjunctions", "Prepositions"], "correctIndex": 2, "category": "GRAMMAR"},
    {"question": "Adjectives and Adverbs are known as:", "options": ["Subjects", "Actions", "Modifiers", "Connectors"], "correctIndex": 2, "category": "GRAMMAR"},
    {"question": "In the 'machine' of a sentence, which parts provide the action?", "options": ["Nouns", "Verbs", "Pronouns", "Adjectives"], "correctIndex": 1, "category": "GRAMMAR"},
    {"question": "What is the primary role of a Preposition?", "options": ["To name a person", "To describe an action", "To establish relationships in space and time", "To replace a noun"], "correctIndex": 2, "category": "GRAMMAR"},
    {"question": "Why is understanding parts of speech helpful for a writer?", "options": ["To count words", "To diagnose and fix 'broken' sentences", "To make the text longer", "To change the font"], "correctIndex": 1, "category": "GRAMMAR"},
  ],

  // 2. SENTENCE ARCHITECTURE (Clausal Structures)
  "struct_1": [
    {"question": "What defines a 'Simple Sentence'?", "options": ["It has no verbs", "It contains one independent clause", "It has at least three subjects", "It is very short"], "correctIndex": 1, "category": "SYNTAX"},
    {"question": "Which type of sentence is best for showing relationships like cause and effect?", "options": ["Simple Sentence", "Compound Sentence", "Complex Sentence", "Fragment"], "correctIndex": 2, "category": "SYNTAX"},
    {"question": "A Compound Sentence joins two independent clauses using a:", "options": ["Verb", "Coordinator", "Adjective", "Noun"], "correctIndex": 1, "category": "SYNTAX"},
    {"question": "How can a writer use sentence structure to create 'tension'?", "options": ["Using very long sentences", "Using short, simple sentences", "Using no punctuation", "Using only adjectives"], "correctIndex": 1, "category": "SYNTAX"},
    {"question": "Varying sentence structure primarily helps a writer control:", "options": ["The price of the book", "The 'pace' of the story", "The spelling of words", "The page numbers"], "correctIndex": 1, "category": "SYNTAX"},
  ],

  // 3. THE ART OF PUNCTUATION
  "punc_1": [
    {"question": "What is the main function of a Semicolon?", "options": ["To end a story", "To link two closely related independent thoughts", "To introduce a list", "To show excitement"], "correctIndex": 1, "category": "PUNCTUATION"},
    {"question": "Which mark acts as an 'introduction' to a list or formal explanation?", "options": ["Comma", "Period", "Colon", "Question Mark"], "correctIndex": 2, "category": "PUNCTUATION"},
    {"question": "The difference between 'Let's eat, Grandpa' and 'Let's eat Grandpa' is caused by a:", "options": ["Semicolon", "Comma", "Colon", "Exclamation point"], "correctIndex": 1, "category": "PUNCTUATION"},
    {"question": "Punctuation marks are described in the lesson as language's:", "options": ["Paintbrushes", "Traffic signals", "Speed bumps", "Engine parts"], "correctIndex": 1, "category": "PUNCTUATION"},
    {"question": "A Comma is used to indicate a brief pause or:", "options": ["The end of a book", "A separation of ideas", "A loud noise", "The author's name"], "correctIndex": 1, "category": "PUNCTUATION"},
  ],

  // 4. THE NARRATIVE ARC (Plot Mechanics)
  "arc_1": [
    {"question": "In the Narrative Arc, what is the 'Exposition'?", "options": ["The turning point", "The building of conflict", "Setting the scene and introducing characters", "The final resolution"], "correctIndex": 2, "category": "NARRATIVE"},
    {"question": "The 'Climax' of a story is best described as the:", "options": ["First page", "Turning point or highest tension", "Slowing down of action", "Beginning of the conflict"], "correctIndex": 1, "category": "NARRATIVE"},
    {"question": "The universal pattern of the Narrative Arc is often called:", "options": ["The Villain's Trap", "The Hero's Journey", "The Writer's Block", "The Reader's Goal"], "correctIndex": 1, "category": "NARRATIVE"},
    {"question": "What happens during the 'Rising Action'?", "options": ["The story ends", "The conflict builds", "The characters go to sleep", "The setting is deleted"], "correctIndex": 1, "category": "NARRATIVE"},
    {"question": "What is the purpose of the 'Resolution'?", "options": ["To start a new conflict", "To conclude the story and tie up loose ends", "To introduce the main character", "To make the story longer"], "correctIndex": 1, "category": "NARRATIVE"},
  ],

  // 5. RHETORICAL DEVICES (Ethos, Pathos, Logos)
  "rhetoric": [
    {"question": "Which pillar of rhetoric refers to the logical evidence and data in an argument?", "options": ["Ethos", "Pathos", "Logos", "Chronos"], "correctIndex": 2, "category": "RHETORIC"},
    {"question": "If a famous doctor speaks for a charity, they are using which rhetorical tool?", "options": ["Pathos", "Logos", "Ethos", "Mythos"], "correctIndex": 2, "category": "RHETORIC"},
    {"question": "Using a sad photo to influence an audience's feelings is an example of:", "options": ["Logos", "Ethos", "Pathos", "Diction"], "correctIndex": 2, "category": "RHETORIC"},
    {"question": "According to the lesson, a rich and persuasive argument uses:", "options": ["Only Logos", "Only Pathos", "A combination of Ethos, Pathos, and Logos", "No rhetorical devices"], "correctIndex": 2, "category": "RHETORIC"},
    {"question": "Recognizing these tools helps you become a more critical consumer of:", "options": ["Food", "Media", "Clothing", "Electricity"], "correctIndex": 1, "category": "RHETORIC"},
  ],

  // 6. FIGURATIVE LANGUAGE
  "figurative": [
    {"question": "What is the difference between a Metaphor and a Simile?", "options": ["A metaphor uses 'like' or 'as'", "A simile states one thing IS another", "A simile uses 'like' or 'as', while a metaphor states one thing IS another", "There is no difference"], "correctIndex": 2, "category": "LITERATURE"},
    {"question": "Giving human traits to non-human things (e.g., 'The wind whispered') is called:", "options": ["Diction", "Personification", "Punctuation", "Rhetoric"], "correctIndex": 1, "category": "LITERATURE"},
    {"question": "The sentence 'The sun was a golden coin' is an example of a:", "options": ["Simile", "Metaphor", "Personification", "Logic link"], "correctIndex": 1, "category": "LITERATURE"},
    {"question": "What is 'Imagery' in writing?", "options": ["The font style", "Language that helps the reader see, smell, or feel the story", "The pictures on the cover", "The length of the paragraphs"], "correctIndex": 1, "category": "LITERATURE"},
    {"question": "Figurative language transforms dry information into:", "options": ["Mathematical data", "An emotional experience", "A list of facts", "Legal documents"], "correctIndex": 1, "category": "LITERATURE"},
  ],

  // 7. ACTIVE VS. PASSIVE VOICE
  "voice_1": [
    {"question": "Which voice is usually preferred in storytelling for being clearer and more engaging?", "options": ["Passive Voice", "Active Voice", "Silent Voice", "Future Voice"], "correctIndex": 1, "category": "STYLE"},
    {"question": "Identify the voice: 'The meal was prepared by the chef.'", "options": ["Active", "Passive", "Narrative", "Rhetorical"], "correctIndex": 1, "category": "STYLE"},
    {"question": "In Active Voice, the subject of the sentence:", "options": ["Receives the action", "Performs the action", "Is missing", "Is a preposition"], "correctIndex": 1, "category": "STYLE"},
    {"question": "Why might a scientist use Passive Voice in a report?", "options": ["To be more energetic", "To emphasize the result over the person", "To tell a better story", "Because they forgot the subject"], "correctIndex": 1, "category": "STYLE"},
    {"question": "Active voice creates writing that is:", "options": ["Vague and slow", "Direct and energetic", "Confusing", "Only for science"], "correctIndex": 1, "category": "STYLE"},
  ],

  // 8. THE RESEARCH PROCESS
  "research": [
    {"question": "What is 'Plagiarism'?", "options": ["Reading too many books", "The theft of intellectual property (not crediting sources)", "Using primary sources", "Writing a long essay"], "correctIndex": 1, "category": "ACADEMICS"},
    {"question": "A firsthand account of an event is known as a:", "options": ["Secondary Source", "Primary Source", "Tertiary Source", "Fictional Source"], "correctIndex": 1, "category": "ACADEMICS"},
    {"question": "Why do writers use 'Citations'?", "options": ["To make the page look busy", "To credit their sources and avoid plagiarism", "To change the tone", "To count their references"], "correctIndex": 1, "category": "ACADEMICS"},
    {"question": "Analysis of an event written by someone who wasn't there is a:", "options": ["Primary Source", "Secondary Source", "Ghost story", "Diction"], "correctIndex": 1, "category": "ACADEMICS"},
    {"question": "Crediting sources builds 'Academic Integrity,' which ensures arguments are:", "options": ["Funny", "Backed by verifiable facts", "Very short", "Secret"], "correctIndex": 1, "category": "ACADEMICS"},
  ],

  // 9. DICTION AND TONE
  "diction": [
    {"question": "What does 'Diction' refer to in writing?", "options": ["The speed of reading", "Specific word choice", "The number of pages", "The type of paper used"], "correctIndex": 1, "category": "STYLE"},
    {"question": "The 'Tone' of a piece of writing represents:", "options": ["The loudness of the words", "The author's attitude toward the subject", "The weight of the book", "The time it was written"], "correctIndex": 1, "category": "STYLE"},
    {"question": "The emotional associations of a word are called its:", "options": ["Definitions", "Connotations", "Spelling", "Synonyms"], "correctIndex": 1, "category": "STYLE"},
    {"question": "If a writer chooses the word 'residence' instead of 'home,' they are likely using a:", "options": ["Formal tone", "Emotional tone", "Angry tone", "Casual tone"], "correctIndex": 0, "category": "STYLE"},
    {"question": "By selecting words carefully, a writer can influence how a reader feels without:", "options": ["Writing a sentence", "Explicitly stating the emotion", "Using any verbs", "Using punctuation"], "correctIndex": 1, "category": "STYLE"},
  ],

// --- ARTS CATEGORY ---

  // 1. ELEMENTS OF DESIGN
  "elements_1": [
    {"question": "Which element of design refers to the lightness or darkness of a color?", "options": ["Line", "Value", "Texture", "Space"], "correctIndex": 1, "category": "VISUAL ARTS"},
    {"question": "How many 'core elements' is visual art built from, according to the lesson?", "options": ["Three", "Five", "Seven", "Ten"], "correctIndex": 2, "category": "VISUAL ARTS"},
    {"question": "Which element can be used to create a sense of movement in a piece of art?", "options": ["Value", "Line", "Form", "Color"], "correctIndex": 1, "category": "VISUAL ARTS"},
    {"question": "Mastering the elements of design allows an artist to:", "options": ["Speak out loud", "Guide the viewer’s eye", "Change the price of the paint", "Avoid using paper"], "correctIndex": 1, "category": "VISUAL ARTS"},
    {"question": "Creating the illusion of 3D depth on a 2D surface is primarily the job of:", "options": ["Texture", "Value", "Lines only", "The frame"], "correctIndex": 1, "category": "VISUAL ARTS"},
  ],

  // 2. COLOR THEORY
  "color_1": [
    {"question": "What are the three 'Primary Colors' identified on the Color Wheel?", "options": ["Red, Blue, Green", "Red, Blue, Yellow", "Orange, Green, Purple", "Black, White, Grey"], "correctIndex": 1, "category": "COLOR THEORY"},
    {"question": "Which term describes colors that are opposites on the color wheel, like Blue and Orange?", "options": ["Analogous Colors", "Primary Colors", "Complementary Colors", "Secondary Colors"], "correctIndex": 2, "category": "COLOR THEORY"},
    {"question": "In 'Color Psychology,' which color is often used to represent calm or sadness?", "options": ["Red", "Yellow", "Blue", "Orange"], "correctIndex": 2, "category": "COLOR THEORY"},
    {"question": "Analogous colors are 'neighbors' on the color wheel, meaning they create:", "options": ["High contrast", "Harmony", "Confusion", "Darkness"], "correctIndex": 1, "category": "COLOR THEORY"},
    {"question": "Secondary colors are created by mixing:", "options": ["Black and White", "Primary colors", "Complementary colors", "Analogous colors"], "correctIndex": 1, "category": "COLOR THEORY"},
  ],

  // 3. ART MOVEMENTS
  "movements_1": [
    {"question": "Which art movement focused heavily on realism and perspective?", "options": ["Impressionism", "The Renaissance", "Abstract Art", "Pop Art"], "correctIndex": 1, "category": "ART HISTORY"},
    {"question": "How did Impressionists like Monet react to the invention of the camera?", "options": ["They stopped painting", "They tried to paint even more detail", "They focused on capturing light and movement", "They only painted in black and white"], "correctIndex": 2, "category": "ART HISTORY"},
    {"question": "Which movement removed recognizable objects entirely to focus on pure emotion?", "options": ["The Renaissance", "Impressionism", "Abstract Art", "Realism"], "correctIndex": 2, "category": "ART HISTORY"},
    {"question": "Art history is described in the lesson as a series of:", "options": ["Accidents", "Reactions", "Financial deals", "Coloring books"], "correctIndex": 1, "category": "ART HISTORY"},
    {"question": "Art is often considered a 'mirror' held up to:", "options": ["The sun", "The evolution of human society", "The artist's face", "The museum walls"], "correctIndex": 1, "category": "ART HISTORY"},
  ],

  // 4. THE WORLD OF MUSIC
  "music_1": [
    {"question": "What is the term for the 'timing of notes' in music?", "options": ["Melody", "Rhythm", "Harmony", "Pitch"], "correctIndex": 1, "category": "MUSIC"},
    {"question": "When harmony feels 'tense' or clashing, it is called:", "options": ["Consonant", "Dissonant", "Melodic", "Rhythmic"], "correctIndex": 1, "category": "MUSIC"},
    {"question": "A sequence of pitches played one after another is called a:", "options": ["Rhythm", "Melody", "Drumbeat", "Scale"], "correctIndex": 1, "category": "MUSIC"},
    {"question": "Music is a universal language that communicates through:", "options": ["Sign language", "Vibration and frequency", "Writing only", "Pictures"], "correctIndex": 1, "category": "MUSIC"},
    {"question": "Which tradition is known for 'polyrhythmic' patterns?", "options": ["Western Classical", "African drumming", "Silent films", "Solo singing"], "correctIndex": 1, "category": "MUSIC"},
  ],

  // 5. SCULPTURE & 3D ART
  "sculpt_1": [
    {"question": "Which method of sculpting involves carving away material like marble?", "options": ["Additive", "Subtractive", "Installation", "Digital"], "correctIndex": 1, "category": "3D ART"},
    {"question": "The 'Additive' method of sculpting involves:", "options": ["Cutting stone", "Building up material like clay", "Using only pixels", "Deleting parts of a room"], "correctIndex": 1, "category": "3D ART"},
    {"question": "What is 'Installation Art'?", "options": ["A small statue", "A painting on a wall", "Transforming an entire room into an experience", "A type of pencil"], "correctIndex": 2, "category": "3D ART"},
    {"question": "Unlike a painting, a sculpture forces the viewer to interact with:", "options": ["The artist", "The physical mass and space it occupies", "The frame", "The smell of the paint"], "correctIndex": 1, "category": "3D ART"},
    {"question": "Sculpture is unique because it changes as you:", "options": ["Close your eyes", "Walk around it", "Read the title", "Wait for the lights to change"], "correctIndex": 1, "category": "3D ART"},
  ],

  // 6. THE DIGITAL FRONTIER
  "digital_art": [
    {"question": "Digital art uses what instead of traditional paint?", "options": ["Water", "Pixels", "Charcoal", "Oil"], "correctIndex": 1, "category": "NEW MEDIA"},
    {"question": "Which technology allows creators to build 'immersive worlds'?", "options": ["The Printing Press", "Virtual Reality (VR)", "The Steam Engine", "The Astrolabe"], "correctIndex": 1, "category": "NEW MEDIA"},
    {"question": "What is one major advantage of Digital Art mentioned in the lesson?", "options": ["It is always cheaper", "It allows for infinite editing", "It doesn't require a computer", "It only uses the color red"], "correctIndex": 1, "category": "NEW MEDIA"},
    {"question": "Whether using charcoal or computer code, the goal of art remains:", "options": ["To make money", "To express the human experience", "To follow rules", "To be as fast as possible"], "correctIndex": 1, "category": "NEW MEDIA"},
    {"question": "Artificial Intelligence in art is an example of:", "options": ["The Renaissance", "New Media", "Subtractive sculpture", "Ancient history"], "correctIndex": 1, "category": "NEW MEDIA"},
  ],
};

void _finishQuiz() {
  widget.onFinish(); // This unlocks the next lesson
  
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(
      builder: (context) => LessonPage(subject: widget.subject),
    ),
    (route) => route.isFirst, // This goes back to Home as the base
  );
}

void _handleAnswer() {
    if (selectedIndex == null) return;

    final questions = quizData[widget.quizId]!;
    
    // Check if the current answer is correct
    if (selectedIndex == questions[currentQuestionIndex]['correctIndex']) {
      correctAnswersCount++;
    }

    if (currentQuestionIndex < questions.length - 1) {
      // Move to next question
      setState(() {
        currentQuestionIndex++;
        selectedIndex = null;
      });
    } else {
      // Quiz Finished: Calculate and update global accuracy
      double sessionAccuracy = (correctAnswersCount / questions.length) * 100;
      accuracyNotifier.value = sessionAccuracy; 

      _finishQuiz();
    }
  }

@override
  Widget build(BuildContext context) {
    // FIX: Define questions and currentQuiz before using them
    final questions = quizData[widget.quizId] ?? [];
    if (questions.isEmpty) return const Scaffold(body: Center(child: Text("Quiz not found")));
    
    final currentQuiz = questions[currentQuestionIndex];

    bool isDark = themeNotifier.value == ThemeMode.dark;
    Color primaryGreen = const Color(0xFF4A9F6A);
    Color textDark = isDark ? Colors.white : const Color(0xFF2D2D2D);
    Color textGrey = isDark ? Colors.grey[400]! : const Color(0xFF9E9E9E);
    Color bgLight = isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
    Color cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    Color borderColor = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.15);

    return Scaffold(
      backgroundColor: bgLight,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Progress Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: LinearProgressIndicator(
                value: (currentQuestionIndex + 1) / questions.length,
                backgroundColor: borderColor,
                color: primaryGreen,
              ),
            ),
            const SizedBox(height: 10),
            _buildTopBar(context, primaryGreen, textGrey, cardColor, textDark),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    _buildQuestionCard(
                      currentQuiz["category"] ?? "QUIZ", 
                      currentQuiz["question"], 
                      primaryGreen, textDark, cardColor, borderColor
                    ),
                    const SizedBox(height: 24),
                    ...List.generate(currentQuiz["options"].length, (index) {
                      return _buildOptionCard(
                        index: index,
                        letter: String.fromCharCode(65 + index),
                        text: currentQuiz["options"][index],
                        primaryGreen: primaryGreen,
                        textDark: textDark,
                        textGrey: textGrey,
                        bgLight: bgLight,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        isDark: isDark,
                      );
                    }),
                  ],
                ),
              ),
            ),
            _buildCheckAnswerButton(primaryGreen, textGrey, isDark, currentQuiz, questions.length),
          ],
        ),
      ),
    );
  }

  // --- MODIFIED BUTTON LOGIC ---
Widget _buildCheckAnswerButton(Color primary, Color grey, bool isDark, Map<String, dynamic> currentQuiz, int totalQuestions) {
    bool isLastQuestion = currentQuestionIndex == totalQuestions - 1;
    
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: selectedIndex != null ? _handleAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            disabledBackgroundColor: isDark ? Colors.white10 : Colors.grey[200],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 0,
          ),
          child: Text(
            isLastQuestion ? "FINISH QUIZ" : "NEXT QUESTION",
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 16),
          ),
        ),
      ),
    );
  }

  
  Widget _buildTopBar(BuildContext context, Color primaryGreen, Color textGrey, Color cardColor, Color textDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: textGrey, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: 1.0, // Set to 1.0 for the quiz phase
                    minHeight: 8,
                    backgroundColor: textGrey.withValues(alpha: 0.2),
                    valueColor: AlwaysStoppedAnimation(primaryGreen),
                  ),
                ),
                const SizedBox(height: 6),
                Text("Lesson Quiz", style: TextStyle(color: textGrey, fontWeight: FontWeight.w600, fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Direct Dark Mode Toggle Button
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeNotifier,
            builder: (context, currentTheme, _) {
              bool isDark = currentTheme == ThemeMode.dark;
              return IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.orangeAccent : const Color(0xFF4A9F6A),
                  size: 28,
                ),
                onPressed: () {
                  themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(String category, String question, Color primaryGreen, Color textDark, Color cardColor, Color borderColor) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(category.toUpperCase(), style: TextStyle(color: primaryGreen, fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 1.2)),
          const SizedBox(height: 12),
          Text(question, style: TextStyle(color: textDark, fontSize: 22, fontWeight: FontWeight.w800, height: 1.3)),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required int index, required String letter, required String text,
    required Color primaryGreen, required Color textDark, required Color textGrey, 
    required Color bgLight, required Color cardColor, required Color borderColor, required bool isDark
  }) {
    bool isSelected = selectedIndex == index;
    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? primaryGreen.withValues(alpha: isDark ? 0.15 : 0.05) : cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? primaryGreen : borderColor, width: isSelected ? 2 : 1),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: isSelected ? primaryGreen : bgLight, shape: BoxShape.circle),
              child: Center(child: Text(letter, style: TextStyle(color: isSelected ? Colors.white : textGrey, fontWeight: FontWeight.w800, fontSize: 16))),
            ),
            const SizedBox(width: 16),
            Expanded(child: Text(text, style: TextStyle(color: textDark, fontSize: 16, fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500))),
          ],
        ),
      ),
    );
  }


}