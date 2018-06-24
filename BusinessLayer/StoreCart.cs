using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class StoreCart
    {
        [Key]
        public decimal RecordId { get; set; }
        public string StoreCartId { get; set; }
        public decimal FoodItemId { get; set; }
        //public string FoodName { get; set; }
        public int Count { get; set; }
        public System.DateTime? DateCreated { get; set; }
        public virtual FoodItem FoodItems { get; set; }

    }
}
