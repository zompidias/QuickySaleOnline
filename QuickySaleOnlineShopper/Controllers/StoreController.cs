using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuickySaleOnlineShopper.Models;
using BusinessLayer;

namespace QuickySaleOnlineShopper.Controllers
{
    public class StoreController : Controller
    {
        //
        // GET: /Store/
        private OnlineStoreEntities storeDB = new OnlineStoreEntities();
        StoreBusinessLayer dbset = new StoreBusinessLayer();
       // BusinessLayer.ShoppingCart sc = new BusinessLayer.ShoppingCart();

       // [OutputCache(Duration = 600)]
        public ActionResult Index()
        {
            //Get Guest as login detail
            BusinessLayer.ShoppingCart sc = new BusinessLayer.ShoppingCart();
            //sc.AddGuestBrowserTotblUserProfile();

            /* var genres = new List<FoodGroup>
             {
                 new FoodGroup{FoodGroupName = "Cereal and Grains"},
                 new FoodGroup{FoodGroupName = "Fats and Oils"},
                 new FoodGroup{FoodGroupName = "Vegetable"},
                 new FoodGroup{FoodGroupName = "Diary"},
                 new FoodGroup{FoodGroupName = "Proteins"},
             };*/

            //var genres = storeDB.FoodGroups.ToList();
            var genres = storeDB.FoodGroups.OrderBy(a => a.FoodGroupName).ToList();

            return View(genres);
        }

       // [ChildActionOnly]
        public ActionResult Browse(decimal id)
        {
            // string message = HttpUtility.HtmlEncode("Store.Browse, Genre = "+ genre);
            //var FoodGroupModel = new FoodGroup { FoodGroupName = genre };

            //var FoodGroupModel = storeDB.SubFoodGroups.OrderBy(a => a.SubFoodGroupName).Where(zx => zx.FoodGroupId == id).ToList();//Where(grp => grp.FoodGroupId == id).ToList();
            var FoodGroupModel = storeDB.FoodItems.Include("QSSellerDetail").Where(grs => grs.FoodGroupId == id && grs.QuantityAvailable > 0).OrderBy(a => a.FoodName).ToList();
            if (FoodGroupModel.Count > 0) { return View("SubBrowse", FoodGroupModel); ;} // return View(FoodGroupModel);
            else { return View("ErrorEmptyGroup"); }
           // var FoodGroupModel = storeDB.SubFoodGroup.Where(grp => grp.FoodGroupId == id).ToList();// { FoodGroupId = genre };
            
        }

       // [ChildActionOnly]
        public ActionResult SubBrowse(decimal id)
        {
            var fdgrp = storeDB.FoodItems.Include("QSSellerDetail").OrderBy(a => a.FoodName).Where(grs => grs.SubFoodGroupId == id && grs.QuantityAvailable > 0).ToList();
            
            if (fdgrp.Count > 0) { return View(fdgrp); ;}
            else { return View("ErrorEmptyGroup"); }
        }
        public ActionResult SearchItem(string search)
        {
            // var fdgrp = storeDB.FoodItems.Where(grs => grs.FoodName.StartsWith(str)).ToList();
            var fdgrp = dbset.GetSearchRequest(search);
            if (fdgrp.ToList().Count > 0)
            {
                ViewData["FoodWeightTypeName"] = storeDB.FoodWeightTypes.ToList();
                //ViewBag.FoodWeightTypeId = new SelectList(dbset.FoodWeightTypes.OrderBy(x => x.FoodWeightTypeName), "FoodWeightTypeId", "FoodWeightTypeName");
                return View(fdgrp);
            }
            else { return View("ErrorEmptyGroup"); }
        }

        public ActionResult Details(decimal id)
        {
            //var fooditem = storeDB.FoodItems.Include(s => s.).Include(y => y.SubFoodGroup).Include(y => y.FoodWeightType).Include(z => z.QSSellerDetail).Single(emp => emp.FoodItemId == id);
            var fooditem = storeDB.FoodItems.Include("FoodGroup").Include("SubFoodGroup").Include("FoodWeightType").Include("QSSellerDetail").Single(emp => emp.FoodItemId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
            return View(fooditem);
        }

       // [ChildActionOnly]
       // [OutputCache(Duration = 600)]
        public ActionResult FoodGroupMenu()
        {
            var genres = storeDB.FoodGroups.OrderBy(a=> a.FoodGroupName).ToList();
            return PartialView(genres);
        }
    }
}
