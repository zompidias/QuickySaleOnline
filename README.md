## QUICKY SALE ONLINE

This website was created as an online grocery shopping store.  

Shoppers are expected to register with user name e.g. email and password. These details were stored into the Sql database. Users were allowed to come back and relogin with the same details, else they would be viewed by the system at as a completely new user. The system would check if the username and password matched before retrieving the customer's details. Customers who forgot their password could reset them. This was accomplished by an email sent to their inbox and they followed the instructions given. Anyone accessing the site was automatically given the username 'Guest'. A Guest cart was automaticity created until the user logged in. This way a user could go ahead and shop till they were ready to check out. Users were as given options to pay on delivery via cash or card.  


The online store is owned by a warehouse and has a myriad of sellers. Each item ordered triggers an email alert to the seller of that item, specifying the time the item should be delivered to the warehouse else that item would be cancelled and a corresponding email sent to the Buyer that the item won't be delivered with the other items in the case where the seller could not deliver.  

 

This website was done using ASPNet 2013, Microsoft Sql Server 2012, MVC, C#.  

 

I have incuded the sql script to recreate the Database, Tables and stored prcedures used.  

 

To rerun this project one will need to go into the webconfig page  and change the code part below.   


> <connectionStrings>  
<add name="OnlineStoreEntities" connectionString="server=JOSHUA\SQL2012; Initial Catalog=QuickySaleOnlineStore; Integrated Security=True; User ID=quickysale; Password=quickysale" providerName="System.Data.SqlClient" />  

<add name="DBCS" connectionString="server=JOSHUA\SQL2012; database=QuickySaleOnlineStore; integrated security=SSPI; User ID=quickysale; Password=quickysale" providerName="System.Data.SqlClient" />  

The site won't run without accessing sql. Hence the sql script has been added to git as QSscript.sql  

BusinessLayer folder contains class libraries used for email and other behind the scenes calculations and functions.  

The screen shots for the site have also been included.  

Pics QS1 to QS2 give an overview of the site QS3 to QS5 show the control manager or control panel pages. The site owner has the ability to add, delete or edit more names to the Catalogue links etc.   