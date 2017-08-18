//
//  AliDNSService.swift
//  Pods
//
//  Created by 王小涛 on 2017/8/14.
//
//

import AlicloudHttpDNS

public class AliDNSService: NSObject, HttpDNSDegradationDelegate {
    
    public static let shared = AliDNSService()
    
    private override init() {
        super.init()
    }
    
    private var alicloundDNSService: HttpDnsService?
    
    private(set) var preResolveHosts: [String] = []
    
    public func setup(accountId: Int32, secretKey: String, preResolveHosts: [String]) {
        
        alicloundDNSService = HttpDnsService(accountID: accountId, secretKey: secretKey)
        alicloundDNSService?.setAuthCurrentTime(UInt(Date().timeIntervalSince1970))
        alicloundDNSService?.delegate = self
        alicloundDNSService?.setExpiredIPEnabled(true)
        alicloundDNSService?.setPreResolveAfterNetworkChanged(true)
        
        alicloundDNSService?.setPreResolveHosts(preResolveHosts)
        
        self.preResolveHosts = preResolveHosts
    }

    public var isHttpsRequestEnabled: Bool = false {
        didSet {
            alicloundDNSService?.setHTTPSRequestEnabled(isHttpsRequestEnabled)
        }
    }
    
    public func resolve(host: String) -> String? {
        if let ip = HttpDnsService.sharedInstance().getIpByHostAsync(host) {
            return ip
        } else {
            return nil
        }
    }
    
    public func resolveInURLFormat(host: String) -> String? {
        if let ip = HttpDnsService.sharedInstance().getIpByHostAsync(inURLFormat: host) {
            return ip
        } else {
            return nil
        }
    }
    
    public func shouldDegradeHTTPDNS(_ hostName: String!) -> Bool {
        return false
    }
}
