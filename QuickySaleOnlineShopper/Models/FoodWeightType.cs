using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblFoodWeightType")]
    public class FoodWeightType
    {
        public decimal FoodWeightTypeId { get; set; }
        public string FoodWeightTypeName { get; set; }
        public List<FoodItem> FoodItems { get; set; }
    }
}