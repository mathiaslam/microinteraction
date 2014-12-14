import controlP5.*;
import com.onformative.yahooweather.*;

ControlP5 cp5;
CheckBox checkboxdark;
CheckBox checkboxrain;
int myColorBackground;

PFont font16;

boolean comfort;
boolean cRaining;
boolean cTemperature;

YahooWeather weather;
int updateIntervallMillis = 30000; 

color answer = color(100, 100, 100);


//Setting up your Comfort zone
int cMaxTemp;
int cMinTemp;
boolean cRain;
boolean cDark;


int colorMin = 100;

int colorMax = 100;

Range range;

void setup() {
  size(1000, 600);
  fill(0);

  // textFont(createFont(»Arial«, 14));
  // 638242= the WOEID of Berlin
  // use this site to find out about your WOEID : http://sigizmund.info/woeidinfo/
  weather = new YahooWeather(this, 641142, "c", updateIntervallMillis);

  //Checkbox
  smooth();
  cp5 = new ControlP5(this);
  checkboxdark = cp5.addCheckBox("checkBoxdark")
    .setPosition(20, 20)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(10, 10)
              .setItemsPerRow(3)
                .setSpacingColumn(30)
                  .setSpacingRow(20)
                    .addItem("yes/no", 0)
                      ;


  //Checkbox
  smooth();
  cp5 = new ControlP5(this);
  checkboxrain = cp5.addCheckBox("checkBoxrain")
    .setPosition(20, 40)
      .setColorForeground(color(120))
        .setColorActive(color(255))
          .setColorLabel(color(255))
            .setSize(10, 10)
              .setItemsPerRow(3)
                .setSpacingColumn(30)
                  .setSpacingRow(20)
                    .addItem("yes/no", 0)
                      ;                    


  cp5 = new ControlP5(this);
  range = cp5.addRange("rangeController")
    // disable broadcasting since setRange and setRangeValues will trigger an event
    .setBroadcast(false) 
      .setPosition(300, 150)
        .setSize(200, 20)
          .setHandleSize(20)
            .setRange(-15, 45)
              .setRangeValues(5, 30)
                // after the initialization we turn broadcast back on again
                .setBroadcast(true)
                  .setColorForeground(color(255, 40))
                    .setColorBackground(color(255, 40))  
                      .setNumberOfTickMarks(5)
                        ;

  noStroke();
}

void draw() {
  weather.update();



  background(0);
  fill(255);
  text("Temperature: "+weather.getTemperature(), 20, 120);
  text("Condition: "+weather.getWeatherCondition(), 20, 140);



  text("City: "+weather.getCityName()+" Region: "+weather.getRegionName()+" Country: "+weather.getCountryName()+" Last updated: "+weather.getLastUpdated(), 250, 20);
  text("Lon: "+weather.getLongitude()+" Lat: "+weather.getLatitude(), 250, 40);
  text("WindTemp: "+weather.getWindTemperature()+" WindSpeed: "+weather.getWindSpeed()+" WindDirection: "+weather.getWindDirection(), 250, 60);
  text("Humidity: "+weather.getHumidity()+" Visibility: "+weather.getVisibleDistance()+" pressure: "+weather.getPressure()+" rising: "+weather.getRising(), 250, 80);
  text("Sunrise: "+weather.getSunrise()+" Sunset: "+weather.getSunset(), 250, 100);





  fill(answer);

  rect(0, 300, 1000, 300);
  fill(255);
  comfortCheck();
}

void controlEvent(ControlEvent theControlEvent) {
  if (theControlEvent.isFrom("rangeController")) {
    // min and max values are stored in an array.
    // access this array with controller().arrayValue().
    // min is at index 0, max is at index 1.
    cMinTemp  = int(theControlEvent.getController().getArrayValue(0));
    cMaxTemp = int(theControlEvent.getController().getArrayValue(1));
    println("range update, done.");
  }



  if (theControlEvent.isFrom(checkboxdark)) {

    print("got an event from "+checkboxdark.getName()+"\t\n");
    // checkbox uses arrayValue to store the state of 
    // individual checkbox-items. usage:
    println(checkboxdark.getArrayValue());

    for (int i=0; i<checkboxdark.getArrayValue ().length; i++) {
      int n = (int)checkboxdark.getArrayValue()[i];
      print(n);
      if (n==1) {
        cDark = true;
      } else {
        cDark = false;
      }
    }
    println();
  }

  if (theControlEvent.isFrom(checkboxrain)) {

    print("got an event from "+checkboxrain.getName()+"\t\n");
    // checkbox uses arrayValue to store the state of 
    // individual checkbox-items. usage:
    println(checkboxrain.getArrayValue());

    for (int i=0; i<checkboxrain.getArrayValue ().length; i++) {
      int n = (int)checkboxrain.getArrayValue()[i];
      print(n);
      if (n==1) {
        cRain = true;
      } else {
        cRain = false;
      }
    }
    println();
  }
}


void comfortCheck() {
  dark();
  raining();
  temperature();
  rain();

  if ((cRaining == true) || (cTemperature == false)) {
    comfort = false;
  } else {
    comfort = true;
  }

  text("should I take a run?", 20, 180);
  if (comfort == true) {
    text("yes", 20, 195);
    textSize(200);
    text("yes", 320, 500);
    textSize(12);


    answer = color(100, 250, 100);
  } else {
    text("no", 20, 195);
    textSize(200);
    text("nope", 250, 500);
    textSize(12);

    answer = color(250, 100, 100);
  }
}

void raining() {
  boolean raining;
  int comfortcode = weather.getWeatherConditionCode();

  //int comfortcode = 13;
  if ((comfortcode <= 13) && (comfortcode >= 8) ) {
    cRaining = true;
  } else {
    cRaining = false;
  }
  text("is it raining?", 20, 220);
  if (cRaining == true) {
    text("yes", 20, 235);
  } else {
    text("no", 20, 235);
  }
}

void temperature() {
  int actualTemp = weather.getTemperature();
  text("what temperature is it?", 150, 220);
  text(actualTemp, 150, 235);

  text("is it in my comfortzone?", 150, 260);
  if (actualTemp > cMinTemp && actualTemp <cMaxTemp) {
    text("yes", 150, 275);
    cTemperature = true;
  } else {
    text("nope", 150, 275);
    cTemperature = false;
  }
}

void dark() {

  //int actualTemp = weather.getTemperature();
  text("do you like to run while it's dark?", 350, 220);
  if (cDark == true) {
    text("yes", 350, 235);
    //cTemperature = true;
  } else {
    text("nope", 350, 235);
  }
}

void rain() {

  //int actualTemp = weather.getTemperature();
  text("do you like to run while it's raining", 350, 260);
  if (cRain == true) {
    text("yes", 350, 275);
    //cTemperature = true;
  } else {
    text("nope", 350, 275);
  }
}

public void keyPressed() {
  if (key == 'b') {
    weather.setWOEID(641142);
  }
  if (key == 'l') {
    weather.setWOEID(44418);
  }

  if (key == 'r') {
    weather.setWOEID(44418);
  }
}

