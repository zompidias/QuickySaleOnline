using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Configuration;
using System.Data.Odbc;
using System.Data.OleDb;
using System.Net.Mail;
using System.Data;
using System.IO;
using System.Xml.Serialization;
using System.Web;
using System.Collections.Specialized;
using System.Web.UI.WebControls;
using RazorEngine.Templating;
using RazorEngine;

namespace BusinessLayer
{

    public class SendEmails
    {
        string connectionString =
        ConfigurationManager.ConnectionStrings["DBCS"].ConnectionString;
        string e_mail_address = null;
        string foodname = null;
        string qty = null;
        string emailbody = null;
        string orderDate = null;
        public string AdminEmailAdd {get; set;}
        public string LogonEmailAdd { get; set; }
        public string LogonPwd { get; set; }
        public decimal MinimumTP { get; set; }
        public decimal MaximumTP { get; set; }
        public int TPCondition { get; set; }
        public void GetAdminEmailDetails()
        {
            using (SqlConnection con = new SqlConnection(connectionString))
            {
                SqlCommand cmd2 = new SqlCommand("spGetAdminDetails", con);
                cmd2.CommandType = CommandType.StoredProcedure;

                con.Open();
                SqlDataReader rd2 = cmd2.ExecuteReader();

                if (rd2.HasRows)
                {
                    while (rd2.Read())
                    {
                        //bra = (string)rd2["bra"].ToString();
                        AdminEmailAdd = (string)rd2["AdminEmail"].ToString();
                        LogonEmailAdd = (string)rd2["LoginEmail"].ToString();
                        LogonPwd = (string)rd2["LoginPwd"].ToString();
                        MinimumTP = Convert.ToDecimal(rd2["MinimumTP"].ToString());
                        MaximumTP = Convert.ToDecimal(rd2["MaximumTP"].ToString());
                        TPCondition = Convert.ToInt16(rd2["TPCondition"].ToString());
                    }
                }
                rd2.Dispose();
            }
        }


        public void ProcessEmail(string CartId)
        {
            string customername = null;
            string customeraddress = null;
            string customeremail = null;
            string customerphone = null;
            string todayis = DateTime.Now.ToString();
            int i = 0;
            decimal totalcost = 0;
            decimal totalcostwithouttp = 0;
            decimal transport = 0;
            decimal totalbuyingcost = 0;
            OrderModel model = null;
            List<CustomerOrderForEmail> cods = new List<CustomerOrderForEmail>();

            GetAdminEmailDetails();
            if (AdminEmailAdd != null || AdminEmailAdd != "")
            {

                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    SqlCommand cmd2 = new SqlCommand("spOrdersToSendViaEmail", con);
                    cmd2.CommandType = CommandType.StoredProcedure;

                    SqlParameter paramCartId = new SqlParameter();
                    paramCartId.ParameterName = "@CartId";
                    paramCartId.Value = CartId;
                    cmd2.Parameters.Add(paramCartId);

                    con.Open();
                    SqlDataReader rd2 = cmd2.ExecuteReader();

                    if (rd2.HasRows)
                    {
                        while (rd2.Read())
                        {
                            CustomerOrderForEmail cod = new CustomerOrderForEmail(); 
                            cod.e_mail_address = (string)rd2["SellerEmail"].ToString();
                            cod.foodname = (string)rd2["FoodName"].ToString();
                            cod.Quantity = Convert.ToInt16(rd2["Quantity"]);
                            cod.orderDate = (string)rd2["OrderDate"].ToString();
                            cod.UnitPrice = Convert.ToDecimal(rd2["UnitPrice"].ToString());
                            cod.BuyingPrice = Convert.ToDecimal(rd2["BuyingPrice"].ToString());
                            cod.totalBuyingCost = cod.Quantity * cod.BuyingPrice;
                            cod.OrderNumber = (string)rd2["OrderNumberId"].ToString();
                            cod.SellerFeeToBePaid = Convert.ToDecimal(rd2["SellerFeePaid"].ToString());
                            cod.SellerBalance = cod.UnitPrice - cod.SellerFeeToBePaid;
                            cod.SellerName = (string)rd2["SellerName"].ToString();
                            cod.totalCustomerCost = cod.UnitPrice * cod.Quantity;
                            cods.Add(cod);

                           /* e_mail_address = (string)rd2["SellerEmail"].ToString();
                            foodname = (string)rd2["FoodName"].ToString();
                            qty = (String)(rd2["Quantity"].ToString());
                            orderDate = (string)rd2["OrderDate"].ToString();
                            unitPrice = (string)(rd2["UnitPrice"].ToString());
                            String OrderNumber = (string)rd2["OrderNumberId"].ToString(); */

                           // emailbody = " " + foodname + ",\n Quantity - \t" + qty + ",\n Order Date  - \t" + orderDate;
                           // subject = "Order details from Quicky Sale Online Food Shopper";
                           // subject2 = "Your Orders made on QuickySale Online Food shopper";
                            //Console.WriteLine(emailbody);

                            customername = (string)rd2["CustomerName"].ToString(); ;
                            customeraddress = (string)rd2["Address"].ToString(); ;
                            customeremail = (string)rd2["Email"].ToString(); ;
                            customerphone = (string)rd2["Phone"].ToString(); ;
                           // customeremailBody = customeremailBody + emailbody + " \n Unit Price =N=" + unitPrice + ". ";
                           // AdminEmailBody = AdminEmailBody + emailbody + " Unit Price \t =N=" + unitPrice + "\n For : \t" + customername + "\n Email - \t" + customeremail + "\n At Address \t" + customeraddress + "\n With Phone \t" + customerphone + "   -   ";

                            SellerSendEmail(cod, cod.e_mail_address);
                            //CustomerSendEmail(customername, model, customeremail);
                            i = i + 1;
                            if (i < TPCondition)
                            {
                                transport = MinimumTP; 
                            }
                            else
                            {
                                transport = MaximumTP;
                            }
                            totalcost = totalcost + (cod.UnitPrice * cod.Quantity);
                            
                        }
                    }
                    rd2.Dispose();
                    totalcostwithouttp = totalcost;
                    totalcost = totalcost + transport;
                    model = new OrderModel
                    {
                        CustomerName = customername,
                        TotalCost = totalcost,
                        TotalCostWithoutTP = totalcostwithouttp,
                        Transport = transport,
                        OrderNumber = cods[0].OrderNumber,
                        OrderDate = cods[0].orderDate,
                        Orders = cods,
                        CustomerAddress =customeraddress,
                        CustomerEmail=customeremail,
                        CustomerPhone=customerphone
                    };
                    //customeremailBody = "Please find Order details: Item - \n" + customeremailBody;
                }

                //Send Emails
                AdminSellerFeesPerItem(model.CustomerName, model);
                AdminSendEmail(model.CustomerName, model);
                CustomerSendEmail(model.CustomerName, model, customeremail);
                ShoppingListToAdmin(model.CustomerName, model);

                //Write a copy of orders to file....
                string location = "Order " + todayis + ".txt";
               // writeToFile(location, AdminEmailBody);
            }
        }

        public  void SendEnquiryToEmail(BusinessLayer.ContactUs Enquiry)
        {
                    GetAdminEmailDetails();
                      if (AdminEmailAdd != null || AdminEmailAdd != "")
                      {
                          e_mail_address = AdminEmailAdd;//Admin email
                          /*string email = (string)Enquiry.Email;
                          string comment = (string)Enquiry.Comment.ToString();
                          string FNamw = (string)Enquiry.FirstName;
                          string LName = (string)Enquiry.LastName;*/
                          string todayis = Convert.ToString(DateTime.Now.ToString());
                          emailbody = "Please find Enquiry details:\n Comment - \t" + (string)Enquiry.Comment.ToString() + ",\n from - " + (string)Enquiry.FirstName.ToString() + " " + (string)Enquiry.LastName.ToString() + ",\n email  - " + (string)Enquiry.Email.ToString() + ",\t Date - " + todayis + " -end of msg ";
                          string subject = "Enquiry And Questions";
                          SendEmail(emailbody, e_mail_address, subject);
                      }
        }

        public  void NewCustomerEmail(BusinessLayer.CustomerDetail Enquiry)
        {
            GetAdminEmailDetails();

            if (AdminEmailAdd != null || AdminEmailAdd != "")
            {
                e_mail_address = AdminEmailAdd;//Admin email

                string todayis = Convert.ToString(DateTime.Now.ToString());
                emailbody = "Please find New Customer to Confirm:\n Name - \t" + (string)Enquiry.FirstName.ToString() + " " + (string)Enquiry.LastName.ToString() + ",\t Phone - " + (string)Enquiry.Phone.ToString() + ", \t Address " + (string)Enquiry.Address.ToString() + " . ";
                string subject = "New Registered Customer";
                //Console.WriteLine(emailbody);
                SendEmail(emailbody, e_mail_address, subject);
            }

        }
        public void ForgotPassowrdEmail(string Cusemail, string lostpwd)
        {
            GetAdminEmailDetails();

            if (AdminEmailAdd != null || AdminEmailAdd != "")
            {
                e_mail_address = Cusemail;//Admin email

                string todayis = Convert.ToString(DateTime.Now.ToString());
                emailbody = "Please find Your Password Below:\n " + lostpwd + " ";
                string subject = "Forgotten Password";
                //Console.WriteLine(emailbody);
                SendEmail(emailbody, e_mail_address, subject);
            }

        }

        public void CustomerSendEmail(string customer, OrderModel model, string customeremailadd)
        {
            try
            {
        
string Customertemplate =
@"<html>
<head>
<style>
table {
    width:100%;
}
table, th, td {
    border: 1px solid #e56e94;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
table#t01 tr:nth-child(even) {
    background-color: #ffffff;
}
table#t01 tr:nth-child(odd) {
   background-color:#ffdfdd;
}
table#t01 th	{
    background-color: #810541;
    color: white;
}
</style>
</head>
<body>

<body >
<div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';
width:600px; background-color:#FBBBB9; padding:30px;'> 

<font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>
        </div>
        <br />


<div style='background-color: #ece8d4;style='color:grey; font-size:15px;'
    font face='Helvetica, Arial, sans-serif'
width:600px; height:600px; padding:30px; margin-top:30px;'>

<p>Dear @Model.CustomerName,<p>
<br />

            <p>Please Find Below Your Order placed on @Model.OrderDate</p>
            <br />
 <p>Order Number: <b>@Model.OrderNumber</b></p>
<table id='t01'> 
                <tr>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Unit Price =N=</th>
                    <th>Total Cost =N=</th>

                </tr>
@foreach(var CustomerOrderForEmail in Model.Orders) {
<tr>
                    <td>@CustomerOrderForEmail.foodname</td>
                    <td>@CustomerOrderForEmail.Quantity</td>
                    <td>@CustomerOrderForEmail.UnitPrice</td>
                    <td>@CustomerOrderForEmail.totalCustomerCost</td>
                </tr>
}
<tr>
                    <td></td>
                    <td><b>Total</td>
                    <td><b>@Model.TotalCostWithoutTP<b></td>
  </tr>         
            </table>
<br />
<br />
<p>Transportaion: <b>=N=@Model.Transport</b></p>
    <p>Total Cost: <b>=N=@Model.TotalCost</b></p>
    

<br />
            <br />
<p>Delivery in 2 days or less. Please pay after inspecting your goods. No returns once payment is made.</p>
 <br />
            <p>Thank you for allowing us serve you...</p><br />
            <a href='www.quickysale.com'><b>QuickySale</b></a>

</body>
</html>"

; // TODO: Load the template from a CSHTML file

        /*        var model = new OrderModel
                {
                    CustomerName = customer,
                    TotalCost= totalCost,
                    Transport = Transport,
                    OrderNumber = emailmessage[1].OrderNumber,
                    OrderDate = emailmessage[1].orderDate,
                    Orders = emailmessage
                    /*Orders = new[] {
        new Order { Id = 1, Qty = 5, Price = 29.99 },
        new Order { Id = 2, Qty = 1, Price = 9.99 }
    }*/
               // };

               // string mailBody = RazorEngine.Razor.Parse(Customertemplate, model);
//string mailBody = "<html> <head> <style> table {    width:100%;} table, th, td { border: 1px solid #e56e94; border-collapse: collapse; } th, td { padding: 5px; text-align: left; } table#t01 tr:nth-child(even) { background-color: #ffffff;} table#t01 tr:nth-child(odd) { background-color:#ffdfdd; } table#t01 th	{ background-color: #810541; color: white; } </style> </head> <body> <body > <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive'; width:600px; background-color:#FBBBB9; padding:30px;'> <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font> </div>         <br /> <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'     font face='Helvetica, Arial, sans-serif' width:600px; height:600px; padding:30px; margin-top:30px;'> <p>Dear" + model.CustomerName + ",<p> <br />            <p>Please Find Below Your Order placed on " + model.OrderDate + " </p>             <br />  <p>Order Number: <b> " + model.OrderNumber + "</b></p> <table id='t01'>                 <tr>                    <th>Item</th>                    <th>Quantity</th>                    <th>Unit Price =N=</th>                 </tr>@foreach(var CustomerOrderForEmail in Model.Orders) { <tr>                     <td> @CustomerOrderForEmail.foodname  </td>                     <td> @CustomerOrderForEmail.Quantity  </td>                     </td>                    <td>  @CustomerOrderForEmail.UnitPrice </td>                </tr> } <tr>                    <td></td>                    <td><b>Total</td>                    <td><b>" + model.TotalCostWithoutTP + "<b></td>   </tr>                    </table><br /><br /><p>Transportaion: <b>=N=" + model.Transport + "</b></p>    <p>Total Cost: <b>=N=" + model.TotalCost + "</b></p> <br />            <br /><p>Delivery in 2 days or less. Please pay after inspecting your goods. No returns once payment is made.</p> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a></body></html>";
string mailBody = "<html> <head> <style> table {    width:100%;} table, th, td { border: 1px solid #e56e94; border-collapse: collapse; } th, td { padding: 5px; text-align: left; } table#t01 tr:nth-child(even) { background-color: #ffffff;} table#t01 tr:nth-child(odd) { background-color:#ffdfdd; } table#t01 th	{ background-color: #810541; color: white; } </style> </head> <body> <body > <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive'; width:600px; background-color:#FBBBB9; padding:30px;'> <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font> </div>         <br /> <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'     font face='Helvetica, Arial, sans-serif' width:600px; height:600px; padding:30px; margin-top:30px;'> <p>Dear" + model.CustomerName + ",<p> <br />            <p>Please Find Below Your Order placed on " + model.OrderDate + " </p>             <br />  <p>Order Number: <b> " + model.OrderNumber + "</b></p> <table id='t01'>                 <tr>                    <th>Item</th>                    <th>Quantity</th>                    <th>Unit Price =N=</th>                     <th>Total Item Price =N=</th>                </tr>";
                                                    
for (int i = 0; i < model.Orders.Count; i++)
    mailBody += "<tr> <td>" + model.Orders[i].foodname + "</td>                     <td> " + model.Orders[i].Quantity + "</td>                       <td> " + model.Orders[i].UnitPrice + "</td>                        <td> " + model.Orders[i].totalCustomerCost + "</td> </tr> ";

mailBody += " <tr>                    <td></td>                    <td><b>Total</td>       <td></td>             <td><b>" + model.TotalCostWithoutTP + "<b></td>   </tr>                    </table><br /><br /><p>Transportaion: <b>=N=" + model.Transport + "</b></p>    <p>Total Cost: <b>=N=" + model.TotalCost + "</b></p> <br />            <br /><p>Delivery in 2 days or less. Please pay after inspecting your goods. No returns once payment is made.</p> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a></body></html>";   
 
                MailMessage mailMessage = new MailMessage(LogonEmailAdd, customeremailadd);//mailDefinition.CreateMailMessage(mailTo, ldReplacements, control); //(mailTo, ldReplacements,emailmessage,this );
                mailMessage.From = new MailAddress(LogonEmailAdd, "QuickySale Online Shopper");
                mailMessage.IsBodyHtml = true;
                mailMessage.Subject = "Order Confirmation";
                mailMessage.Body = mailBody;

                using(SmtpClient smtpClient = new SmtpClient("mail.quickysale.com", 25)){
                smtpClient.Credentials = new System.Net.NetworkCredential()
                {
                    UserName = LogonEmailAdd,
                    Password = LogonPwd
                };
                smtpClient.EnableSsl = false;
                smtpClient.Send(mailMessage);
                };

            }
            catch (Exception ex)
            {
                ex.StackTrace.ToString();
                throw;
            }

        }


public void ShoppingListToAdmin(string customer, OrderModel model)
        {
            try
            {

                string Customertemplate =
                @"<html>
<head>
<style>
table {
    width:100%;
}
table, th, td {
    border: 1px solid #e56e94;
    border-collapse: collapse;
}
th, td {
    padding: 5px;
    text-align: left;
}
table#t01 tr:nth-child(even) {
    background-color: #ffffff;
}
table#t01 tr:nth-child(odd) {
   background-color:#ffdfdd;
}
table#t01 th	{
    background-color: #810541;
    color: white;
}
</style>
</head>
<body>

<body >
<div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';
width:600px; background-color:#FBBBB9; padding:30px;'> 

<font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>
        </div>
        <br />


<div style='background-color: #ece8d4;style='color:grey; font-size:15px;'
    font face='Helvetica, Arial, sans-serif'
width:600px; height:600px; padding:30px; margin-top:30px;'>

            <p>@Model.OrderDate</p>
            <br />
 <p>Order Number: <b>@Model.OrderNumber</b></p>
<table id='t01'> 
                <tr>
                    <th>Item</th>
                    <th>Quantity</th>
                    <th>Buying Price =N=</th>
                    <th>Total Cost =N=</th>
                </tr>
@foreach(var CustomerOrderForEmail in Model.Orders) {
<tr>
                    <td>@CustomerOrderForEmail.foodname</td>
                    <td>@CustomerOrderForEmail.Quantity</td>
                    <td>@CustomerOrderForEmail.BuyingPrice</td>
                    <td>@CustomerOrderForEmail.totalBuyingCost</td>
                </tr>
}
        
            </table>
<br />
<br />
  

<br />

</body>
</html>"

                ; // TODO: Load the template from a CSHTML file

                /*        var model = new OrderModel
                        {
                            CustomerName = customer,
                            TotalCost= totalCost,
                            Transport = Transport,
                            OrderNumber = emailmessage[1].OrderNumber,
                            OrderDate = emailmessage[1].orderDate,
                            Orders = emailmessage
                            /*Orders = new[] {
                new Order { Id = 1, Qty = 5, Price = 29.99 },
                new Order { Id = 2, Qty = 1, Price = 9.99 }
            }*/
                // };

                //string mailBody = RazorEngine.Razor.Parse(Customertemplate, model);
                //string mailBody = "<html> <head> <style> table {    width:100%;} table, th, td { border: 1px solid #e56e94; border-collapse: collapse; } th, td { padding: 5px; text-align: left; } table#t01 tr:nth-child(even) { background-color: #ffffff;} table#t01 tr:nth-child(odd) { background-color:#ffdfdd; } table#t01 th	{ background-color: #810541; color: white; } </style> </head> <body> <body > <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive'; width:600px; background-color:#FBBBB9; padding:30px;'> <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font> </div>         <br /> <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'     font face='Helvetica, Arial, sans-serif' width:600px; height:600px; padding:30px; margin-top:30px;'> <p>Dear" + model.CustomerName + ",<p> <br />            <p>Please Find Below Your Order placed on " + model.OrderDate + " </p>             <br />  <p>Order Number: <b> " + model.OrderNumber + "</b></p> <table id='t01'>                 <tr>                    <th>Item</th>                    <th>Quantity</th>                    <th>Unit Price =N=</th>                 </tr>@foreach(var CustomerOrderForEmail in Model.Orders) { <tr>                     <td> @CustomerOrderForEmail.foodname  </td>                    <td>" + model.Orders[0].Quantity + "</td>                    <td>" + model.Orders[0].UnitPrice + "</td>                </tr>}<tr>                    <td></td>                    <td><b>Total</td>                    <td><b>" + model.TotalCostWithoutTP + "<b></td>   </tr>                    </table><br /><br /><p>Transportaion: <b>=N=" + model.Transport + "</b></p>    <p>Total Cost: <b>=N=" + model.TotalCost + "</b></p> <br />            <br /><p>Delivery in 2 days or less. Please pay after inspecting your goods. No returns once payment is made.</p> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a></body></html>";
                string mailBody = "<html> <head> <style> table {    width:100%;} table, th, td { border: 1px solid #e56e94; border-collapse: collapse; } th, td { padding: 5px; text-align: left; } table#t01 tr:nth-child(even) { background-color: #ffffff;} table#t01 tr:nth-child(odd) { background-color:#ffdfdd; } table#t01 th	{ background-color: #810541; color: white; } </style> </head> <body> <body > <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive'; width:600px; background-color:#FBBBB9; padding:30px;'> <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font> </div>         <br /> <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'     font face='Helvetica, Arial, sans-serif' width:600px; height:600px; padding:30px; margin-top:30px;'>          <p>Order placed on " + model.OrderDate + " </p>             <p>Order Number: <b> " + model.OrderNumber + "</b></p> <table id='t01'>                 <tr>                    <th>Item</th>                    <th>Quantity</th>                    <th>Unit Price =N=</th>                  <th>Total Item Cost =N=</th></tr>";
                for (int i = 0; i < model.Orders.Count; i++)
                    mailBody += "<tr> <td>" + model.Orders[i].foodname + "</td>                     <td> " + model.Orders[i].Quantity + "</td>                       <td> " + model.Orders[i].BuyingPrice + "</td>                        <td>" + model.Orders[i].totalBuyingCost + "</td> </tr> ";
                mailBody += " </table></html>";

                MailMessage mailMessage = new MailMessage(LogonEmailAdd, LogonEmailAdd);//mailDefinition.CreateMailMessage(mailTo, ldReplacements, control); //(mailTo, ldReplacements,emailmessage,this );
                mailMessage.From = new MailAddress(LogonEmailAdd, "QuickySale Online Shopper");
                mailMessage.IsBodyHtml = true;
                mailMessage.Subject = "Market Shopping List";
                mailMessage.Body = mailBody;

                using (SmtpClient smtpClient = new SmtpClient("mail.quickysale.com", 25))
                {
                    smtpClient.Credentials = new System.Net.NetworkCredential()
                    {
                        UserName = LogonEmailAdd,
                        Password = LogonPwd
                    };
                    smtpClient.EnableSsl = false;
                    smtpClient.Send(mailMessage);
                };

            }
            catch (Exception ex)
            {
                ex.StackTrace.ToString();
                throw;
            }

        }

        public void SellerSendEmail(CustomerOrderForEmail model, string customeremailadd)
        {
            try
            {
                string Sellertemplate =
                @"<html>
                <head>
                <style>
                table {
                    width:100%;
                }
                table, th, td {
                    border: 1px solid #e56e94;
                    border-collapse: collapse;
                }
                th, td {
                    padding: 5px;
                    text-align: left;
                }
                table#t01 tr:nth-child(even) {
                    background-color: #ffffff;
                }
                table#t01 tr:nth-child(odd) {
                   background-color:#ffdfdd;
                }
                table#t01 th	{
                    background-color: #810541;
                    color: white;
                }
                </style>
                </head>
                <body >
                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';
                width:600px; background-color:#FBBBB9; padding:30px;'> 

                <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>
                        </div>
                        <br />


                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'
                    font face='Helvetica, Arial, sans-serif'
                width:600px; height:600px; padding:30px; margin-top:30px;'>

               
                <br />

                            <p>Please Find Below An Order Placed from Our Customer</p>
                            <br />
                <table id='t01';>
                                <tr>
                                    <th>Item</th>
                                    <th>Quantity</th>
                                    <th>Unit Price =N=</th>
                                    <th>Total Price =N=</th>
                                    <th>Seller Fee =N=</th>
                                    <th>Seller Balance =N=</th>

                                </tr>
                <tr>
                                    <td>@Model.foodname</td>
                                    <td>@Model.Quantity</td>
                                    <td>@Model.UnitPrice</td>
                                    <td>@Model.totalCustomerCost</td>
                                    <td>@Model.SellerFeeToBePaid</td>
                                    <td>@Model.SellerBalance</td>

                                </tr>

                
                            </table>
                <br />
                <br />
                <p>Please ensure Items are delivered to our Warehouse before 11am tomorrow, else Order will be cancelled</p>

                <br />
                            <a href='www.quickysale.com'><b>QuickySale</b></a>

                </body>
                </html>"

                ;
                //string mailBody = RazorEngine.Razor.Parse(Sellertemplate, model);
                string mailBody = "<html>                <head>                <style>                table {                    width:100%;                }                table, th, td {                    border: 1px solid #e56e94;                    border-collapse: collapse;                }                th, td {                    padding: 5px;                    text-align: left;                }                table#t01 tr:nth-child(even) {                    background-color: #ffffff;                }                table#t01 tr:nth-child(odd) {                   background-color:#ffdfdd;                }                table#t01 th	{                    background-color: #810541;                    color: white;                }                </style>                </head>                <body >                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';                width:600px; background-color:#FBBBB9; padding:30px;'>                <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>                        </div>                        <br />                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'                    font face='Helvetica, Arial, sans-serif'                width:600px; height:600px; padding:30px; margin-top:30px;'>                              <br />                            <p>Please Find Below An Order Placed from Our Customer</p>                            <br />                <table id='t01';>                                <tr>                                    <th>Item</th>                                    <th>Quantity</th>                                    <th>Unit Price =N=</th>                                    <th>Total Price =N=</th>                                    <th>Seller Fee =N=</th>                                    <th>Seller Balance =N=</th>                                </tr>                <tr>                                    <td>" + model.foodname + "</td>                                    <td>" + model.Quantity + "</td>                                    <td>" + model.UnitPrice + "</td>                                <td>" + model.totalCustomerCost + "</td>                                    <td>" + model.SellerFeeToBePaid + "</td>                                   <td>" + model.SellerBalance + "</td>                                </tr>                                           </table>                <br />                <br />                <p>Please ensure Items are delivered to our Warehouse before 11am tomorrow, else Order will be cancelled</p>                <br />                           <a href='www.quickysale.com'><b>QuickySale</b></a>                </body>                </html>";
                MailMessage mailMessage = new MailMessage(LogonEmailAdd, customeremailadd);//mailDefinition.CreateMailMessage(mailTo, ldReplacements, control); //(mailTo, ldReplacements,emailmessage,this );
                mailMessage.From = new MailAddress(LogonEmailAdd, "QuickySale Online Shopper");
                mailMessage.IsBodyHtml = true;
                mailMessage.Subject = "Order For You To Deliver ASAP";
                mailMessage.Body = mailBody;

                SmtpClient smtpClient = new SmtpClient("mail.quickysale.com", 25);
                
                    smtpClient.UseDefaultCredentials = false;
                    smtpClient.Credentials = new System.Net.NetworkCredential()
                    {
                        UserName = LogonEmailAdd,
                        Password = LogonPwd
                    };
                    smtpClient.EnableSsl = false;
                    smtpClient.Send(mailMessage);
                

            }
            catch (Exception ex)
            {
                ex.StackTrace.ToString();
                throw;
            }
           
        }


        public void AdminSellerFeesPerItem(string customer, OrderModel model)
        {
            try
            {
                string Admintemplate =
            @"<html>
                <head>
                <style>
                table {
                    width:100%;
                }
                table, th, td {
                    border: 1px solid #e56e94;
                    border-collapse: collapse;
                }
                th, td {
                    padding: 5px;
                    text-align: left;
                }
                table#t01 tr:nth-child(even) {
                    background-color: #ffffff;
                }
                table#t01 tr:nth-child(odd) {
                   background-color:#ffdfdd;
                }
                table#t01 th	{
                    background-color: #810541;
                    color: white;
                }
                </style>
                </head>
                <body >
                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';
                width:600px; background-color:#FBBBB9; padding:30px;'> 

                <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>
                        </div>
                        <br />


                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'
                    font face='Helvetica, Arial, sans-serif'
                width:600px; height:600px; padding:30px; margin-top:30px;'>

               
                <br />
<p>Order For @Model.CustomerName,<p>

                            <br />
                 <p>Order Number: <b>@Model.OrderNumber</b></p>
                 <p>Order Date: <b>@Model.OrderDate</b></p>
                <table id='t01';>
                                <tr>
                                    <th>Item</th>
                                    <th>Quantity</th>
                                    <th>Unit Price =N=</th>
                                    <th>Total Price =N=</th>
                                    <th>Seller Fee =N=</th>
                                    <th>Seller Balance =N=</th>
                                    <th>Seller Name</th>

                                </tr>
                @foreach(var CustomerOrderForEmail in Model.Orders) {
                <tr>
                                    <td>@CustomerOrderForEmail.foodname</td>
                                    <td>@CustomerOrderForEmail.Quantity</td>
                                    <td>@CustomerOrderForEmail.UnitPrice</td>
                                    <td>@CustomerOrderForEmail.totalCustomerCost</td>
                                    <td>@CustomerOrderForEmail.SellerFeeToBePaid</td>
                                    <td>@CustomerOrderForEmail.SellerBalance</td>
                                    <td>@CustomerOrderForEmail.SellerName</td>
                                </tr>
                }
                
                            </table>
<br />
 

<br />
 <br />
            <p>Thank you for allowing us serve you...</p><br />
            <a href='www.quickysale.com'><b>QuickySale</b></a>
              
                </body>
                </html>"

            ;
                //string mailBody = RazorEngine.Razor.Parse(Admintemplate, model);
               // string mailBody = "<html>                <head>                <style>                table {                    width:100%;                }                table, th, td {                    border: 1px solid #e56e94;                    border-collapse: collapse;                }                th, td {                    padding: 5px;                    text-align: left;                }                table#t01 tr:nth-child(even) {                    background-color: #ffffff;                }                table#t01 tr:nth-child(odd) {                   background-color:#ffdfdd;                }                table#t01 th	{                    background-color: #810541;                    color: white;                }                </style>                </head>                <body >                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';                width:600px; background-color:#FBBBB9; padding:30px;'>                 <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>                        </div>                        <br />                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'                    font face='Helvetica, Arial, sans-serif'                width:600px; height:600px; padding:30px; margin-top:30px;'>                               <br /><p>Order For " + model.CustomerName + ",<p>                            <br />                 <p>Order Number: <b>" + model.OrderNumber + "</b></p>                  <p>Order Date: <b>" + model.OrderDate + "</b></p>                <table id='t01';>                                <tr>                                    <th>Item</th>                                    <th>Quantity</th>                                    <th>Unit Price =N=</th>                                    <th>Total Price =N=</th>                                    <th>Seller Fee =N=</th>                                    <th>Seller Balance =N=</th>                                <th>Seller Name</th>                                </tr>                @foreach(var CustomerOrderForEmail in Model.Orders) {                <tr>                                    <td>" + model.Orders[0].foodname + "</td>                                     <td>" + model.Orders[0].foodname + "</td>                                    <td>" + model.Orders[0].Quantity + "</td>                                    <td>" + model.Orders[0].totalCustomerCost + "</td>                                    <td>" + model.Orders[0].SellerFeeToBePaid + "</td>                                    <td>" + model.Orders[0].SellerBalance + "</td>                                    <td>" + model.Orders[0].SellerName + "</td>                                </tr>                }                                           </table><br /><br /> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a>                              </body>                </html>";
                string mailBody = "<html>                <head>                <style>                table {                    width:100%;                }                table, th, td {                    border: 1px solid #e56e94;                    border-collapse: collapse;                }                th, td {                    padding: 5px;                    text-align: left;                }                table#t01 tr:nth-child(even) {                    background-color: #ffffff;                }                table#t01 tr:nth-child(odd) {                   background-color:#ffdfdd;                }                table#t01 th	{                    background-color: #810541;                    color: white;                }                </style>                </head>                <body >                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';                width:600px; background-color:#FBBBB9; padding:30px;'>                 <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>                        </div>                        <br />                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'                    font face='Helvetica, Arial, sans-serif'                width:600px; height:600px; padding:30px; margin-top:30px;'>                               <br /><p>Order For " + model.CustomerName + ",<p>                            <br />                 <p>Order Number: <b>" + model.OrderNumber + "</b></p>                  <p>Order Date: <b>" + model.OrderDate + "</b></p>                <table id='t01';>                                <tr>                                    <th>Item</th>                                    <th>Quantity</th>                                    <th>Unit Price =N=</th>                                    <th>Total Price =N=</th>                                    <th>Seller Fee =N=</th>                                    <th>Seller Balance =N=</th>                                <th>Seller Name</th>                                </tr>                ";
                for (int i = 0; i < model.Orders.Count; i++)
                    mailBody += "                <tr>                                    <td>" + model.Orders[i].foodname + "</td>                                     <td>" + model.Orders[i].Quantity + "</td>                                    <td>" + model.Orders[i].UnitPrice + "</td>                                    <td>" + model.Orders[i].totalCustomerCost + "</td>                                    <td>" + model.Orders[i].SellerFeeToBePaid + "</td>                                    <td>" + model.Orders[i].SellerBalance + "</td>                                    <td>" + model.Orders[i].SellerName + "</td>                                </tr> ";
                mailBody += "                                           </table><br /><br /> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a>                              </body>                </html>";

                MailMessage mailMessage = new MailMessage(LogonEmailAdd, LogonEmailAdd);//mailDefinition.CreateMailMessage(mailTo, ldReplacements, control); //(mailTo, ldReplacements,emailmessage,this );
                mailMessage.From = new MailAddress(LogonEmailAdd, "QuickySale Online Shopper");
                mailMessage.IsBodyHtml = true;
                mailMessage.Subject = "Seller's Fees";
                mailMessage.Body = mailBody;

                using (SmtpClient smtpClient = new SmtpClient("mail.quickysale.com", 25)) { 
                smtpClient.Credentials = new System.Net.NetworkCredential()
                {
                    UserName = LogonEmailAdd,
                    Password = LogonPwd
                };
                smtpClient.EnableSsl = false;
                smtpClient.Send(mailMessage);
            };
            }
            catch (Exception ex)
            {
                ex.StackTrace.ToString();
                throw;
            }
        }

         public void AdminSendEmail(string customer, OrderModel model)
         {
             try
             {
                   string Admintemplate =
               @"<html>
                <head>
                <style>
                table {
                    width:100%;
                }
                table, th, td {
                    border: 1px solid #e56e94;
                    border-collapse: collapse;
                }
                th, td {
                    padding: 5px;
                    text-align: left;
                }
                table#t01 tr:nth-child(even) {
                    background-color: #ffffff;
                }
                table#t01 tr:nth-child(odd) {
                   background-color:#ffdfdd;
                }
                table#t01 th	{
                    background-color: #810541;
                    color: white;
                }
                </style>
                </head>
                <body >
                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';
                width:600px; background-color:#FBBBB9; padding:30px;'> 

                <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>
                        </div>
                        <br />


                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'
                    font face='Helvetica, Arial, sans-serif'
                width:600px; height:600px; padding:30px; margin-top:30px;'>

               
                <br />
<p>Order For @Model.CustomerName,<p>

                            <br />
                 <p>Order Number: <b>@Model.OrderNumber</b>     RECEIPT</p>
                <table id='t01';>
                                <tr>
                                    <th>Item</th>
                                    <th>Quantity</th>
                                    <th>Unit Price =N=</th>
                                    <th>Total Item Price =N=</th>

                                </tr>
                @foreach(var CustomerOrderForEmail in Model.Orders) {
                <tr>
                                    <td>@CustomerOrderForEmail.foodname</td>
                                    <td>@CustomerOrderForEmail.Quantity</td>
                                    <td>@CustomerOrderForEmail.UnitPrice</td>
                                    <td>@CustomerOrderForEmail.TotalCustomerCost</td>
                                </tr>
                }
<tr>
                    <td></td>
                    <td><b>Total</td>
                    <td><b>@Model.TotalCostWithoutTP<b></td>
  </tr> 
                
                            </table>
<br />
<br />
<p>Transportaion: <b>=N=@Model.Transport</b></p>
    <p>Total Cost: <b>=N=@Model.TotalCost</b></p>
    

<br />
 <br />
            <p>Thank you for allowing us serve you...</p><br />
            <a href='www.quickysale.com'><b>QuickySale</b></a>
              
                </body>
                </html>"

               ;
                   //string mailBody = RazorEngine.Razor.Parse(Admintemplate, model);

                   //string mailBody = "<html>                <head>                <style>               table {                    width:100%;                }                table, th, td {                    border: 1px solid #e56e94;                    border-collapse: collapse;                }                th, td {                    padding: 5px;                    text-align: left;                }                table#t01 tr:nth-child(even) {                    background-color: #ffffff;                }                table#t01 tr:nth-child(odd) {                   background-color:#ffdfdd;                }                table#t01 th	{                    background-color: #810541;                    color: white;                }                </style>                </head>                <body >                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';                width:600px; background-color:#FBBBB9; padding:30px;'>                 <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>                       </div>                        <br />                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'                    font face='Helvetica, Arial, sans-serif'                width:600px; height:600px; padding:30px; margin-top:30px;'>                               <br /><p>Order For " + model.CustomerName + ",<p>                            <br />                 <p>Order Number: <b>" + model.OrderNumber + "</b></p>                <table id='t01';>                                <tr>                                    <th>Item</th>                                    <th>Quantity</th>                                    <th>Unit Price =N=</th>                                </tr>                @foreach(var CustomerOrderForEmail in Model.Orders) {                <tr>                                    <td>" + model.Orders[0].foodname + "</td>                                    <td>" + model.Orders[0].Quantity + "</td>                                    <td>" + model.Orders[0].UnitPrice + "</td>                                </tr>                }<tr>                    <td></td>                    <td><b>Total</td>                    <td><b>" + model.TotalCostWithoutTP + "<b></td>   </tr>                                             </table><br /><br /><p>Transportaion: <b>=N=" + model.Transport + "</b></p>    <p>Total Cost: <b>=N=" + model.TotalCost + "</b></p><br /> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a>                             </body>                </html>";
                   string mailBody = "<html>                <head>                <style>               table {                    width:100%;                }                table, th, td {                    border: 1px solid #e56e94;                    border-collapse: collapse;                }                th, td {                    padding: 5px;                    text-align: left;                }                table#t01 tr:nth-child(even) {                    background-color: #ffffff;                }                table#t01 tr:nth-child(odd) {                   background-color:#ffdfdd;                }                table#t01 th	{                    background-color: #810541;                    color: white;                }                </style>                </head>                <body >                <div style='position:absolute; height:50px; font-size:15px; font face = 'cursive';                width:600px; background-color:#FBBBB9; padding:30px;'>                 <font color='#F6358A'; face='fantasy'>QUICKYSALE</font><font color='#F6358A'; face='ar hermann'> ONLINE FOOD SHOPPER!</font>                       </div>                        <br />                <div style='background-color: #ece8d4;style='color:grey; font-size:15px;'                    font face='Helvetica, Arial, sans-serif'                width:600px; height:600px; padding:30px; margin-top:30px;'>                               <br /><p>Order For " + model.CustomerName + ",<p>                            <br />                 <p>Order Number: <b>" + model.OrderNumber + "                 --    RECEIPT </b></p>                <p>Order Date: <b>" + model.OrderDate + "</b></p>                <table id='t01';>                                <tr>                                    <th>Item</th>                                    <th>Quantity</th>                                    <th>Unit Price =N=</th>                               <th>Total Item Price =N=</th> </tr>                ";
                   for (int i = 0; i < model.Orders.Count; i++)
                       mailBody += "              <tr>                                    <td>" + model.Orders[i].foodname + "</td>                                    <td>" + model.Orders[i].Quantity + "</td>                                    <td>" + model.Orders[i].UnitPrice + "</td>                                    <td>" + model.Orders[i].totalCustomerCost + "</td>                                 </tr>";
                   mailBody += "<tr>                    <td></td>                    <td><b>Total</td>       <td></td>             <td><b>" + model.TotalCostWithoutTP + "<b></td>   </tr>                                             </table><br /><br /><p>Transportaion: <b>=N=" + model.Transport + "</b></p>    <p>Total Cost: <b>=N=" + model.TotalCost + "</b></p><br /> <br />            <p>Thank you for allowing us serve you...</p><br />            <a href='www.quickysale.com'><b>QuickySale</b></a>                             </body>                </html>";

                   MailMessage mailMessage = new MailMessage(LogonEmailAdd, LogonEmailAdd);//mailDefinition.CreateMailMessage(mailTo, ldReplacements, control); //(mailTo, ldReplacements,emailmessage,this );
                   mailMessage.From = new MailAddress(LogonEmailAdd, "QuickySale Online Shopper");
                   mailMessage.IsBodyHtml = true;
                   mailMessage.Subject = "New Order Received (Customer's Receipt)";
                   mailMessage.Body = mailBody;

                   using (SmtpClient smtpClient = new SmtpClient("mail.quickysale.com", 25)) { 
                   smtpClient.Credentials = new System.Net.NetworkCredential()
                   {
                       UserName = LogonEmailAdd,
                       Password = LogonPwd
                   };
                   smtpClient.EnableSsl = false;
                   smtpClient.Send(mailMessage);
             };
             }
             catch (Exception ex)
             {
                 ex.StackTrace.ToString();
                 throw;
             }
         }
        public void SendEmail(string emailbody, string emailAdd, string subject)
        {
            try
            {
               MailMessage mailmessage = new MailMessage(AdminEmailAdd, emailAdd);
                mailmessage.Subject = subject;
                mailmessage.Body = emailbody;

                using (SmtpClient smptclient = new SmtpClient("mail.quickysale.com", 25))
                {//587   smtp.mail.yahoo.com mail.quickysale.com 25
                    smptclient.Credentials = new System.Net.NetworkCredential()
                    {
                        UserName = LogonEmailAdd,
                        Password = LogonPwd
                    };
                    smptclient.EnableSsl = false;
                    smptclient.Send(mailmessage);
                    //Console.WriteLine("message sent");
                };
            }
            catch (Exception ex)
            {
                ex.StackTrace.ToString();
                throw;
            }


        }

        public Boolean writeToFile(string location, string message)
        {
            try
            {
                string filename = "C:\\Users\\j komo\\Documents\\QuickySaleOrderReceipts\\" + DateTime.Now.ToString() + ".txt";
                StreamWriter sw = new StreamWriter(filename);
                sw.WriteLine(message);
                sw.Flush();
                sw.Close();
                return true;
            }
            catch (Exception ex)
            {

                ex.StackTrace.ToString(); ;
                return false;
            }
            
        }

       // public void Dispose();
    }
}
