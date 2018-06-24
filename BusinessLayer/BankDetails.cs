using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class BankDetails
    {
        [Key]
        public decimal BankId { get; set; }
        public string BankName { get; set; }
    }
}
