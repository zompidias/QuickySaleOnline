using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblFoodItem")]
    public class FoodItem
    {
        public decimal FoodItemId { get; set; }
        public string FoodName { get; set; }
        [DisplayName("FoodGroup")]
        public decimal FoodGroupId { get; set; }
        [DisplayName("SubFoodGroup")]

        public decimal SubFoodGroupId { get; set; }
        [DisplayFormat(DataFormatString = "{0:0,0}")]
        //[DataType(DataType.Currency)]

        public decimal FoodCost { get; set; }

        [DisplayName("FoodPackage")]
        public decimal FoodWeightTypeId { get; set; }
        public int QuantityAvailable { get; set; }
        [DisplayFormat(DataFormatString = "{0:0,0}")]

        public decimal BuyingPrice { get; set; }
        [DisplayName("Seller")]

        public decimal SellerId { get; set; }
        public string FoodPicture { get; set; }
        public string AlternateText { get; set; }
        public virtual FoodGroup FoodGroup { get; set; }
        public virtual SubFoodGroup SubFoodGroup { get; set; }
        public virtual FoodWeightType FoodWeightType { get; set; }
        public virtual QSSellerDetail QSSellerDetail { get; set; }
        public virtual List<CustomerOrderDetail> CustomerOrderDetails { get; set; }

    }
}