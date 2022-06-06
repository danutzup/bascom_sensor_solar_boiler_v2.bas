$regfile = "m16def.dat"                                     '
$crystal = 8000000                                          '
$hwstack = 80
$swstack = 60
$framesize = 64
$baud = 9600
Config Lcdpin = Pin , Db4 = Portb.4 , Db5 = Portb.5 , Db6 = Portb.6 , Db7 = Portb.7 , E = Portb.0 , Rs = Portb.2
Config Lcd = 16 * 2
Ddrd = &B11000000                                           ' PD7,PD6  output, PD0...PD5 are input
Portd = &B00111111                                          ' enable PD0...PD5 pull-up resistor enable

Config Adc = Single , Prescaler = Auto , Reference = Internal
Start Adc
Config Single = Scientific , Digits = 1
Dim Zet1 As Word , Zet2 As Word , Zet3 As Single , Zet4 As Single , Zet5 As Single
Dim T As Word
T = 0

Config Portd.6 = Output
Reset Portd.6
Config Portd.7 = Output
Reset Portd.7
On Timer1 Timer1_irq
Config Timer1 = Timer , Prescale = 256
Enable Timer1
Start Timer1
Cursor Off
Cls
Home                                                        'clear the LCD display
Lcd "Senzor panou  v2"
Lowerline
Lcd "solar si boiler "
Wait 3
Cls
Enable Interrupts

Do
'-----------------------
 Zet1 = Getadc(0)
 Waitms 4
 Zet2 = Getadc(1)
 Waitms 4

'--------------------------------
' Waitms 100
'--------------------------------
  Zet3 = Zet1 * 2.56
  Zet3 = Zet3 / 1024
  Zet3 = Zet3 - 0.5
  Zet3 = Zet3 * 100
  Zet4 = Zet2 * 2.56
  Zet4 = Zet4 / 1024
  Zet4 = Zet4 - 0.5
  Zet4 = Zet4 * 100
'--------------------------------

Zet5 = Zet3 + 2
If T > 10000 Then                                           'maximum  65536
   T = 0
   Timer1 = 0
End If

If T = 9999 Then
      If Zet4 > Zet5 Then
         Set Portd.6
      Else
         Reset Portd.6
      End If
End If

 Locate 1 , 1
 Lcd "Panou s =" ; Zet4
 Locate 1 , 16
 Lcd "C"
 Locate 2 , 1
 Lcd "Boiler  =" ; Zet3
 Locate 2 , 16
 Lcd "C"
Print "<" ; Zet3 ; "," ; Zet4 ; ">"
Wait 10


Loop
End

'-------------------------------------
Timer1_irq:
  T = T + 1
Return