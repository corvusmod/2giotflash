# OPi2-IOT-NAND
Script to flash OrangePi-2G-IOT with custom linux image.  
Script based fully on work of Orhan Kavrakoğlu (https://www.aib42.net/article/hacking-orangepi-2g).  
My only contribution is merging it in a script and adding WiFi script.  
  
Tested on Armbian image  
Steps:  
1. Set debug selector switch on 1-4: Up, 5-8: Down
2. Push powerbutton down
3. Connect to computer via USB
4. Start the scipt with root privileges
5. Wait till script is done
6. Disconnect and connect again OPi to provide power from USB
7. Wait 2-3 minutes to startup
8. It should be connected to WiFi now
9. Connect via SSH using root:orangepi
