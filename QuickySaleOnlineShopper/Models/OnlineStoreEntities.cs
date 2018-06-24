using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace QuickySaleOnlineShopper.Models
{
    public class OnlineStoreEntities : DbContext
    {
        public DbSet<FoodGroup> FoodGroups { get; set; }
        public DbSet<FoodItem> FoodItems { get; set; }
        public DbSet<SubFoodGroup> SubFoodGroups { get; set; }
        public DbSet<FoodWeightType> FoodWeightTypes { get; set; }

       public DbSet<QSSellerDetail> QSSellerDetails { get; set; }
        public DbSet<CustomerDetail> CustomerDetails { get; set; }
        public DbSet<CustomerOrderDetail> CustomerOrderDetails { get; set; }
        public DbSet<StoreCart> StoreCarts { get; set; }
        public DbSet<OrderNumber> OrderNumbers { get; set; }
        public DbSet<ContactUs> ContactUss { get; set; }
        public DbSet<BankDetails> BankDetailss { get; set; }
        public DbSet<State> States { get; set; }

    }
}