using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblCustomerOrderDetail")]
    public class CustomerOrderDetail
    {
        [Key]
        public decimal CustomerOrderDetailId { get; set; }
        public decimal CustomerDetailId { get; set; }
        public decimal FoodItemId { get; set; }
        public int Quantity { get; set; }
        [DisplayFormat(DataFormatString = "{0:0,0}")]

        public decimal UnitPrice { get; set; }
        public string StoreCartId { get; set; }
        public virtual FoodItem FoodItem { get; set; }
        public virtual StoreCart StoreCarts { get; set; }
        public virtual CustomerDetail CustomerDetail { get; set; }
    }
}