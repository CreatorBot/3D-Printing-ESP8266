--'
-- CreatorBot ESP8266 WIFI SSID & Password serial reset 
-- Author: Chetan Patil.
-- LICENCE: http://opensource.org/licenses/MIT
-- Last modified 2015-01-03. V0.0
-- CreatorBot.com
--' 

uart.setup(0,9600,8,0,1,0)
print("\nWelcome to WIFI SSID & Password reset")
print("\nEnter the SSID as-->ID:your_WIFI_SSID ")
print("\nEnter the Password as-->PW:your_WIFI_Password")
ssid_new = nil
pswd_new = nil
uData =nil
u1= uart.on("data", "\n", 
    function(uData)	   	 
	   	local a,b,c,d = nil,nil,nil,nil
    	a,b=string.find( uData, "ID:" )
	    c,d=string.find( uData, "W:" )
	    	if ((a==1) and(b==3)) then
			  	print("\n New SSID is:")
			 	ssid_new = uData:sub(4,-3)
			 	print(ssid_new)
			 	--print(string.len(ssid_new))
			elseif ((c==2) and(d==3)) then
			  	print("\n New Password is:")
			 	pswd_new = uData:sub(4,-3)
			 	print(pswd_new)
			 	--print(string.len(pswd_new))
			else 
			 	print("\nWrong syntax")
			end
			if(ssid_new ~= nil) and (pswd_new ~=nil) then
				wifi.sta.config(ssid_new,pswd_new)
				tmr.alarm(0,1000,0,function() dofile('init.lua')end)  -- Restart
			end
    end, 0)



