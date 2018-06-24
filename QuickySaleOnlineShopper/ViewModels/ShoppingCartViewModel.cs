using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using QuickySaleOnlineShopper.Models;

namespace QuickySaleOnlineShopper.ViewModels
{
    public class ShoppingCartViewModel
    {
        public List<StoreCart> StoreCart { get; set; }
        public decimal CartTotal { get; set; }

    }
}