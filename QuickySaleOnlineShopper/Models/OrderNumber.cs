using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    
        [Table("tblOrderNumber")]
       public class OrderNumber
        {
            [Key]
            public decimal OrderNumberId { get; set; }
            public string StoreCartId { get; set; }
            public string UserName { get; set; }
        }
    
}