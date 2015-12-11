#include <Servo.h>
#include <U8glib.h>
#include <string.h>

//LCD
const int LCD_SS[2] = {7, 8};
const int LCD_SCLK = 13;
const int LCD_RS = 9;
const int LCD_MOSI = 11;

//ADC
const int ADC_SIG[2] = {0, 1};

//full color LED
const int FC_LED_RED = 16;
const int FC_LED_BLUE = 17;
const int FC_LED_GREEN = 18;

enum {
    NONE = 0,
    GREEN,
    SKYBLUE,
    BLUE,
    PURPLE,
    RED,
    YELLOW,
    WHITE,
} LEDColor;

//motor
const int MOTOR_VREF[2] = {3, 6};
const int MOTOR_IN1[2] = {2, 5};
const int MOTOR_IN2[2] = {19, 4};

enum {
    GO = 0,
    BACK,
    RIGHT,
    LEFT,
    FREE,
} MotorMove;

//servo
const int SERVO_SIG = 10;

//global object
U8GLIB_NHD_C12864 LCDL(LCD_SCLK, LCD_MOSI, LCD_SS[0], LCD_RS);
U8GLIB_NHD_C12864 LCDR(LCD_SCLK, LCD_MOSI, LCD_SS[1], LCD_RS);
Servo servo;

void setupLCD(void)
{
    LCDL.setContrast(0);
    LCDL.setRot180();
    LCDL.setColorIndex(1);
    LCDL.setFont(u8g_font_unifont);
    LCDR.setContrast(0);
    LCDR.setRot180();
    LCDR.setColorIndex(1);
    LCDR.setFont(u8g_font_unifont);
}

void setupADC(void)
{
}

int getADC(int c)
{
    if (c < 0 || c > 2)
        return -1;
    int a_in;
    int distance;
    a_in = analogRead(0);
    distance = (6762 / (a_in - 9)) - 4;
    return distance;
}

void setupFCLED(void)
{
    pinMode(FC_LED_RED, OUTPUT);
    pinMode(FC_LED_BLUE, OUTPUT);
    pinMode(FC_LED_GREEN, OUTPUT);
}

void lightFCLED(int c)
{
    switch (c) {
    case NONE:
        digitalWrite(FC_LED_RED, LOW);
        digitalWrite(FC_LED_BLUE, LOW);
        digitalWrite(FC_LED_GREEN, LOW);
        break;
    case GREEN:
        digitalWrite(FC_LED_RED, LOW);
        digitalWrite(FC_LED_BLUE, LOW);
        digitalWrite(FC_LED_GREEN, HIGH);
        break;
    case YELLOW:
        digitalWrite(FC_LED_RED, HIGH);
        digitalWrite(FC_LED_BLUE, LOW);
        digitalWrite(FC_LED_GREEN, HIGH);
        break;
    case BLUE:
        digitalWrite(FC_LED_RED, LOW);
        digitalWrite(FC_LED_BLUE, HIGH);
        digitalWrite(FC_LED_GREEN, LOW);
        break;
    case PURPLE:
        digitalWrite(FC_LED_RED, HIGH);
        digitalWrite(FC_LED_BLUE, HIGH);
        digitalWrite(FC_LED_GREEN, LOW);
        break;
    case RED:
        digitalWrite(FC_LED_RED, HIGH);
        digitalWrite(FC_LED_BLUE, LOW);
        digitalWrite(FC_LED_GREEN, LOW);
        break;
    case SKYBLUE:
        digitalWrite(FC_LED_RED, HIGH);
        digitalWrite(FC_LED_BLUE, LOW);
        digitalWrite(FC_LED_GREEN, HIGH);
        break;
    case WHITE:
        digitalWrite(FC_LED_RED, HIGH);
        digitalWrite(FC_LED_BLUE, HIGH);
        digitalWrite(FC_LED_GREEN, HIGH);
        break;
    }
    return;
}

//void setupLED(void)
//{
//    for (int i = 0; i < 2; i++)
//        pinMode(LED_SIG[i], OUTPUT);
//}
//
//void turnOnLED(int c)
//{
//    if (c < 0 || c > 2)
//        return;
//    digitalWrite(LED_SIG[c], HIGH);
//}
//
//void turnOffLED(int c)
//{
//    if (c < 0 || c > 2)
//        return;
//    digitalWrite(LED_SIG[c], HIGH);
//}

void setupServo(void)
{
    servo.attach(SERVO_SIG);
}

void moveServo(int degree)
{
    if (degree < 0 || degree > 180)
        return;
    servo.write(degree);
}

void setupMotor(void)
{
    for (int i = 0; i < 2; i++) {
        pinMode(MOTOR_VREF[i], OUTPUT);
        pinMode(MOTOR_IN1[i], OUTPUT);
        pinMode(MOTOR_IN2[i], OUTPUT);
        digitalWrite(MOTOR_IN1[i], LOW);
        digitalWrite(MOTOR_IN2[i], LOW);
        analogWrite(MOTOR_VREF[i], 0);
    }
}

void moveMotor(int c)
{
    if (getADC(0) > 15 && getADC(1) > 15) {
        c = BACK;
    } else if (getADC(0) > 15) {
        c = LEFT;
    } else if (getADC(1) > 15) {
        c = RIGHT;
    }
    const int POWER = 255;
    switch (c) {
    case GO:
        digitalWrite(MOTOR_IN1[0], HIGH);
        digitalWrite(MOTOR_IN2[0], LOW);
        analogWrite(MOTOR_VREF[0], POWER);
        digitalWrite(MOTOR_IN1[1], HIGH);
        digitalWrite(MOTOR_IN2[1], LOW);
        analogWrite(MOTOR_VREF[1], POWER);
        break;
    case BACK:
        digitalWrite(MOTOR_IN1[0], LOW);
        digitalWrite(MOTOR_IN2[0], HIGH);
        analogWrite(MOTOR_VREF[0], POWER);
        digitalWrite(MOTOR_IN1[1], LOW);
        digitalWrite(MOTOR_IN2[1], HIGH);
        analogWrite(MOTOR_VREF[1], POWER);
        break;
    case RIGHT:
        digitalWrite(MOTOR_IN1[0], LOW);
        digitalWrite(MOTOR_IN2[0], HIGH);
        analogWrite(MOTOR_VREF[0], POWER);
        digitalWrite(MOTOR_IN1[1], HIGH);
        digitalWrite(MOTOR_IN2[1], LOW);
        analogWrite(MOTOR_VREF[1], POWER);
        break;
    case LEFT:
        digitalWrite(MOTOR_IN1[0], HIGH);
        digitalWrite(MOTOR_IN2[0], LOW);
        analogWrite(MOTOR_VREF[0], POWER);
        digitalWrite(MOTOR_IN1[1], LOW);
        digitalWrite(MOTOR_IN2[1], HIGH);
        analogWrite(MOTOR_VREF[1], POWER);
        break;
    case FREE:
        digitalWrite(MOTOR_IN1[0], LOW);
        digitalWrite(MOTOR_IN2[0], LOW);
        analogWrite(MOTOR_VREF[0], POWER);
        digitalWrite(MOTOR_IN1[1], LOW);
        digitalWrite(MOTOR_IN2[1], LOW);
        analogWrite(MOTOR_VREF[1], POWER);
        break;
    }
}

void controlMotor()
{
    static int cnt = 0;
    int c = FREE;
    if (cnt > 0) {
        if (getADC(0) > 9 && getADC(1) > 9) {
            c = BACK;
        } else if (getADC(0) > 9) {
            c = LEFT;
        } else if (getADC(1) > 9) {
            c = RIGHT;
        } else {
            c = FREE;
            cnt = 0;
        }
        moveMotor(c);
    } else {
        if (getADC(0) > 9 && getADC(1) > 9) {
            c = BACK;
        } else if (getADC(0) > 9) {
            c = LEFT;
        } else if (getADC(1) > 9) {
            c = RIGHT;
        }
        if (c != FREE) {
            moveMotor(c);
            cnt++;
        }
    }
}

void setup()
{
    Serial.begin(9600);
    setupLCD();
    setupADC();
    setupFCLED();
    //setupLED();
    setupMotor();
    setupServo();
    delay(1000);
}

char mode = 'n';
int modecnt = -1;
int modecntlim = -1;
char buffer[33];

void mainloop(void)
{
    char c = buffer[0];
    char buf1[17];
    strncpy(buf1, buffer + 1, 16);
    buf1[16] = '\0';
    char buf2[17];
    strncpy(buf2, buffer + 1 + 16, 16);
    buf2[16] = '\0';
    switch (mode) {
    case 'l': {
        if (c == 's') {
            LCDL.firstPage();
            do {
                LCDL.drawStr(0, 40, buf1);
                LCDL.drawStr(0, 60, buf2);
            } while (LCDL.nextPage());
        }
        break;
    }
    case 'r': {
        if (c = 's') {
            LCDR.firstPage();
            do {
                LCDR.drawStr(0, 40, buf1);
                LCDR.drawStr(0, 60, buf2);
            } while (LCDR.nextPage());
        }
        break;
    }
    case 'm': {
        switch (c) {
        case 'g':
            moveMotor(GO);
            break;
        case 'b':
            moveMotor(BACK);
            break;
        case 'r':
            moveMotor(RIGHT);
            break;
        case 'l':
            moveMotor(LEFT);
            break;
        case 'f':
            moveMotor(FREE);
            break;
        }
        break;
    }
    case 's': {
        moveServo(c);
        break;
    }
    case 'e': {
        //if ((c >> 3) & 1)
        //    turnOnLED(0);
        //else
        //    turnOffLED(0);
        //if ((c >> 4) & 1)
        //    turnOnLED(1);
        //else
        //    turnOffLED(1);
        lightFCLED(c);
        break;
    }
    }
}

void loop()
{
    controlMotor();
    if (Serial.available() > 0) {
        unsigned char c = Serial.read();
        Serial.write(c);
        if (mode == 'n') {
            switch (c) {
            case 'l':
                mode = c;
                modecnt = 0;
                modecntlim = 33;
                break;
            case 'r':
                mode = c;
                modecnt = 0;
                modecntlim = 33;
                break;
            case 'm':
                mode = c;
                modecnt = 0;
                modecntlim = 1;
                break;
            case 's':
                mode = c;
                modecnt = 0;
                modecntlim = 1;
                break;
            case 'e':
                mode = c;
                modecnt = 0;
                modecntlim = 1;
                break;
            }
            return;
        } else {
            buffer[modecnt] = c;
            modecnt++;
        }
        if (modecnt == modecntlim) {
            Serial.write("\n");
            Serial.write(mode);
            Serial.write(" : ");
            Serial.write(buffer);
            Serial.write("\n");
            mainloop();
            mode = 'n';
            modecnt = -1;
            modecntlim = -1;
            memset(buffer, -1, sizeof(buffer));
        }
    }
}
