// Define constants
const int TIMEINTREVAL = 15; //seconds
const int FS = 250; // Sampling frequency in Hz
const int N = TIMEINTREVAL * FS; // Number of samples


// Calculate sampling interval in microseconds
const unsigned long samplingInterval = 1000000 / FS;

// Array to store ADC samples
int samples[N];

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Wait for the serial port to connect (useful for debugging on some boards)
  while (!Serial);

  while (!Serial.available());

    // Take N samples at the specified sampling frequency
  for (int i = 0; i < N; i++) {
    samples[i] = analogRead(A0); // Read from ADC (e.g., pin A0)
    delayMicroseconds(samplingInterval); // Wait for the next sampling interval
  }

  // Send the samples to the serial port
  for (int i = 0; i < N; i++) {
    Serial.println(samples[i]);
  }
}

void loop() {

}
