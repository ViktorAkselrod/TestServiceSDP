//
//  ViewController.m
//  TestSDP
//
//  Created by Viktor Akselrod on 24/12/2024.
//

#import "ViewController.h"
#import <IOBluetooth/objc/IOBluetoothDevice.h>
#import <IOBluetooth/objc/IOBluetoothSDPServiceRecord.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

- (void)createSDPService:(bool)Persistent{
    
    NSString *dictionaryPath = nil;
    NSMutableDictionary *dictionary = nil;
    IOBluetoothSDPServiceRecord *service = nil;
    BluetoothRFCOMMChannelID channelID = 0;
    BluetoothSDPServiceRecordHandle serverHandle = 0;
       
    NSString *dictionaryName = Persistent ? @"SDPPersistent": @"SDP";
    
    dictionaryPath = [[NSBundle mainBundle] pathForResource:dictionaryName ofType:@"plist"];
    dictionary = [NSMutableDictionary dictionaryWithContentsOfFile:dictionaryPath];
    [dictionary setObject:@"TestServiceSDP" forKey:@"0100 - ServiceName*"];
    
    for (int i = 0; i < 10; i++) {
        service = [IOBluetoothSDPServiceRecord publishedServiceRecordWithDictionary:dictionary];
        if (!service) {
            NSLog(@"Failed to create service");
        }
        else
        {
            [service getRFCOMMChannelID:&channelID];
            [service getServiceRecordHandle:&serverHandle];
            NSLog(@"A new service has been created handle=%u, channelID=%hhu", serverHandle, channelID);
            if (service.removeServiceRecord != kIOReturnSuccess) {
                NSLog(@"Failed to delete service");
            }
            //service.release;
            service = nil;
        }
    }
}

- (IBAction)runTest:(id)sender {
    [self createSDPService:false];
}

- (IBAction)runTestPersistent:(id)sender {
    [self createSDPService:true];
}

@end
