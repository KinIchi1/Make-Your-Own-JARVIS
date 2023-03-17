# Make-Your-Own-JARVIS
b.o.b Code

#include <SD.h>
#include <SPI.h>
#include <SoftwareSerial.h>
#include <TMRpcm.h>
#include <SimpleVR.h>

TMRpcm tmrpcm;
VR myVR(2,3);
//SoftwareSerial mySerial(0,1); //RX, TX
uint8_t buf[64];
bool acknowledge = false;
bool acknowledge2 = false;
bool tuneIn = true;
//int resetPin = 8;
//String line;
//String wrd = "kinIchi1";
//File myfile;



void setup() {
  myVR.begin(9600);           //initialize voice recognition module
  Serial.begin(115200);       //initialize sd card
  pinMode(5,OUTPUT);          //set pin for relay
  digitalWrite(5, HIGH);      //tells the relay to turn off
  tmrpcm.speakerPin = 9;      //set pin for speaker
  while(!Serial){
    }
  Serial.print("Initializing SD Card...");
  if(!SD.begin(10)){
    Serial.println("Initialization Failed!");
    return;
    }
  Serial.println("Initialization done");
  tmrpcm.setVolume(5);        //set audio volume
  //tmrpcm.play("MCU.WAV");   //test audio
  if (myVR.checkVersion(buf) > 0){        //connects to voice recognition module
    Serial.println("SimpleVR Connected");
    myVR.setEnable(true);
    myVR.setGroup(2);
    }
  // findWord(wrd);           //code for speech synthesis
}  


void loop(){
    Serial.println("Test");
    int ret;        
    uint16_t voice=0;
    ret = myVR.recognize(buf, 50);      //takes voice input
    if(ret > 0){
    voice += buf[0];
    voice <<=8;
    voice += buf[1];
    
    if (voice == 1 && acknowledge == false && acknowledge2 == false){          //checks the value of voice and acknowledgements
      Serial.println(F("Otis"));
      delay(1000);
      tmrpcm.play("BAYSS.WAV");
      myVR.setGroup(1);                                 //sets group to the group with commands
      acknowledge = true;
      delay(3000);
      //tmrpcm.stopPlayback();
      tuneIn = false;
     
      }else { 
      
      switch(voice){
      case 1:
      if(acknowledge == true && acknowledge2 == false && tuneIn == true){
        digitalWrite(5, LOW);
        Serial.println(F("lights"));
        delay(1000);
        myVR.setGroup(2);
        tmrpcm.play("BYS.WAV");
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }else if(acknowledge == true && acknowledge2 == true && tuneIn == true){
        Serial.println(F("playing lofi"));
        myVR.setGroup(2);
        tmrpcm.play("lofi.WAV", 30);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 2:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      digitalWrite(5, HIGH); 
      Serial.println(F("turn off lights"));
      delay(1000);
      tmrpcm.play("BAYW.WAV");
      acknowledge = false;
      acknowledge2 = false;
      myVR.setGroup(2);
      delay(3000);
      }else if (acknowledge == true && acknowledge2 == true && tuneIn == true){
        Serial.println(F("playing r&b"));
        myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 3:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("power on"));
      acknowledge = false;
      myVR.setGroup(2);
      delay(3000);
      }else if (acknowledge == true && acknowledge2 == true && tuneIn == true){
       Serial.println(F("playing smooth jazz"));
       myVR.setGroup(2);
       acknowledge = false;
       acknowledge2 = false;
       delay(3000);
      }
      break;



      case 4:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      pinMode(8, OUTPUT);
      Serial.println(F("shut down power"));
       delay(1000);
      tmrpcm.play("BPWYW.WAV");
      delay(7000);
      digitalWrite(5, HIGH); 
      digitalWrite(8, LOW);
      }else if (acknowledge == true && acknowledge2 == true && tuneIn == true){
        Serial.println(F("playing rock"));
        myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 5:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("hello cheyenne"));
      tmrpcm.play("BHBD.WAV");
      acknowledge = false;
      delay(5000);
      myVR.setGroup(2);
      }else if (acknowledge == true && acknowledge2 == true && tuneIn == true){
        Serial.println(F("pausing"));
        tmrpcm.pause();
        myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 6:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("play music"));
      delay(1000);
      tmrpcm.play("BWM.WAV");
      myVR.setGroup(3);
      acknowledge2 = true;
      delay(3000);
      }else if (acknowledge == true && acknowledge2 == true && tuneIn == true){
        Serial.println(F("resuming"));
        myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 7:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("date"));
      myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;



      case 8:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("command 8"));
      myVR.setGroup(2);
      acknowledge = false;
      acknowledge2 = false;
      delay(1000);
      }
      break;



      case 9:
      if (acknowledge == true && acknowledge2 == false && tuneIn == true){
      Serial.println(F("command 9"));
      myVR.setGroup(2);
        acknowledge = false;
        acknowledge2 = false;
        delay(3000);
      }
      break;
    }
    tuneIn = true;
  }
 }
}
