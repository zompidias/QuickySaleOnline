using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessLayer;
using QuickySaleOnlineShopper.Models;

namespace QuickySaleOnlineShopper.Controllers
{
    public class HomeController : Controller
    {
        OnlineStoreEntities storeDB = new OnlineStoreEntities();
        BusinessLayer.ShoppingCart sc = new BusinessLayer.ShoppingCart();
        StoreBusinessLayer dbset = new StoreBusinessLayer();
        //[OutputCache(Duration=600)]
        public ActionResult Index()
        {
            //Get Guest as login detail
            var cartid = sc.GetCartId(this.HttpContext);
            if (!sc.ConfirmMemberisLoggedIn(cartid))
            {
                sc.AddGuestBrowserTotblUserProfile(cartid);
            }
           

            
            //ViewData["MobileFoodGroup"]
           /* if ((Request.Browser.IsMobileDevice)) { 
                    if (Request.UserAgent.IndexOf("mobile", StringComparison.OrdinalIgnoreCase) < 1)  //(Request.Browser.IsMobileDevice)
                    {
                       
                            var topFoods = GetTopSellingAlbums(6);
                            return View(topFoods);
                        
                        
                    }
                    else if (Request.UserAgent.IndexOf("mobile", StringComparison.OrdinalIgnoreCase) >=1)
                    {
                        // var Foodgrp = storeDB.FoodGroups.ToList();
                        return RedirectToAction("Index", "Store");
                    }

                    else
                    {
                        var topFoods = GetTopSellingAlbums(6);
                        return View(topFoods);
                    }
                    }
            else 
            {*/
                var topFoods = GetTopSellingAlbums(6);
                return View(topFoods);
            //}
            
        }

       

        private List<QuickySaleOnlineShopper.Models.FoodItem> GetTopSellingAlbums(int count)
        {
            // Group the order details by album and return
            // the albums with the highest count
            return storeDB.FoodItems
                .OrderByDescending(a => a.CustomerOrderDetails.Count())
                .Take(count)
                .ToList();
        }

        private List<QuickySaleOnlineShopper.Models.FoodItem> GetBottomSellingFood(int count)
        {
            // Group the order details by album and return
            // the albums with the highest count
            return storeDB.FoodItems
                .OrderByDescending(a=> a.FoodName)
                //.OrderBy(a => a.CustomerOrderDetails.Count())
                .Take(count)
                .ToList();
        }

        [ChildActionOnly]
        public ActionResult PromotionAd()
        {
            var topFoods = GetBottomSellingFood(8);
            //var genres = storeDB.FoodGroups.ToList();

            return PartialView(topFoods);

           
        }
        
    }
}
