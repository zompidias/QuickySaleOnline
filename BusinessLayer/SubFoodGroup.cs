using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class SubFoodGroup
    {
        [Key]
        public decimal SubFoodGroupId { get; set; }
        public string SubFoodGroupName { get; set; }
        public decimal FoodGroupId { get; set; }
        public FoodGroup FoodGroup { get; set; }

        public List<FoodItem> FoodItems { get; set; }
    }
}
