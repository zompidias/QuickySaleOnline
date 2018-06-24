using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblSellerDetails")]
    public class QSSellerDetail
    {
        [Key]
        public decimal SellerId { get; set; }
        public string SellerName { get; set; }
        public string SellerState { get; set; }
        public string SellerAddress { get; set; }
        public string SellerPhoneNumber { get; set; }

        [Required(ErrorMessage = "Email is Required")]
        [RegularExpression(@"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}", ErrorMessage = "Email is not Valid")]
       
        public string SellerEmail { get; set; }
        public string SellerAccountNumber { get; set; }
        //[ForeignKey]
        public decimal BankId { get; set; }
        public string SellerAccountName { get; set; }
        public List<FoodItem> FoodItems { get; set; }
        public List<BankDetails> BankDetails { get; set; }
    }
}