using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblStoreCart")]
    public class StoreCart
    {
        [Key]
        public decimal RecordId { get; set; }
        public string StoreCartId { get; set; }
        public decimal FoodItemId { get; set; }
        public int Count { get; set; }
        public System.DateTime? DateCreated { get; set; }
        public virtual FoodItem FoodItems { get; set; }
    }
}