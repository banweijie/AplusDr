//
//  PartnerConfig.h
//  AlipaySdkDemo
//
//  Created by ChaoGanYing on 13-5-3.
//  Copyright (c) 2013年 RenFei. All rights reserved.
//
//  提示：如何获取安全校验码和合作身份者id
//  1.用您的签约支付宝账号登录支付宝网站(www.alipay.com)
//  2.点击“商家服务”(https://b.alipay.com/order/myorder.htm)
//  3.点击“查询合作者身份(pid)”、“查询安全校验码(key)”
//

#ifndef MQPDemo_PartnerConfig_h
#define MQPDemo_PartnerConfig_h

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088412706263443"

//收款支付宝账号
#define SellerID  @"ejrendotcom@163.com"

//安全校验码（MD5）密钥，以数字和字母组成的32位字符
#define MD5_KEY @"m3y67eunp1j4at52jhodgcirg817yg4d"

//商户私钥，自助生成
#define PartnerPrivKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALoKi2PKtdBt6U9ujg9FraQx/x1IpZRvdJDkNBxtdkY5OWPw3AM13shDZWJv/qp0/TxvQB0ukL6+YbQuaRo9WKj2kFVpbc3pAj+40nQCopGya1JWIRniW/qmCLnx52qWgs8XWYyPj94WJPzveqI1GNJm6mosm+aWGh8P7KLJBIVLAgMBAAECgYALh+fH0aKfPpC9aZ7Id4shqC+lwwDwSFAzQtGwCWDRTW6vMRiR4l7ijrrT9RkVu5aOjl6s8FvsVqR7pHzDMZYzF5h9SQg/QH9Q69jOY96euIgu517frvWA0/Zm1jGI562/NKfAAWn/tIaAyMgTvm77YWfRIrs7Yhbz9Ca3YGVLwQJBAO/vPkhp7kZv+DGgkpdS++14AkmjnBmgZcb0hv+souzKYhq9n+HuBsxtBF26tqjHrbHc2lpjfYnroaU7ejgqCtsCQQDGf4GrELZe+YxGrSONBxI6/7NmwNwTyBLTR3MQ9iQ7Ary/qyJtOOZhZvd64YqWGlMxoyUGgaLRzQ2rkEpGsiJRAkBhovy4YQsKdNQN9ebRV36XQufDaaXDM+dWz/kDoA/oxe6oLRQbz03K8G3/alScWC1RnKrqb2QNtOphn9N7eXhTAkBNEIvjQmXLkc8oUWgQBMLLLSMVraLD+1VzubWuzCFc1784GtUO2px3DGbgylfn1uidyN1DHWl9UsMP7MEpmVdBAkEAvJkgwlrdeIcvh3skVbx2Fved17+1AaiLep/pNROtCFmkhqKVQVpSc+37zcAMnwoVekOucRVZALIdpOKtcf0Pow=="


//支付宝公钥
#define AlipayPubKey   @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB"

#endif
