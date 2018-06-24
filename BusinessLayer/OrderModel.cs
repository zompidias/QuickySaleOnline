using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class OrderModel
    {
        public List<CustomerOrderForEmail> Orders { get; set; }
        public string CustomerName { get; set; }
        public decimal TotalCost { get; set; }
        public decimal TotalCostWithoutTP { get; set; }
        public decimal Transport { get; set; }
        public string OrderNumber { get; set; }
        public string OrderDate { get; set; }
        public string CustomerAddress { get; set; }
        public string CustomerEmail { get; set; }
        public string CustomerPhone { get; set; }
    }
}
