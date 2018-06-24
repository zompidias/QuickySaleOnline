using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class FoodGroup
    {
        public string FoodGroupName { get; set; }
        public decimal FoodGroupId { get; set; }
        public List<SubFoodGroup> SubFoodGroups { get; set; }
        public List<FoodItem> FoodItems { get; set; }
    }
}
