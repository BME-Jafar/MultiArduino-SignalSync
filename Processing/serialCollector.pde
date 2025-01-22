// Import the Processing Serial library
import processing.serial.*;
import controlP5.*; // Import the ControlP5 library for GUI

Serial[] myPorts;             // Array to store the serial ports
PrintWriter[] outputFiles;    // Array to store file writers for each Arduino
ControlP5 cp5;                // GUI library object

boolean isReceiving = false;  // Flag to indicate if data is being received
String statusText = "Ready to receive data";
int[] sampleCounts;           // Array to keep track of sample counts for each Arduino
final int TIMEINTREVAL = 15; //seconds
final int FS = 250; // Sampling frequency in Hz
final int MAX_SAMPLES = TIMEINTREVAL * FS; // Maximum number of samples to receive from each Arduino

void setup() {
  // Set up the size of the window
  size(400, 200);

  // Initialize ControlP5 for GUI
  cp5 = new ControlP5(this);

  // Add a button to start/stop data reception
  cp5.addButton("toggleReception")
     .setPosition(150, 80)
     .setSize(100, 30)
     .setLabel("Start");

  // List all the available serial ports
  println("Available serial ports:");
  println(Serial.list());

  // Initialize the arrays
  int numPorts = 3; // Adjust if you want more or fewer Arduinos
  myPorts = new Serial[numPorts];
  outputFiles = new PrintWriter[numPorts];
  sampleCounts = new int[numPorts];

  // Open serial ports for the first three available ports
  for (int i = 0; i < numPorts; i++) {
    String portName = Serial.list()[i]; // Update indices as needed for your setup
    myPorts[i] = new Serial(this, portName, 115200);
    outputFiles[i] = createWriter("XYZ_data_arduino_trailTwo_" + i + ".txt");
    sampleCounts[i] = 0; // Initialize sample counts
  }

  // Print a message to indicate setup is complete
  println("Ready to receive data from " + numPorts + " Arduinos");
}

void draw() {
  // Set background and draw status text
  background(200);
  fill(0);
  textSize(16);
  textAlign(CENTER);
  text(statusText, width / 2, 50);

  // Check if data is available on the serial ports and reception is enabled
  if (isReceiving) {
    for (int i = 0; i < myPorts.length; i++) {
      if (sampleCounts[i] < MAX_SAMPLES+1) {
        while (myPorts[i].available() > 0) {
          // Read a line of data from the serial port
          String data = myPorts[i].readStringUntil('\n');

          if (data != null) {
            // Trim any whitespace or newline characters
            data = trim(data);

            // Write the data to the file
            outputFiles[i].println(data);

            // Increment the sample counter
            sampleCounts[i]++;

            // Stop receiving from this Arduino if the maximum number of samples is reached
            if (sampleCounts[i] >= MAX_SAMPLES) {
              println("Arduino " + i + " reception complete. Data saved.");
            }
          }
        }
      }
    }

    // Check if all Arduinos are done
    boolean allDone = true;
    for (int count : sampleCounts) {
      if (count < MAX_SAMPLES) {
        allDone = false;
        break;
      }
    }

    if (allDone) {
      isReceiving = false;
      statusText = "Reception stopped. Data saved.";
      for (PrintWriter file : outputFiles) {
        file.close();
      }
      println("All data saved.");
    }
  }
}

// Function called when the button is pressed
void toggleReception() {
  if (!isReceiving) {
    isReceiving = true;
    for (int i = 0; i < myPorts.length; i++) {
      sampleCounts[i] = 0; // Reset the sample counter for each Arduino
    }
    statusText = "Receiving data...";
    for (Serial port : myPorts) {
      port.write("S"); // Send start command to each Arduino
    }
    String timestamp = nf(hour(), 2) + ":" + nf(minute(), 2) + ":" + nf(second(), 2);
    for (PrintWriter file : outputFiles) {
      file.println(timestamp);
    }
  } else {
    isReceiving = false;
    statusText = "Reception stopped.";
    for (PrintWriter file : outputFiles) {
      file.close();
    }
    println("Data saved.");
  }
}

void keyPressed() {
  // Close all files when a key is pressed
  for (PrintWriter file : outputFiles) {
    file.close();
  }
  println("Data saved.");
  exit();
}