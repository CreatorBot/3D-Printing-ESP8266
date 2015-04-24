--'
-- CreatorBot ESP8266 Serial WIFI Connect
-- Author: Chetan Patil.
-- LICENCE: http://opensource.org/licenses/MIT
-- Last modified 2015-01-03. V0.0
-- CreatorBot.com
--' 

Tstart = tmr.now()
ConnStatus = nil

function Start_Data()
   sv=net.createServer(net.TCP, 60)
   global_c = nil
   sv:listen(9999, function(c)
      if global_c~=nil then
         global_c:close()
      end
      global_c=c
      c:on("receive",function(sck,pl)  uart.write(0,pl) end)
      end)
   uart.on("data",4, function(data)
      if global_c~=nil then
         global_c:send(data)
      end
   end, 0)
end

function ConnStatus(n)
   status = wifi.sta.status()
   local x = n+1
   if (x < 50) and ( status < 5 ) then
      if(status==0) then
         wifi.sta.connect()
         print("\n IDLE")
      end
      tmr.alarm(0,100,0,function() ConnStatus(x) end)
   elseif(status== 2) then
         print("\n WRONG PASSWORD")
         tmr.alarm(0,1000,0,function() dofile('WIFI_Reset.lua')end)  
   elseif(status==3) then
         print("\n AP NOT FOUND")
         tmr.alarm(0,1000,0,function() dofile('WIFI_Reset.lua')end)  
   elseif(status==4) then
         print("\nConnection failed")
         tmr.alarm(0,1000,0,function() dofile('init.lua')end) 
   elseif(status==5) then
          print('\nConnected as '..wifi.sta.getip())
          local myIP= nil 
          myIP =wifi.sta.getip()
          uart.setup(0,115200,8,0,1,0)

         for i = 1, 4, 1 do
            uart.write(0," M117 ") 
            uart.write(0, myIP)
            uart.write(0,"\n")
         end
         tmr.alarm(0,1000,0,function() Start_Data() end) 
   end
end


wifi.setmode(wifi.STATION)
print("\n CONNECTING TO WIFI")
tmr.alarm(0,100,0,function() ConnStatus(0) end)