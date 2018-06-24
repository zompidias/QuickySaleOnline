using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblFoodGroup")]
    public class FoodGroup
    {

        public string FoodGroupName { get; set; }
        public decimal FoodGroupId { get; set; }
        public List<SubFoodGroup> SubFoodGroups { get; set; }
       // public List<FoodItem> FoodItems { get; set; }
    }
}