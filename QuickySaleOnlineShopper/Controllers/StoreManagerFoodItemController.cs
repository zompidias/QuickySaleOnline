using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Entity;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuickySaleOnlineShopper.Models;
using BusinessLayer;
using PagedList;
using PagedList.Mvc;

namespace QuickySaleOnlineShopper.Controllers
{
    //[Authorize]
    public class StoreManagerFoodItemController : Controller
    {
        private OnlineStoreEntities db = new OnlineStoreEntities();
        StoreBusinessLayer dbset = new StoreBusinessLayer();

        //
        // GET: /StoreManagerFoodItem/
   // [ChildActionOnly]
    
        public ActionResult Index(int? page, string sortBy)
        {
            ViewBag.SortNameParameter = string.IsNullOrEmpty(sortBy) ? "Name Desc" : "";
            var SortedFoodItems = db.FoodItems.AsQueryable();

            //var fd = db.FoodItems.Include(x => x.FoodGroup).Include(y => y.SubFoodGroup).Include(y => y.FoodWeightType).Include(z => z.QSSellerDetail); //db.Albums.Include(a => a.Genre).Include(a => a.Artist);
            //return View(fd.ToList().ToPagedList(page ?? 1, 25));    
        
        SortedFoodItems= SortedFoodItems.Include(x => x.FoodGroup).Include(y => y.SubFoodGroup).Include(y => y.FoodWeightType).Include(z => z.QSSellerDetail); //db.Albums.Include(a => a.Genre).Include(a => a.Artist);
        switch (sortBy)
            {
            case "Name desc":
                    SortedFoodItems = SortedFoodItems.OrderByDescending(x => x.FoodName);
                    break;
            default:
                SortedFoodItems = SortedFoodItems.OrderBy(x => x.FoodName);
                    break;
            }
        return View(SortedFoodItems.ToPagedList(page ?? 1, 25));
        }

        //
        // GET: /StoreManagerFoodItem/Details/5

        public ActionResult Details(decimal id)
        {
            var fooditem = db.FoodItems.Include(x => x.FoodGroup).Include(y => y.SubFoodGroup).Include(y => y.FoodWeightType).Include(z => z.QSSellerDetail).Single(emp => emp.FoodItemId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
            return View(fooditem);
        }

        //
        // GET: /StoreManagerFoodItem/Create
        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName");
            ViewBag.SubFoodGroupId = new SelectList(dbset.SubFoodGroups.OrderBy(x => x.SubFoodGroupName), "SubFoodGroupId", "SubFoodGroupName");
            ViewBag.FoodWeightTypeId = new SelectList(dbset.FoodWeightTypes.OrderBy(x => x.FoodWeightTypeName), "FoodWeightTypeId", "FoodWeightTypeName");
            ViewBag.SellerId = new SelectList(dbset.SellerDetails.OrderBy(x => x.SellerAccountName), "SellerId", "SellerName");

            return View();
        }

        //
        // POST: /StoreManagerFoodItem/Create

        [HttpPost]
        //[ActionName("Create")]
        //[ValidateAntiForgeryToken]
        public ActionResult Create(BusinessLayer.FoodItem fooditem)//Create(FormCollection formCollection)
        {

            if (ModelState.IsValid)
            {
                dbset.AddFoodItemToDB(fooditem);
                return RedirectToAction("Index");
            }
            /*FoodItem fooditem = new FoodItem();
            // Retrieve form data using form collection
            fooditem.FoodName = formCollection["FoodName"];
            fooditem.FoodGroupId = Convert.ToDecimal(formCollection["FoodGroupId"]);
            fooditem.FoodCost = Convert.ToDecimal(formCollection["FoodCost"]);
            fooditem.FoodWeightTypeId = Convert.ToDecimal(formCollection["FoodWeightTypeId"]);
            fooditem.SellerId = Convert.ToDecimal(formCollection["SellerId"]);
            fooditem.QuantityAvailable = Convert.ToInt32(formCollection["QuantityAvailable"]);
            fooditem.SubFoodGroupId = Convert.ToDecimal(formCollection["SubFoodGroupId"]);
            */
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName");
            ViewBag.SubFoodGroupId = new SelectList(dbset.SubFoodGroups.OrderBy(x => x.SubFoodGroupName), "SubFoodGroupId", "SubFoodGroupName");
            ViewBag.FoodWeightTypeId = new SelectList(dbset.FoodWeightTypes.OrderBy(x => x.FoodWeightTypeName), "FoodWeightTypeId", "FoodWeightTypeName");
            ViewBag.SellerId = new SelectList(dbset.SellerDetails.OrderBy(x => x.SellerAccountName), "SellerId", "SellerName");

            return View();

        }

        //
        // GET: /StoreManagerFoodItem/Edit/5
        [HttpGet]
        public ActionResult Edit(decimal id)
        {
            BusinessLayer.FoodItem fooditem = dbset.FoodItems.Single(emp => emp.FoodItemId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName", fooditem.FoodGroupId);
            ViewBag.SubFoodGroupId = new SelectList(dbset.SubFoodGroups.OrderBy(x => x.SubFoodGroupName), "SubFoodGroupId", "SubFoodGroupName", fooditem.SubFoodGroupId);
            ViewBag.FoodWeightTypeId = new SelectList(dbset.FoodWeightTypes.OrderBy(x => x.FoodWeightTypeName), "FoodWeightTypeId", "FoodWeightTypeName", fooditem.FoodWeightTypeId);
            ViewBag.SellerId = new SelectList(dbset.SellerDetails.OrderBy(x => x.SellerAccountName), "SellerId", "SellerName", fooditem.SellerId);

            return View(fooditem);
        }

        //
        // POST: /StoreManagerFoodItem/Edit/5

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult Edit(BusinessLayer.FoodItem fooditem)
        {
            if (ModelState.IsValid)
            {
                dbset.SaveChangesFoodItemToDB(fooditem);
                //db.Entry(fooditem).State = EntityState.Modified;
                //db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName", fooditem.FoodGroupId);
            ViewBag.SubFoodGroupId = new SelectList(dbset.SubFoodGroups.OrderBy(x => x.SubFoodGroupName), "SubFoodGroupId", "SubFoodGroupName", fooditem.SubFoodGroupId);
            ViewBag.FoodWeightTypeId = new SelectList(dbset.FoodWeightTypes.OrderBy(x => x.FoodWeightTypeName), "FoodWeightTypeId", "FoodWeightTypeName", fooditem.FoodWeightTypeId);
            ViewBag.SellerId = new SelectList(dbset.SellerDetails.OrderBy(x => x.SellerAccountName), "SellerId", "SellerName", fooditem.SellerId);

            return View(fooditem);
        }

        //
        // GET: /StoreManagerFoodItem/Delete/5
        [HttpPost]
        public ActionResult Delete(decimal id)
        {
            dbset.DeleteFoodItemFromDB(id);
            return RedirectToAction("Index");

            //return View();
        }

        //
        // POST: /StoreManagerFoodItem/Delete/5

        /*   [HttpPost, ActionName("Delete")]
           [ValidateAntiForgeryToken]
           public ActionResult DeleteConfirmed(decimal id)
           {
               /*FoodItem fooditem = db.FoodItems.Find(id);
               db.FoodItems.Remove(fooditem);
               db.SaveChanges();
               return RedirectToAction("Index");
           }*/

        protected override void Dispose(bool disposing)
        {
            /*db.Dispose();
            base.Dispose(disposing);*/
        }
    }
}