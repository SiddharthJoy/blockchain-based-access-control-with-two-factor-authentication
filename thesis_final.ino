/*  
Libraries used:- 
https://github.com/mobizt/Firebase-ESP8266/
*/

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
                          
#define FIREBASE_HOST "project-ce84f-default-rtdb.firebaseio.com"                     //Your Firebase Project URL goes here without "http:" , "\" and "/"
#define FIREBASE_AUTH "hEZLG22ZTE0JnF0HWZa5tyMYXBfe9m4sQWzXwP5m" //Your Firebase Database Secret goes here

#define WIFI_SSID "Jun_Sparking"
#define WIFI_PASSWORD "emergency 786"                                  //Password of your wifi network 
#define ON "on"
#define OFF "off"
 
  

// Declare the Firebase Data object in the global scope
FirebaseData firebaseData;

// Declare global variable to store value
int val=0;



void setup() {

  Serial.begin(115200);                                   // Select the same baud rate if you want to see the datas on Serial Monitor

  Serial.println("Serial communication started\n\n");  
           
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);                                     //try to connect with wifi
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);


  
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());                                            //print local IP address
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);   // connect to firebase

  Firebase.reconnectWiFi(true);

  const int led_pin = D8;
  
  pinMode(led_pin, OUTPUT); 

  
  delay(1000);
}

void loop() { 

// Firebase Error Handling And Writing Data At Specifed Path************************************************

  digitalWrite(D8, HIGH);   
  val = digitalRead(D8);

if (Firebase.setString(firebaseData, "/LED", ON)) {    // On successful Write operation, function returns 1  
               Serial.println("Value Uploaded Successfully");
               Serial.print("Val = ");
               Serial.println(val);
               Serial.println("\n");
               
               val++;
               delay(1000);

     }

else {        
    Serial.println(firebaseData.errorReason());
  }

  digitalWrite(D8, LOW);
  //delay(5000);

  if (Firebase.setString(firebaseData, "/LED", OFF)) {    // On successful Write operation, function returns 1  
               Serial.println("Value Uploaded Successfully");
               Serial.print("Val = ");
               Serial.println(val);
               Serial.println("\n");
               
               val++;
               delay(1000);

     }

else {        
    Serial.println(firebaseData.errorReason());
  }

}


/* NOTE:
 *  To upload value, command is ===> Firebase.setInt(firebaseData, "path", variable);
 *  Example                     ===>  Firebase.setInt(firebaseData, "/data", val);
 */
       
