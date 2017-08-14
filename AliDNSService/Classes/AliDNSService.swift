//
//  AliDNSService.swift
//  Pods
//
//  Created by 王小涛 on 2017/8/14.
//
//

import AlicloudHttpDNS

class AliDNSService: NSObject, HttpDNSDegradationDelegate {
    
    static let shared = AliDNSService()
    
    private override init() {
        super.init()
    }
    
    var isEnabled: Bool = false
    
    private var alicloundDNSService: HttpDnsService?
    
    private(set) var preResolveHosts: [String] = []
    
    func setup(accountId: Int32, secretKey: String, preResolveHosts: [String]) {
        
        alicloundDNSService = HttpDnsService(accountID: accountId, secretKey: secretKey)
        alicloundDNSService?.setAuthCurrentTime(UInt(Date().timeIntervalSince1970))
        alicloundDNSService?.delegate = self
        alicloundDNSService?.setExpiredIPEnabled(true)
        alicloundDNSService?.setPreResolveAfterNetworkChanged(true)
        
        alicloundDNSService?.setPreResolveHosts(preResolveHosts)
        
        self.preResolveHosts = preResolveHosts
    }

    var isHttpsRequestEnabled: Bool = false {
        didSet {
            alicloundDNSService?.setHTTPSRequestEnabled(isHttpsRequestEnabled)
        }
    }
    
    func resolve(host: String) -> String? {
        if let ip = HttpDnsService.sharedInstance().getIpByHostAsync(host) {
            return ip
        } else {
            return nil
        }
    }
    
    func resolveInURLFormat(host: String) -> String? {
        if let ip = HttpDnsService.sharedInstance().getIpByHostAsync(inURLFormat: host) {
            return ip
        } else {
            return nil
        }
    }
    
    func shouldDegradeHTTPDNS(_ hostName: String!) -> Bool {
        return false
    }
}
