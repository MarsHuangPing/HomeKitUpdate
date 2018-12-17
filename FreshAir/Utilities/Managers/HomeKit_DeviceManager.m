//
//  DeviceManager.m
//  NewPeek2
//
//  Created by Tyler on 10/24/13.
//  Copyright (c) 2013 Delaware consulting. All rights reserved.
//

#import "HomeKit_DeviceManager.h"

#import "sys/utsname.h"

#include <ifaddrs.h>
#include <arpa/inet.h>

#include <net/if.h>
#include <net/if_dl.h>
#include <mach/mach.h>
#include <sys/sysctl.h>

@implementation HomeKit_DeviceManager

#pragma mark - Singleton

+ (HomeKit_DeviceManager *)sharedInstance
{
    static HomeKit_DeviceManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstance = [[HomeKit_DeviceManager alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - Methods

- (NSString *)systemVersion
{
    return [UIDevice currentDevice].systemVersion;
}

- (NSString *)systemLanguage
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"][0];
}

- (NSString *)deviceResolution
{
    return NSStringFromCGSize([[UIScreen mainScreen] currentMode].size);
}

- (NSString *)deviceType
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

- (NSString *)ipAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

- (NSString *)macAddress
{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) return nil;
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) return nil;
    if ((buf = malloc(len)) == NULL) return nil;
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        return nil;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString
                           stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr + 1), *(ptr + 2), *(ptr + 3),
                           *(ptr + 4), *(ptr + 5)];
    free(buf);
    return outstring;
}

- (double)totalMemory
{
    size_t size = sizeof(int);
    int results;
    int mib[2] = {CTL_HW, HW_PHYSMEM};
    sysctl(mib, 2, &results, &size, NULL, 0);
    return results / (1024.0 * 1024.0);
}

- (double)availableMemory {
	vm_statistics_data_t vmStats;
	mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
	kern_return_t kernReturn = host_statistics(mach_host_self(), HOST_VM_INFO, (host_info_t)&vmStats, &infoCount);
    
	if(kernReturn != KERN_SUCCESS) {
		return NSNotFound;
	}
    
	return (vm_page_size * vmStats.free_count) / (1024.0 * 1024.0);
}

- (double)totalDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    return [[fattributes objectForKey:NSFileSystemSize] doubleValue] / (1024.0 * 1024.0);
}

- (double)freeDiskSpace
{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    
    return [[fattributes objectForKey:NSFileSystemFreeSize] doubleValue] / (1024.0 * 1024.0);
}

- (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

@end
