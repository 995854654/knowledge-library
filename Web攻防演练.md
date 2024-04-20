## “Content-Security-Policy”头缺失

### 原因

Web 应用程序编程或配置不安全 

### 风险

1. 可能会收集有关 Web 应用程序的敏感信息，如用户名、密码、机器名和/或敏感文件位置
2. 可能会劝说初级用户提供诸如用户名、密码、信用卡号、社会保险号等敏感信息
3. CSP 值缺失或不当会导致 Web 应用程序容易受到 XSS、点击劫持等的攻击。
4. “Content-Security-Policy”头旨在修改浏览器呈现页面的方式，从而防止各种跨站点注入，包括跨站点脚本编制。以不会妨碍 Web 站点正常运行 的方式正确设置头值非常重要。例如，如果头设置为阻止执行内联 JavaScript，则 Web 站点不得在其页面中使用内联 JavaScript。
5. 要防止跨站点脚本编制攻击、跨框架脚本编制攻击和点击劫持，请务必使用正确的值设置以下策略
    - “default-src”和“frame-ancestors”策略*或*“script-src”、“object-src”和“frame-ancestors”策略
    - 对于“default-src”、“script-src”和“object-src”，应避免使用不安全的值，例如“*”、“data:”、“unsafe-inline”或“unsafe-eval”。 *
    - *对于“frame-ancestors”，应避免使用不安全的值，例如“*”或“data:”。
    -  请参考以下链接以获取更多信息。 请注意，“Content-Security-Policy”包括四种不同的测试。 验证是否正在使用“Content-Security-Policy”头的常规测试以及检查“FrameAncestors”、“Object-Src”和“Script-Src”是否正确配置的三个附加测试。

### 修复方法

1. 配置服务器以发送“Content-Security-Policy”头。
2. 建议将 Content-Security-Policy 头配置为其指令的安全值，如下所示：
    -  对于“default-src”、“script-src”和“object-src”，需要使用诸如“none”、“self”、`https://any.example.com` 之类的安全值
    -  对于“frame-ancestors”，需要使用诸如“self”、“none”或 `https://any.example.com` 之类的安全值。 
    - 在任何情况下都不得使用“unsafe-inline”和“unsafe-eval”。使用 nonce/hash 只会被视为短期解决方法。