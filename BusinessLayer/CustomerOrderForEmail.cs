using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class CustomerOrderForEmail
    {
        public string e_mail_address { get; set; }
        public string foodname { get; set; }
        public string orderDate { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal BuyingPrice { get; set; }
        public string OrderNumber { get; set; }
        public decimal SellerFeeToBePaid { get; set; }
        public decimal SellerBalance { get; set; }
        public string SellerName { get; set; }
        public decimal totalCustomerCost { get; set; }
        public decimal totalBuyingCost { get; set; }

        
    }
}
