#property copyright "Copyright 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

datetime LastActiontime;
string fileName = Symbol()+Period()+".csv";

int start(){
   if(LastActiontime!=Time[0]){
      CSVWrite();
      LastActiontime=Time[0];
   }
}

void CSVWrite(){
   int handle = FileOpen(fileName, FILE_CSV|FILE_WRITE, ",");
   if(handle>0){
     
     //FileWrite(handle, "Time,Open,High,Low,Close,Volume");
     FileWrite(handle, "date,close,volume,open,high,low");
     for(int i=0; i<Bars; i++)
       //FileWrite(handle, TimeToStr(iTime(NULL, 0, i),TIME_DATE|TIME_MINUTES), Close[i], Volume[i], Open[i], High[i], Low[i]);
       FileWrite(handle, TimeToStr(iTime(NULL, 0, i),TIME_DATE|TIME_MINUTES), Close[i], Volume[i], Open[i], High[i], Low[i]);
       //FileWrite(handle, TimeToStr(iTime(NULL, 0, i),TIME_DATE|TIME_MINUTES), ((Open[i]+Close[i])/2));
     FileClose(handle);
   }
}