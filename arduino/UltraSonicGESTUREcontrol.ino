 int potPin = A2;  
 // select the input pin for the potentiometer
int ledPin1 = 12;
int ledPin2 = 11;

int ledPin = 13;   // select the pin for the LED
int val1 = 0;       // variable to store the value coming from the sensor
char x;

int echoPin= 2;
int triggerPin= 3;
unsigned long pulsetime = 0;
unsigned distance =0;
unsigned OldDistance =0;


void setup() {

   pinMode (echoPin, INPUT);
  pinMode (triggerPin, OUTPUT);
  pinMode(ledPin, OUTPUT); 
  pinMode(ledPin1, OUTPUT);
  pinMode(ledPin2, OUTPUT);
  Serial.begin(9600);
  // declare the ledPin as an OUTPUT
  x = 1;
  val1 = analogRead(potPin);
  if(val1 > 512)
  Serial.println('1');
  else
  Serial.println('0');
   
delay(50);
x = Serial.read();
 if( x == '0')
    { digitalWrite(ledPin , HIGH);}
}

void loop()
{
  
  //compute the distance. Thanks for the ready-made code examples !!
  digitalWrite(triggerPin, LOW);
  delayMicroseconds(100);
  digitalWrite(triggerPin, HIGH);
  delayMicroseconds(100);
  digitalWrite(triggerPin, LOW);
  pulsetime = pulseIn(echoPin, HIGH);
  distance = pulsetime / 58;
  delay(10);



 Serial.println(distance);
  if ( distance > 18)
  {
     digitalWrite(ledPin1 , HIGH);
      digitalWrite(ledPin2 , LOW);
    }
    else
    { digitalWrite(ledPin2 , HIGH);
     digitalWrite(ledPin1 , LOW);
    }
    

  delay(50); 
   
  
   
 

}
