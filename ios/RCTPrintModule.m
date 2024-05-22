//
//  RCTPrintModule.m
//  TicketPrintApp
//
//  Created by Fai on 15/2/2024.
//

#import <Foundation/Foundation.h>
#import "RCTPrintModule.h"
#import <React/RCTLog.h>
#import "TSCSDK.h"


@implementation RCTPrintModule : NSObject

// To export a module named RCTPrintModule
RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(printToLog:(NSString *)printMessage)
{
  RCTSetLogThreshold(RCTLogLevelInfo);
  RCTLogInfo(@"You wanted to see this message :  %@", printMessage);
  RCTLogInfo(@"This is an info log");
  RCTLogWarn(@"This is a warning log");
}

RCT_EXPORT_METHOD(print:(NSString *)destination portnumber:(int)portnumber content:(NSString *)content barcode:(NSString *)barcode)
{
  RCTLogInfo(@"Pretending to open a connection to %@ at %d", destination, portnumber);
  
  TSCSDK *lib = [TSCSDK new];

  // Open the port to the printer
  NSInteger openPortResult = [lib openport_ethernet:destination portnumber:portnumber];
  if (openPortResult == 1) {
    // Clear the printer image buffer
    [lib clearBuffer];
    
    // Send a command followed by a newline character
    [lib sendCommand:@"\r\n"];
    
    // Test QR Code print
    [lib sendCommand:@"GAP 0,0\r\n"];
    [lib sendCommand:@"DENSITY 12\r\n"];
    [lib sendCommand:@"QRCODE 100,800,M,7,A,0, \"THE FIRMWARE HAS BEEN UPDATED\"\r\n"];
//    [lib sendCommand:@"PRINT 1,1\r\n"];
    
    // Send a printer font command to print text

    [lib windowsfont:800 y:100 height:60 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:@"Master of Social Sciences in the field of"];
    [lib windowsfont:700 y:100 height:60 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:@"Social Service Management"];
    [lib windowsfont:300 y:500 height:96 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:@"CHAN Tai Man"];
    [lib windowsfont:500 y:500 height:96 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:content];
    [lib windowsfont:100 y:100 height:72 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:@"Seat Number"];
    [lib windowsfont:0 y:100 height:96 rotation:90 style:0 withUnderline:0 fontName:@"Arial" content:@"M-8"];


    // Send a barcode printing command
//    [lib barcode:@"10" y:@"500" barcodeType:@"39" height:@"100" readable:@"1" rotation:@"0" narrow:@"2" wide:@"6" code:barcode];
    
    

    // Print the label with the specified number of copies
    [lib printlabel:@"1" copies:@"1"];

    // Close the port after a delay of 4 seconds (assuming the delay is in seconds)
    [lib closeport:4];
  } else {
    // Handle the error if the port could not be opened
    NSLog(@"Failed to open port. Error code: %ld", (long)openPortResult);
  }
}

@end
