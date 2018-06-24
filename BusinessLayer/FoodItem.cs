using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class FoodItem
    {
        public decimal FoodItemId { get; set; }
        [Required]
        public string FoodName { get; set; }
        [Required]
        [DisplayName("FoodGroup")]

        public decimal FoodGroupId { get; set; }
        [Required]
        [DisplayName("FoodSubGroup")]

        public decimal SubFoodGroupId { get; set; }
        [Required]
        [DisplayFormat(DataFormatString = "{0:0,0}")]
        //[DataType(DataType.Currency)]

        public decimal FoodCost { get; set; }

        [DisplayName("FoodPackage")]
        public decimal FoodWeightTypeId { get; set; }
        public int QuantityAvailable { get; set; }
        [DisplayFormat(DataFormatString = "{0:0,0}")]

        public decimal BuyingPrice { get; set; }
        [Required]
        [DisplayName("Seller")]

        public decimal SellerId { get; set; }
        public string FoodPicture { get; set; }

        public string AlternateText { get; set; }
        public FoodGroup FoodGroup { get; set; }
        public SubFoodGroup SubFoodGroup { get; set; }
        public QSSellerDetail SellerDetail { get; set; }
        public FoodWeightType FoodWeightType { get; set; }
    }
}
