using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblSubFoodGroup")]
    public class SubFoodGroup
    {
        public decimal SubFoodGroupId { get; set; }
        public string SubFoodGroupName { get; set; }
       // [ForeignKey("FoodGroupId")]
        public decimal FoodGroupId { get; set; }
        public FoodGroup FoodGroup { get; set; }

        public List<FoodItem> FoodItems { get; set; }
        //public List<FoodGroup> FoodGroups { get; set; }
    }
}