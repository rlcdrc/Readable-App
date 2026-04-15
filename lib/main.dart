import 'package:flutter/material.dart';
import 'dart:async';
import 'home_page.dart'; 
import 'lesson_page.dart';
import 'profile_page.dart';
import 'onboarding.dart';
import 'sign_in.dart'; 
import 'sign_up.dart';

// --- GLOBAL NOTIFIERS ---
// 1. THE GLOBAL THEME SWITCH
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

// 2. THE GLOBAL NAME NOTIFIER (Added for real-time updates)
final ValueNotifier<String> nameNotifier = ValueNotifier<String>("Jane Doe");

// 3. THE GLOBAL PROFILE PICTURE NOTIFIER (Added for real-time updates)
final ValueNotifier<String?> profilePicPathNotifier = ValueNotifier<String?>(null);

// 4. THE GLOBAL BIO NOTIFIER (Added for real-time updates)
final ValueNotifier<String> bioNotifier = ValueNotifier<String>("Avid Reader");

// 5. THE GLOBAL LESSONS COMPLETED NOTIFIER (Added for real-time updates)
final ValueNotifier<int> lessonsCompletedNotifier = ValueNotifier<int>(0);

// 6. THE GLOBAL READING HISTORY NOTIFIER (Added for real-time updates)
final ValueNotifier<List<Map<String, dynamic>>> readingHistoryNotifier = ValueNotifier<List<Map<String, dynamic>>>([]);

// 7. THE GLOBAL FONT SIZE NOTIFIER (for accessibility settings)
final ValueNotifier<double> fontSizeNotifier = ValueNotifier<double>(1.0);

// 8. THE GLOBAL READING SPEED NOTIFIER (for user preferences)
final ValueNotifier<String> readingSpeedNotifier = ValueNotifier<String>("1.0x");

//9. THE GLOBAL QUIZ ACCURACY NOTIFIER (for tracking quiz performance)
final ValueNotifier<double> accuracyNotifier = ValueNotifier<double>(0.0);

  final Map<String, List<Map<String, String>>> subjectContent = {
  "Reading": [
  {
    "title": "The Big Picture", 
    "sub": "Main idea",
    "image": "assets/reading/big_picture.jpg", 
    "status": "inProgress", 
    "content": "Leo entered the Great Library. 'To find the exit,' a voice boomed, 'you must find the Golden Key.' Leo realized the library was full of books, but they all talked about one thing: The Golden Key. In reading, the 'Main Idea' is like that Golden Key—it’s the one big thing everything else is pointing toward.", 
    "quizType": "main_idea"
  },
  {
    "title": "Story Structure", 
    "sub": "Beginning/Middle/End", 
    "image": "assets/reading/structure.jpg",
    "status": "locked", 
    "content": "Leo found a map. It had a Start (where he was), a Mountain (the big challenge), and a Finish (the exit). He realized his own journey was a story! The Beginning is the Start, the Middle is the climb up the mountain, and the End is when he finally reaches safety.", 
    "quizType": "structure"
  },
  {
    "title": "Inferences", 
    "sub": "Reading between lines", 
    "image": "assets/reading/inferences.jpg",
    "status": "locked", 
    "content": "Leo saw wet footprints on the floor and an open window. 'Someone was here while it was raining!' he whispered. He didn't see the person or the rain, but he used clues to figure it out. This is an 'Inference'—using what you see to guess what you don't see.", 
    "quizType": "inference"
  },
  {
    "title": "Vocabulary", 
    "sub": "Context clues", 
    "image": "assets/reading/vocab.jpg",
    "status": "locked", 
    "content": "Leo found a sign that said: 'Beware the Luminous beast.' He didn't know 'Luminous,' but the sign also said, 'It glows so bright it hurts your eyes.' Ah! 'Luminous' must mean glowing or bright. He used the words around it to solve the mystery.", 
    "quizType": "vocab"
  },
  {
    "title": "Characters", 
    "sub": "Traits & Motives", 
    "image": "assets/reading/characters.jpg",
    "status": "locked", 
    "content": "Leo met a small robot who kept sharing its oil with other machines. Leo noticed the robot was 'Generous' (a trait). When he asked why, the robot said, 'I want everyone to keep moving' (a motive). Traits are who we are; motives are why we act.", 
    "quizType": "chars"
  },
  {
    "title": "Point of View", 
    "sub": "First vs Third person", 
    "image": "assets/reading/pov.jpg",
    "status": "locked", 
    "content": "Leo wrote in his diary: 'I feel brave today.' That’s 1st Person! But then he saw an old book describing him: 'The boy walked slowly.' That’s 3rd Person! It depends on who is telling the story—the person inside it, or someone watching from outside.", 
    "quizType": "pov"
  },
  {
    "title": "Cause & Effect", 
    "sub": "Logic links", 
    "image": "assets/reading/cause_effect.jpg",
    "status": "locked", 
    "content": "Leo accidentally tripped over a wire (Cause). Suddenly, the lights flickered and went out (Effect). He learned that every action has a result. If you find the 'Why,' you find the Cause!", 
    "quizType": "cause_effect"
  },
  {
    "title": "Fact vs Opinion", 
    "sub": "True vs Thought", 
    "image": "assets/reading/fact_opinion.jpg",
    "status": "locked", 
    "content": "Leo saw a sign: 'The Library is 100 years old.' That's a Fact—it can be proven. Under it, someone scribbled: 'This is the scariest library ever!' That's an Opinion—it's just how that person felt.", 
    "quizType": "fact_opinion"
  },
  {
    "title": "Summarizing", 
    "sub": "Short versions", 
    "image": "assets/reading/summary.jpg",
    "status": "locked", 
    "content": "To tell his friends about his day, Leo didn't tell every single detail. He said: 'I went to a library, wanted to leave, but got lost, so I solved puzzles, and then I found the way out.' He just gave them the 'Summary'—the short version.", 
    "quizType": "summary"
  },
  {
    "title": "Themes", 
    "sub": "The moral of the story", 
    "image": "assets/reading/themes.jpg",
    "status": "locked", 
    "content": "Finally at the exit, Leo realized he didn't just find a key; he found courage. The 'Theme' of his adventure wasn't just 'Key-finding,' it was 'Courage helps us overcome fear.' The Theme is the big lesson we take home.", 
    "quizType": "theme"
  },
  ],

  "Science": [
  {
    "title": "The Solar System", 
    "sub": "Celestial Mechanics & Formation", 
    "image": "assets/science/solar_system.jpg",
    "status": "inProgress", 
    "content": "The Solar System formed approximately 4.6 billion years ago from the gravitational collapse of a giant interstellar molecular cloud. At the center lies the Sun, a G-type main-sequence star that contains 99.8% of the system's mass, creating a gravitational pull strong enough to keep eight planets and various dwarf planets in stable orbits. The system is divided by the Asteroid Belt: the inner 'Terrestrial' planets (Mercury, Venus, Earth, Mars) feature solid silicate surfaces, while the outer 'Jovian' planets (Jupiter, Saturn, Uranus, Neptune) are composed of volatile gases and ices. Beyond Neptune lies the Kuiper Belt, home to icy bodies and plutoids.", 
    "quizType": "space"
  },
  {
    "title": "Photosynthesis", 
    "sub": "Bioenergetics & Light Reactions", 
    "image": "assets/science/photosynthesis.jpg",
    "status": "locked", 
    "content": "Photosynthesis is the fundamental biochemical process that supports life on Earth by converting light energy into chemical energy. It occurs in two stages within the chloroplasts: the Light-Dependent Reactions and the Calvin Cycle. Chlorophyll pigments absorb blue and red light waves, using that energy to split water molecules (H_2O), which releases Oxygen (O_2) as a byproduct. The remaining hydrogen and electrons are used to transform Carbon Dioxide (CO_2) into Glucose (C_6H_{12}O_6), a high-energy sugar. This process is responsible for nearly all the organic material and atmospheric oxygen available to aerobic organisms.", 
    "quizType": "plants"
  },
  {
    "title": "The Water Cycle", 
    "sub": "Hydrologic Systems & Energy", 
    "image": "assets/science/water_cycle.jpg",
    "status": "locked", 
    "content": "The hydrologic cycle is a closed system driven by solar radiation and Earth's gravity. **Evaporation** occurs when solar energy breaks the molecular bonds of liquid water, turning it into vapor. As vapor rises into the cooler upper atmosphere, it undergoes **Condensation**, forming clouds around microscopic particles like dust or salt. **Precipitation** occurs when these droplets reach a critical mass and fall as rain, snow, or sleet. A significant portion of this water enters **Infiltration**, where it seeps into the ground to recharge aquifers, while the rest becomes surface runoff, eventually returning to the oceans to begin the cycle again.", 
    "quizType": "water"
  },
  {
    "title": "States of Matter", 
    "sub": "Kinetic Theory & Phase Changes", 
    "image": "assets/science/states_of_matter.jpg",
    "status": "locked", 
    "content": "Matter is defined by its physical state, which is determined by the kinetic energy of its particles. In a **Solid**, strong intermolecular forces hold atoms in a rigid lattice, allowing only vibration. **Liquids** possess enough energy to partially overcome these forces, allowing particles to flow while maintaining a constant volume. In a **Gas**, particles move independently at high velocities, filling any container. The fourth state, **Plasma**, occurs at extreme temperatures where electrons are stripped from atoms, creating an ionized gas. Phase changes—like sublimation (solid to gas) or deposition (gas to solid)—occur when energy is added or removed without changing the substance's temperature.", 
    "quizType": "matter"
  },
  {
    "title": "The Human Heart", 
    "sub": "Hemodynamics & Cardiac Cycle", 
    "image": "assets/science/human_heart.png",
    "status": "locked", 
    "content": "The human heart is a sophisticated biological pump that facilitates the double-circulatory system. The **Pulmonary Circuit** (right side) sends deoxygenated blood to the lungs to exchange carbon dioxide for oxygen. The **Systemic Circuit** (left side) features a much thicker muscular wall (the left ventricle) to pump oxygenated blood throughout the entire body. Specialized electrical tissues, starting at the SA node, send impulses that coordinate the contraction of the atria and ventricles. This ensures a one-way flow of blood through four heart valves, preventing backflow and maintaining constant blood pressure to vital organs.", 
    "quizType": "heart"
  },
  {
    "title": "Gravity & Relativity", 
    "sub": "Newtonian & Einsteinian Physics", 
    "image": "assets/science/gravity_relativity.jpg",
    "status": "locked", 
    "content": "In classical mechanics, Gravity is a force of attraction where every point mass attracts every other point mass. However, modern physics (General Relativity) describes gravity not as a force, but as a curvature of **Spacetime** caused by mass and energy. This means a planet doesn't just 'pull' on an object; it warps the fabric of space around it. On Earth's surface, this curvature results in a constant acceleration (g) of 9.8 m/s^2. Gravity is the weakest of the four fundamental forces, yet it dominates the large-scale structure of the universe, governing the orbits of stars and the formation of galaxies.", 
    "quizType": "gravity"
  },
  {
    "title": "Cell Biology", 
    "sub": "Organelles & Genetic Control", 
    "image": "assets/science/cell_biology.jpg",
    "status": "locked", 
    "content": "The cell is the basic unit of life, operating like a microscopic city. The **Nucleus** acts as the command center, housing DNA which provides the blueprints for protein synthesis. The **Mitochondria** are the 'power plants,' converting nutrients into ATP through cellular respiration. The **Endoplasmic Reticulum** and **Golgi Apparatus** function as a factory and shipping department, creating and packaging proteins for transport. **Ribosomes** are the assembly lines where genetic code is translated into physical structures. Eukaryotic cells maintain their shape through a cytoskeleton, a network of protein fibers that also facilitates movement and division.", 
    "quizType": "cells"
  },
  {
    "title": "Electricity", 
    "sub": "Charge, Current, and Resistance", 
    "image": "assets/science/electricity.jpg",
    "status": "locked", 
    "content": "Electricity is the movement of charge, usually in the form of electrons. **Voltage** (measured in Volts) represents the potential energy difference that 'pushes' the charge. **Current** (measured in Amperes) is the actual rate of flow of that charge through a conductor. **Resistance** (measured in Ohms) is the property of a material that resists that flow. Materials with low resistance, like Copper and Gold, are called Conductors, while high-resistance materials like Rubber are Insulators. According to Ohm's Law (V = IR), the current is directly proportional to the voltage and inversely proportional to the resistance within a closed circuit.", 
    "quizType": "electric"
  },
  ],

  "Math": [
  {
    "title": "Algebraic Logic", 
    "sub": "Variables & Equivalency", 
    "image": "assets/math/algebra.jpg",
    "status": "inProgress", 
    "content": "Algebra is the language of generalization. Instead of working with specific numbers, we use variables (like x or y) to represent unknowns. The fundamental principle of Algebra is the **Equality Property**: an equation is a balanced scale. To maintain 'Equivalency,' any operation performed on one side (addition, subtraction, multiplication, or division) must be applied to the other. This allows us to isolate the variable and solve for the unknown, forming the basis for all advanced engineering and physics calculations.", 
    "quizType": "alg_1"
  },
  {
    "title": "Geometry & Space", 
    "sub": "Euclidean Principles", 
    "image": "assets/math/geometry.jpg",
    "status": "locked", 
    "content": "Geometry is the study of shapes, sizes, and the properties of space. Euclidean geometry is built on 'Axioms'—self-evident truths—such as the fact that a straight line can be drawn between any two points. Key concepts include **Area** (the 2D space inside a boundary) and **Volume** (the 3D space an object occupies). Understanding the relationship between angles (like the 180° sum of a triangle's interior) allows us to map the physical world, from architecture to satellite navigation.", 
    "quizType": "geo_1"
  },
  {
    "title": "Number Theory", 
    "sub": "Primes & Cryptography", 
    "image": "assets/math/number_theory.jpg",
    "status": "locked", 
    "content": "Number Theory is the study of integers. At its heart are **Prime Numbers**—numbers greater than 1 that have no divisors other than 1 and themselves. Primes are considered the 'atoms' of the number world because every integer can be broken down into a unique set of prime factors. Today, this abstract math is the backbone of digital security; RSA encryption uses the difficulty of factoring massive prime numbers to protect digital data.", 
    "quizType": "numbers"
  },
  {
    "title": "Probability", 
    "sub": "Predicting Uncertainty", 
    "image": "assets/math/probability.png",
    "status": "locked", 
    "content": "Probability measures the likelihood of an event occurring, ranging from 0 (impossible) to 1 (certain). The **Law of Large Numbers** states that as you repeat an experiment (like flipping a coin), the observed results will get closer to the expected theoretical average. This math is vital for insurance, weather forecasting, and risk management.", 
    "quizType": "prob"
  },
  {
    "title": "Statistics", 
    "sub": "Data Interpretation", 
    "image": "assets/math/statistics.jpg",
    "status": "locked", 
    "content": "Statistics involves collecting and analyzing numerical data. We look for the **Mean** (average), **Median** (middle value), and **Mode** (most frequent). Beyond averages, scientists look at 'Variance' to see how spread out the data is. Statistics allow us to find meaningful trends in 'noisy' data, helping us understand everything from population growth to medical trial results.", 
    "quizType": "stats"
  },
  {
    "title": "Pythagorean Theorem", 
    "sub": "Triangle Relations", 
    "image": "assets/math/pythagorean.jpg",
    "status": "locked", 
    "content": "In a right-angled triangle, the square of the hypotenuse is equal to the sum of the squares of the other two sides (a^2 + b^2 = c^2). This is the foundation of trigonometry and coordinate geometry, used in GPS technology to calculate the distance between two points on a map.", 
    "quizType": "pythag"
  },
  {
    "title": "Calculus: Derivatives", 
    "sub": "Rates of Change", 
    "image": "assets/math/derivatives.png",
    "status": "locked", 
    "content": "Calculus is the math of motion. A **Derivative** measures how a function changes at any specific point. If you have a graph of a car's position, the derivative tells you its exact velocity at any moment. It is the primary tool used by physicists to model moving objects and changing systems.", 
    "quizType": "deriv"
  },
  {
    "title": "Calculus: Integrals", 
    "sub": "Accumulated Area", 
    "image": "assets/math/integrals.jpg",
    "status": "locked", 
    "content": "While derivatives find the rate of change, **Integrals** find the total accumulation. If you know the speed of a rocket, the integral calculates the total distance it has traveled over time. Visually, an integral represents the area under a curve on a graph.", 
    "quizType": "integ"
  },
  {
    "title": "Fractions & Ratios", 
    "sub": "Proportionality", 
    "image": "assets/math/fractions_ratios.png",
    "status": "locked", 
    "content": "Ratios compare two quantities (e.g., 3:1). Proportions are equations where two ratios are equal. This math is essential for 'scaling'—allowing architects to build small models that behave exactly like the full-sized buildings they represent.", 
    "quizType": "ratios"
  },
  {
    "title": "Trigonometry", 
    "sub": "Sine, Cosine, & Waves", 
    "image": "assets/math/trigonometry.jpg",
    "status": "locked", 
    "content": "Trigonometry studies the relationship between side lengths and angles of triangles. Functions like **Sine** and **Cosine** describe periodic cycles, meaning they repeat over time. This math is used to understand sound waves, light waves, and even the tides of the ocean.", 
    "quizType": "trig"
  },
  {
    "title": "Financial Math", 
    "sub": "Compound Interest", 
    "image": "assets/math/financial_math.jpg",
    "status": "locked", 
    "content": "Interest is the cost of borrowing money or the reward for saving it. **Compound Interest** occurs when interest is added to the principal, so that from then on, the interest that has been added also earns interest. This leads to 'exponential growth,' where small amounts of money grow significantly over long periods.", 
    "quizType": "finance"
  },
  {
    "title": "Logic & Sets", 
    "sub": "The Basis of Computing", 
    "image": "assets/math/logic_sets.jpg",
    "status": "locked", 
    "content": "Mathematical logic uses 'Sets' to group objects and 'Operators' (AND, OR, NOT) to determine truth. This is the foundation of computer science. Every app and website runs on 'Boolean Logic,' where complex decisions are broken down into simple True or False statements.", 
    "quizType": "logic"
  },
  ],

  "History": [
  {
    "title": "Birth of Civilization", 
    "sub": "Mesopotamia & The Nile", 
    "image": "assets/history/birth_civil.webp",
    "status": "inProgress", 
    "content": "Civilization began when humans transitioned from nomadic hunter-gatherer lifestyles to permanent agricultural settlements. This 'Neolithic Revolution' occurred independently in river valleys like the Fertile Crescent and the Nile. These societies developed the four pillars of civilization: **Agriculture** (surplus food), **Specialization** (different jobs), **Government** (organized laws), and **Writing** (record keeping). By controlling water through irrigation, these early humans built the first cities, allowing for the rapid expansion of technology and culture.", 
    "quizType": "civ_1"
  },
  {
    "title": "Systems of Government", 
    "sub": "Democracy to Republics", 
    "image": "assets/history/systems_government.webp",
    "status": "locked", 
    "content": "Throughout history, humans have experimented with how to distribute power. Ancient Athens introduced **Direct Democracy**, where citizens voted on laws personally. Later, the Roman Republic developed **Representative Democracy**, where citizens elect officials to make decisions on their behalf. Over centuries, these evolved into the 'Social Contract' theory—the idea that a government's right to rule comes from the consent of the governed. Today, most global nations use a variation of these systems to balance individual liberty with social order.", 
    "quizType": "gov_1"
  },
  {
    "title": "The Silk Road", 
    "sub": "Global Trade Networks", 
    "image": "assets/history/silk_road.webp",
    "status": "locked", 
    "content": "The Silk Road was a vast network of land and sea routes connecting the East and West. It facilitated the exchange of goods like silk, spices, and paper, but its most significant impact was the 'Diffusion of Ideas.' Religions, philosophies, and scientific inventions (like the compass and gunpowder) traveled along these routes, permanently altering the cultures they touched. It represents the first major era of 'Globalization,' proving that economic trade is the primary engine for human progress and cross-cultural understanding.", 
    "quizType": "silk_road"
  },
  {
    "title": "The Renaissance", 
    "sub": "Rebirth of Knowledge", 
    "image": "assets/history/renaissance.jpg",
    "status": "locked", 
    "content": "The Renaissance was a fervent period of European cultural, artistic, political, and scientific 'rebirth' following the Middle Ages. Spanning from the 14th to the 17th century, it promoted the philosophy of **Humanism**, which emphasized the value and agency of human beings. This era produced polymaths like Leonardo da Vinci and saw the invention of the Printing Press by Johannes Gutenberg. This single invention revolutionized the spread of information, making books accessible to the masses and leading to the Scientific Revolution.", 
    "quizType": "renaissance"
  },
  {
    "title": "The Industrial Revolution", 
    "sub": "Technology & Urbanization", 
    "image": "assets/history/industrial_revolution.webp",
    "status": "locked", 
    "content": "Starting in the 18th century, the world shifted from hand tools to power-driven machinery. The invention of the **Steam Engine** allowed factories to produce goods at an unprecedented scale. This led to 'Urbanization,' as millions moved from rural farms to growing industrial cities. While this era created modern medicine and transport, it also created new challenges: poor working conditions and environmental impacts. It was a turning point that shifted the global economy from agriculture-based to manufacturing-based.", 
    "quizType": "industrial"
  },
  {
    "title": "The Age of Exploration", 
    "sub": "Navigation & Discovery", 
    "image": "assets/history/age_exploration.jpg",
    "status": "locked", 
    "content": "Driven by the desire for direct access to gold and spices, 15th-century explorers utilized new maritime technologies like the **Astrolabe** and the **Caravel** ship. This era connected the Americas, Africa, Europe, and Asia in a permanent global loop. However, this 'Discovery' led to the 'Columbian Exchange'—the massive transfer of plants, animals, and technology between the Old and New Worlds. While it brought new foods to different continents, it also introduced diseases and systems of colonial exploitation.", 
    "quizType": "exploration"
  },
  {
    "title": "Human Rights Evolution", 
    "sub": "From Magna Carta to UN", 
    "image": "assets/history/human_rights.webp",
    "status": "locked", 
    "content": "The concept that every human has inherent rights has been a slow evolution. It began with documents like the **Magna Carta** (1215), which limited the power of kings, and moved through the Enlightenment period where philosophers argued for 'Natural Rights.' After the global conflicts of the 20th century, the world formed the **United Nations** and the Universal Declaration of Human Rights. This established that regardless of nationality, race, or religion, all humans deserve life, liberty, and security.", 
    "quizType": "rights"
  },
  ],

  "English": [
  {
    "title": "The Power of Parts", 
    "sub": "Parts of Speech", 
    "image": "assets/english/parts_speech.webp",
    "status": "inProgress", 
    "content": "Every sentence is a machine built from eight specific parts of speech. **Nouns** and **Pronouns** act as the subjects (the 'who'), while **Verbs** provide the action (the 'do'). **Adjectives** and **Adverbs** function as modifiers, adding sensory detail and precision. **Conjunctions** (like 'and' or 'but') act as the glue, and **Prepositions** establish relationships in space and time. Understanding these roles allows a writer to diagnose and fix 'broken' sentences by ensuring every word has a clear functional purpose.", 
    "quizType": "speech_1"
  },
  {
    "title": "Sentence Architecture", 
    "sub": "Clausal Structures", 
    "image": "assets/english/sentence_architecture.jpg",
    "status": "locked", 
    "content": "Rich writing relies on varying sentence structure. A **Simple Sentence** contains one independent clause (one subject/verb pair). A **Compound Sentence** joins two independent clauses with a coordinator. Most importantly, **Complex Sentences** use dependent clauses to show relationships like cause and effect. By mastering these patterns, a writer can control the 'pace' of a story—using short sentences for tension and long, complex ones for deep description.", 
    "quizType": "struct_1"
  },
  {
    "title": "The Art of Punctuation", 
    "sub": "Beyond the Period",
    "image": "assets/english/punctuation.webp",
    "status": "locked", 
    "content": "Punctuation marks are the 'traffic signals' of language. A **Comma** indicates a brief pause or a separation of ideas. A **Semicolon** is stronger, used to link two closely related independent thoughts without a conjunction. **Colons** act as an introduction to a list or a formal explanation. When used correctly, punctuation prevents ambiguity—the famous difference between 'Let's eat, Grandpa' (an invitation) and 'Let's eat Grandpa' (a disaster).", 
    "quizType": "punc_1"
  },
  {
    "title": "The Narrative Arc", 
    "sub": "Plot Mechanics", 
    "image": "assets/english/narrative_arc.webp",
    "status": "locked", 
    "content": "Every great story follows a structural 'Arc.' It begins with **Exposition** (setting the scene), moves to the **Rising Action** (building conflict), reaches the **Climax** (the turning point), and concludes with the **Resolution**. This universal pattern, often called 'The Hero's Journey,' is found in everything from ancient myths to modern movies. Understanding this structure allows writers to keep readers engaged by strategically placing obstacles in the character's path.", 
    "quizType": "arc_1"
  },
  {
    "title": "Rhetorical Devices", 
    "sub": "Ethos, Pathos, & Logos", 
    "image": "assets/english/rhetoric.webp",
    "status": "locked", 
    "content": "Persuasion is a science. Aristotle identified three pillars of rhetoric: **Ethos** (credibility of the speaker), **Pathos** (emotional appeal), and **Logos** (logical evidence). A rich argument uses all three. For example, a charity might show a sad photo (Pathos), provide data on poverty (Logos), and have a famous doctor speak for them (Ethos). Recognizing these tools helps you become both a more convincing writer and a more critical media consumer.", 
    "quizType": "rhetoric"
  },
  {
    "title": "Figurative Language", 
    "sub": "Metaphor & Imagery", 
    "image": "assets/english/figurative_language.png",
    "status": "locked", 
    "content": "Language becomes 'rich' when it moves beyond literal meaning. A **Metaphor** states that one thing IS another ('The sun was a golden coin'), while a **Simile** uses 'like' or 'as.' **Personification** gives human traits to non-human things ('The wind whispered'). These tools create 'Imagery,' allowing the reader to see, smell, or feel the story. They transform dry information into an emotional experience.", 
    "quizType": "figurative"
  },
  {
    "title": "Active vs. Passive Voice", 
    "sub": "Tone and Clarity", 
    "image": "assets/english/voice.png",
    "status": "locked", 
    "content": "In the **Active Voice**, the subject performs the action ('The chef prepared the meal'). This creates direct, energetic writing. In the **Passive Voice**, the subject receives the action ('The meal was prepared by the chef'). While passive voice is useful for scientific reports to emphasize the result over the person, active voice is usually preferred in storytelling because it is clearer and more engaging.", 
    "quizType": "voice_1"
  },
  {
    "title": "The Research Process", 
    "sub": "Evidence & Citations", 
    "image": "assets/english/research.webp",
    "status": "locked", 
    "content": "Informative writing requires credible evidence. This involves distinguishing between **Primary Sources** (firsthand accounts) and **Secondary Sources** (analysis by others). To avoid 'Plagiarism'—the theft of intellectual property—writers must use citations to credit their sources. This process builds 'Academic Integrity,' ensuring that your arguments are backed by verifiable facts and respected research.", 
    "quizType": "research"
  },
  {
    "title": "Diction and Tone", 
    "sub": "Word Choice",   
    "image": "assets/english/diction.webp",
    "status": "locked", 
    "content": "**Diction** refers to the specific choice of words. A writer might choose 'residence' for a formal tone or 'home' for an emotional one. This choice creates the **Tone**—the author's attitude toward the subject. By carefully selecting words with specific 'Connotations' (emotional associations), a writer can make a reader feel curious, angry, or peaceful without ever explicitly stating the emotion.", 
    "quizType": "diction"
  },
  ],

  "Arts": [
  {
    "title": "Elements of Design", 
    "sub": "The Visual Language", 
    "image": "assets/arts/elements_design.jpg",
    "status": "inProgress", 
    "content": "Visual art is built from seven core elements: **Line, Shape, Color, Value, Texture, Form, and Space.** A 'Line' can create a sense of movement, while 'Value' (the lightness or darkness of a color) creates the illusion of 3D depth on a 2D surface. By mastering these elements, an artist can guide the viewer’s eye and evoke specific emotions without using a single word. This 'Visual Language' is the foundation for everything from classical oil painting to modern graphic design.", 
    "quizType": "elements_1"
  },
  {
    "title": "Color Theory", 
    "sub": "The Science of Hue", 
    "image": "assets/arts/color_theory.webp",
    "status": "locked", 
    "content": "Color Theory is both a science and an art. It begins with the **Color Wheel**, which identifies Primary (Red, Blue, Yellow) and Secondary colors. Artists use 'Complementary Colors' (opposites like Blue and Orange) to create high contrast and energy, or 'Analogous Colors' (neighbors like Green and Blue) to create harmony. Beyond aesthetics, colors have 'Psychology'—Blue often represents calm or sadness, while Red can signal danger or passion. Understanding these relationships is vital for effective visual communication.", 
    "quizType": "color_1"
  },
  {
    "title": "Art Movements", 
    "sub": "Renaissance to Modern", 
    "image": "assets/arts/art_movements.jpg",
    "status": "locked", 
    "content": "Art history is a series of reactions. The **Renaissance** focused on realism and perspective. In response to the invention of the camera, **Impressionists** like Monet began capturing light and movement rather than perfect detail. Later, **Abstract Art** removed recognizable objects entirely, focusing on pure emotion and form. Each movement reflects the technology and social values of its time, proving that art is a mirror held up to the evolution of human society.", 
    "quizType": "movements_1"
  },
  {
    "title": "The World of Music", 
    "sub": "Rhythm & Harmony", 
    "image": "assets/arts/music.webp",
    "status": "locked", 
    "content": "Music is the art of organized sound. It relies on **Rhythm** (the timing of notes) and **Melody** (the sequence of pitches). When multiple notes are played together, they create **Harmony**, which can feel 'Consonant' (pleasant) or 'Dissonant' (tense). Every culture uses music differently—from the complex mathematical patterns of Western Classical music to the polyrhythmic traditions of African drumming. It is a universal language that communicates across borders through vibration and frequency.", 
    "quizType": "music_1"
  },
  {
    "title": "Sculpture & 3D Art", 
    "sub": "Subtractive vs Additive", 
    "image": "assets/arts/sculpture_3d.webp",
    "status": "locked", 
    "content": "Sculpture is art that exists in three dimensions. There are two primary methods: **Subtractive** (carving away material like marble or wood) and **Additive** (building up material like clay or bronze casting). Modern sculptors also use 'Installation Art' to transform entire rooms into an experience. Unlike a painting, a sculpture changes as you walk around it, forcing the viewer to interact with the art’s physical mass and the space it occupies.", 
    "quizType": "sculpt_1"
  },
  {
    "title": "The Digital Frontier", 
    "sub": "New Media & AI", 
    "image": "assets/arts/digital_art.webp",
    "status": "locked", 
    "content": "The definition of 'Art' is constantly expanding. **Digital Art** uses pixels instead of paint, allowing for infinite editing and new forms like 3D modeling and animation. Most recently, Artificial Intelligence and Virtual Reality have allowed creators to build immersive worlds. While the tools change—from charcoal sticks to computer code—the goal remains the same: to express the human experience and challenge the way we perceive the world around us.", 
    "quizType": "digital_art"
  },
  ],
  };

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the app in a listener so it rebuilds when the switch flips
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (_, ThemeMode currentMode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'READABLE',
          
          // DEFINE LIGHT MODE
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          ),
          
          // DEFINE DARK MODE
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.green,
            scaffoldBackgroundColor: const Color(0xFF121212),
          ),
          
          // TELL APP WHICH MODE TO USE
          themeMode: currentMode,
          
          home: const SplashScreen(),

          // Routes Table
          routes: {
            '/onboarding': (context) => const OnboardingScreen(),
            '/signin': (context) => const SignInScreen(),
            '/signup': (context) => const SignUpScreen(),
            '/home': (context) => const HomePage(),
            '/lessons': (context) => const LessonPage(),
            '/profile': (context) => const ProfilePage(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to Onboarding after 5 seconds
    Timer(const Duration(seconds: 5), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo.png',
              width: 250, 
              fit: BoxFit.contain, 
            ),
            const SizedBox(height: 30),
            const CircularProgressIndicator(color: Color(0xFF4A9F6A)),
          ],
        ),
      ),
    );
  }
}
