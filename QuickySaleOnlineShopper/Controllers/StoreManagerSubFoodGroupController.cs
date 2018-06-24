using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessLayer;
using QuickySaleOnlineShopper.Models;


namespace QuickySaleOnlineShopper.Controllers
{
    public class StoreManagerSubFoodGroupController : Controller
    {
        private OnlineStoreEntities db = new OnlineStoreEntities();
        StoreBusinessLayer dbset = new StoreBusinessLayer();
        // GET: /StoreManagerSubFoodGroup/

        //[ChildActionOnly]
        
        public ActionResult Index()
        {
            var fd = db.SubFoodGroups.Include("FoodGroup"); //db.Albums.Include(a => a.Genre).Include(a => a.Artist);

            return View(fd.ToList());
        }

        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName");
            return View();
        }

        //
        // POST: /StoreManagerFoodItem/Create

        [HttpPost]
        //[ActionName("Create")]
        //[ValidateAntiForgeryToken]
        public ActionResult Create(BusinessLayer.SubFoodGroup fooditem)//Create(FormCollection formCollection)
        {

            //if (ModelState.IsValid)
            //{
            var subgrpname = fooditem.SubFoodGroupName;
            var foodgrpid = fooditem.FoodGroupId;
                dbset.AddSubFoodGroupToDB(fooditem);
                return RedirectToAction("Index");
            //}
                ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName");

           return View();

        }

        [HttpGet]
        public ActionResult Edit(decimal id)
        {
            BusinessLayer.SubFoodGroup fooditem = dbset.SubFoodGroups.Single(emp => emp.SubFoodGroupId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName", fooditem.FoodGroupId);

            return View(fooditem);
        }

         [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult Edit(BusinessLayer.SubFoodGroup fooditem)
        {
            if (ModelState.IsValid)
            {
                dbset.SaveChangesSubFoodGroupToDB(fooditem);
                return RedirectToAction("Index");
            }
            ViewBag.FoodGroupId = new SelectList(dbset.FoodGroups.OrderBy(x => x.FoodGroupName), "FoodGroupId", "FoodGroupName", fooditem.FoodGroupId);

            return View(fooditem);
        }

    }
}
