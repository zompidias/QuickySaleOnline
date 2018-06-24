using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class FoodWeightType
    {
        public decimal FoodWeightTypeId { get; set; }
        public string FoodWeightTypeName { get; set; }
        public FoodItem foodItem { get; set; }
    }
}
