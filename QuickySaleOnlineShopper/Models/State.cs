using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    [Table("tblState")]
    public class State
    {
        public decimal StateId { get; set; }
        public string StateName { get; set; }
        public virtual CustomerDetail CustomerDetails { get; set; }
    }
}