﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BusinessLayer
{
    public class ShoppingCartViewModel
    {
        public List<StoreCart> StoreCart { get; set; }
        public decimal CartTotal { get; set; }
    }
}
