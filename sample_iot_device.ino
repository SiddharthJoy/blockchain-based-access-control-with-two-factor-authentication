/* 
Libraries used:- 
https://github.com/mobizt/Firebase-ESP8266/
*/

#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>
                          
#define FIREBASE_HOST "project-****-default-rtdb.firebaseio.com"     //Your Firebase Project URL goes here without "http:" , "\" and "/"
#define FIREBASE_AUTH "hEZLG22ZTE*********yMYXBfe9m4sQWzXwP5m"     //Your Firebase Database Secret goes here

#define WIFI_SSID "XXXXXXXXXXXXX"
#define WIFI_PASSWORD "987654321"                                  //Password of your wifi network 
#define ON "on"
#define OFF "off"
 
  

// Declare the Firebase Data object in the global scope
FirebaseData firebaseData;

void setup() {

  Serial.begin(115200);                                   
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

     
  val = digitalRead(D8);
  String response;

  val = Firebase.getString(firebaseData, "/LED");
  if(val){
    if (firebaseData.dataTypeEnum() == fb_esp_rtdb_data_type_string) {
      response = firebaseData.to<String>();
    }
  }
  
  if (response == "on") {    // On successful Write operation, function returns 1 
     digitalWrite(D8, HIGH);
     delay(1000);
  
  }  
  else digitalWrite(D8, LOW);        
  
}


/* NOTE:
 *  To upload value, command is ===> Firebase.setInt(firebaseData, "path", variable);
 *  Example                     ===>  Firebase.setInt(firebaseData, "/data", val);
 */
       
