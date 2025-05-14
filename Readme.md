# Multi-Arduino Signal Transfer Hub

This repository contains Arduino and Processing codes that enable multiple Arduino boards to collect, store, and transfer signals to a single laptop through USB for further processing and analysis.

---

## Features
- **Multi-Arduino Connectivity**: Seamlessly connect and manage multiple Arduino boards.
- **Centralised Data Transfer**: Transfer all collected signals to a single laptop.
- **Integration with Processing**: Use Processing for data storing as a text file.

---

## Requirements
### Hardware:
- Multiple Arduino boards (e.g., Arduino Uno, Mega, etc.).
- USB cables for each Arduino board.

### Software:
- [Arduino IDE](https://www.arduino.cc/en/software) (for uploading sketches to Arduino boards).
- [Processing IDE](https://processing.org/download/) (for running visualisation or data-handling scripts).

---

## Installation

1. **Setup Arduino Sketches**:
   - Open the `Arduino/` folder.
   - Upload the appropriate sketch to each connected Arduino board using the Arduino IDE.

2. **Setup Processing Sketch**:
   - Open the `Processing/` folder.
   - Run the Processing script using the Processing IDE.

---

## Usage
1. Connect all Arduino boards to the laptop using USB cables.
2. Start the Processing script to initialise communication with all Arduino boards.
3. Click on the "Start" button, and wait for 15 seconds till the storage is finished. 
4. All data will be stored as text files. 

---
## FAQ

1. **Why 15 sec?**
   This is what the Arduino UNO R4 is capable of storing with a sampling frequency of 250Hz. If you are using an older version with smaller dynamic memory, you might need to change it. In that case, make sure to update the following:

   - In the Arduino sketch:
     ```cpp
     // Define constants
     const int TIMEINTREVAL = 15; // seconds
     const int FS = 250; // Sampling frequency in Hz
     ```
   - In the Processing file:
     ```java
     final int TIMEINTREVAL = 15; // seconds
     final int FS = 250; // Sampling frequency in Hz
     ```

2. **Why store the data first instead of sending it immediately?**
   To maintain a stable sampling rate. Transferring data through the serial port can influence the sampling frequency, leading to instability.

3. **Possible applications?**
   For example, you can connect two ECG modules and create a 15-second 6-lead ECG.

4. **How Can I set the number of connected boards?**
   in the pde file adjust:
   
   ```java
   //Initialise the arrays
   int numPorts = 3; // Adjust if you want more or fewer Arduinos
   ```
