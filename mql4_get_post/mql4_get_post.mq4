
#property copyright "Copyright 2018, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//--- create timer
   EventSetTimer(2);
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//--- destroy timer
   EventKillTimer();
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()
  {
//---
   //GetRequest();
   PostRequest();
   
  }
//+------------------------------------------------------------------+

void PostRequest()
{
   int res;
   string url = "http://localhost/events";
   
   char data[];
   string str = "ask = " + Ask + "& bid = " + Bid;
   //string str = "ask = " + DoubleToStr(Ask) + "& bid = " + DoubleToStr(Bid);
   
   ArrayResize(data, StringToCharArray(str, data, 0, WHOLE_ARRAY, CP_UTF8) - 1);
   
   res = WebRequest("POST", url, NULL, 0, data, data, str);
   
   if(res == -1){
      Print("Error in WebRequest. Error code = ", GetLastError());
      Print("Add the address '" + url + "' in the list of allowed URLs on tab 'Experts advisor'");
   }else{
      Print(res);
   }

}

void GetRequest()
{
   string values[3];
   string cookie = NULL, headers;
   int timeout = 5000; // 5 secs
   char post[], result[];
   string url = "http://localhost/events";
   int res;
   res = WebRequest("GET", url, cookie, NULL, timeout, post, 0, result, headers);
   
   if(res == -1){
      Print("Error in WebRequest. Error code = ", GetLastError());
      Print("Add the address '" + url + "' in the list of allowed URLs on tab 'Experts advisor'");
   }else{
      ConvertResponse(CharArrayToString(result), values);
      
      Print("Event => ", values[0]);
      Print("Level => ", values[1]);
      Print("Date => ", values[2]);
   } 
}

void ConvertResponse(string response, string& values[])
{
   Print("Response => ", response);
   string value;
   string items[];
   ushort comma, dot;
   
   response = StringSubstr(response, 1, StringLen(response) - 2);
   
   comma = StringGetCharacter(",", 0);
   dot = StringGetCharacter(":", 0);
   
   int n = StringSplit(response, comma, items);
   
   for(int i = 0; i < n; i++){
      string result[];
      StringSplit(items[i], dot, result);
      string key = result[0];
      
      if(key == "\"event\""){
         value = StringSubstr(result[1], 1, StringLen(result[1]) - 2);
      }else{
         value = result[1];
      }
      
      //Print("Key => ", key, " Value => ", value);
      values[i] = value;
   }
}
