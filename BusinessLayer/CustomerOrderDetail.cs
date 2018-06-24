using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class CustomerOrderDetail
    {
        [Key]
        public decimal CustomerOrderDetailId { get; set; }
        public decimal CustomerDetailId { get; set; }
        public decimal FoodItemId { get; set; }
        public int Quantity { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal StoreCartId { get; set; }
        public virtual FoodItem FoodItem { get; set; }
        public virtual StoreCart StoreCarts { get; set; }
        public virtual CustomerDetail CustomerDetail { get; set; }

    }
}
