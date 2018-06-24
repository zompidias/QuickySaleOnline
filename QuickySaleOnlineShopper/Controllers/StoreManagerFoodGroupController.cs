using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessLayer;
using QuickySaleOnlineShopper.Models;

namespace QuickySaleOnlineShopper.Controllers
{
    public class StoreManagerFoodGroupController : Controller
    {
        private OnlineStoreEntities db = new OnlineStoreEntities();
        StoreBusinessLayer dbset = new StoreBusinessLayer();

        // GET: /StoreManagerFoodGroup/

       // [ChildActionOnly]
      
        public ActionResult Index()
        {
            var fd = db.FoodGroups; //db.Albums.Include(a => a.Genre).Include(a => a.Artist);
            
            return View(fd.ToList());
        }

        [HttpGet]
        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /StoreManagerFoodItem/Create

        [HttpPost]
        //[ActionName("Create")]
        //[ValidateAntiForgeryToken]
        public ActionResult Create(BusinessLayer.FoodGroup fooditem)//Create(FormCollection formCollection)
        {

            if (ModelState.IsValid)
            {
                dbset.AddFoodGroupToDB(fooditem);
                return RedirectToAction("Index");
            }
          
            //ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups, "FoodGroupId", "FoodGroupName");
            
            return View();

        }

        [HttpGet]
        public ActionResult Edit(decimal id)
        {
            BusinessLayer.FoodGroup fooditem = dbset.FoodGroups.Single(emp => emp.FoodGroupId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
 
            return View(fooditem);
        }

        //
        // POST: /StoreManagerFoodItem/Edit/5

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult Edit(BusinessLayer.FoodGroup fooditem)
        {
            if (ModelState.IsValid)
            {
                dbset.SaveChangesFoodGroupToDB(fooditem);
                //db.Entry(fooditem).State = EntityState.Modified;
                //db.SaveChanges();
                return RedirectToAction("Index");
            }
 
            return View(fooditem);
        }

        //
        // GET: /StoreManagerFoodGroup/Edit/5

       
        //
        // GET: /StoreManagerFoodGroup/Delete/5

          }
}
