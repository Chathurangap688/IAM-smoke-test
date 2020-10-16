# Identity and Access Management smoke test
An identity provider stores and manages users' digital identities. identity provider provides access token to user defining access sopes of registered resource application(resource server). users can access resources which are registered on IS, by using this identity details. This access details can be any type of access providing types such as OAuth, SAML, OpenID etc. 

Here faw examples for access management with wso2 identity server using ```curl``` command. 

## [OAuth 2.0 ](https://github.com/Chathurangap688/identity-and-access-management-smoke-test-application/tree/main/OAuth%202.0)
This is an industry-standard protocol for authorization. OAuth 2.0 focuses on client developer simplicity while providing specific authorization flows for web applications, desktop applications and mobile phones.
	In this application, I’m try to obtain oauth 2 access token from identity server by different ways. And also In this case I use wso2 IS server as identity provider. 
## [SCIM](test) 
This is a simple way to add new users, new roles and delete them through SCIM requests. For further details you can refer the documentations.

You can download the WSO2-IS from https://wso2.com/identity-and-access-management/

Documentation - https://is.docs.wso2.com/en/latest/