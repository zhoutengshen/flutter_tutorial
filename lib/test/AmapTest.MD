生成调试版本安全码：
注意，keytool 需要java 环境 需要配置其到path环境变量里面
1. cd ~/.android
2. keytool -list -v -keystore debug.keystore

>> amaptest
```
    输入密钥库口令:
    密钥库类型: jks
    密钥库提供方: SUN
    
    您的密钥库包含 1 个条目
    
    别名: androiddebugkey
    创建日期: 2019-12-24
    条目类型: PrivateKeyEntry
    证书链长度: 1
    证书[1]:
    所有者: C=US, O=Android, CN=Android Debug
    发布者: C=US, O=Android, CN=Android Debug
    序列号: 1
    有效期为 Tue Dec 24 14:37:17 GMT+08:00 2019 至 Thu Dec 16 14:37:17 GMT+08:00 2049
    证书指纹:
             MD5:  4B:15:DE:8D:8B:52:CB:A0:04:29:1A:28:87:30:1F:33
             SHA1: 3F:7C:24:60:18:C3:E4:DB:42:D7:A8:7C:59:E9:ED:00:0D:54:27:4C
             SHA256: 44:D5:7D:02:83:A0:B6:E4:8F:33:57:80:61:C3:E3:F8:F0:C0:F1:9C:10:FB:4B:B1:F1:BA:19:FD:CE:94:B4:28
    签名算法名称: SHA1withRSA
    主体公共密钥算法: 2048 位 RSA 密钥
    版本: 1
```

生成生成环境版本安全码：
1. 创建 .jsk 文件
    keytool -genkey -v -keystore /D:/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
2. 根据.jsk文件生成 sha1
    keytool -list -v -keystore key.jks
>> amaptest
```aidl
    期为 Mon May 11 13:36:52 GMT+08:00 2020 至 Fri Sep 27 13:36:52 GMT+08:00 2047
    证书指纹:
             MD5:  D4:66:3B:07:F7:54:2F:E0:D7:79:96:4F:98:16:FC:61
             SHA1: A7:0F:EA:5E:69:9B:A0:6B:37:C7:01:7E:F0:59:88:4E:0C:24:18:AE
             SHA256: 8C:E3:44:7E:13:88:43:D5:0F:D1:BA:34:16:97:9A:67:60:A4:5C:90:1C:1B:C7:09:B4:D0:2D:14:31:5A:04:D0
    签名算法名称: SHA256withRSA
    主体公共密钥算法: 2048 位 RSA 密钥
    版本: 3
    
    扩展:
    
    #1: ObjectId: 2.5.29.14 Criticality=false
    SubjectKeyIdentifier [
    KeyIdentifier [
    0000: 94 39 CA EE 2D 84 C1 F4   66 DC 55 AB DE DB B1 50  .9..-...f.U....P
    0010: EF 1C 76 2F                                        ..v/
    ]
    ]
    
    
    
    *******************************************
    ******************************************* 
```
    