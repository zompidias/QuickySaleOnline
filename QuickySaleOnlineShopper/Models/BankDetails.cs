using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
     [Table("tblBankDetails")]
    public class BankDetails
    {
        [Key]
        public decimal BankId { get; set; }
        public string BankName { get; set; }
        public QSSellerDetail QSSellerDetails { get; set; }
    }
}