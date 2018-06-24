using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class State
    {
        public decimal StateId { get; set; }
        public string StateName { get; set; }
        public virtual CustomerDetail CustomerDetails { get; set; }
    }
}
