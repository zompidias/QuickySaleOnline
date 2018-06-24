using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessLayer;
using QuickySaleOnlineShopper.Models;

namespace QuickySaleOnlineShopper.Controllers
{
    public class StoreManagerSellerDetailController : Controller
    {
        private OnlineStoreEntities db = new OnlineStoreEntities();
        StoreBusinessLayer dbset = new StoreBusinessLayer();

        //[ChildActionOnly]
        
        public ActionResult Index()
        {
            var fd = dbset.SellerDetails;//.Include("BankDetails"); //db.Albums.Include(a => a.Genre).Include(a => a.Artist);

            return View(fd.ToList());
        }

        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.BankId = new SelectList(dbset.BankDetails.OrderBy(x => x.BankName), "BankId", "BankName"); 
            return View();
        }

        //
        // POST: /StoreManagerFoodItem/Create

        [HttpPost]
        //[ActionName("Create")]
        //[ValidateAntiForgeryToken]
        public ActionResult Create(BusinessLayer.QSSellerDetail fooditem)//Create(FormCollection formCollection)
        {

            if (ModelState.IsValid)
            {
                dbset.AddQSSellerDetailToDB(fooditem);
                return RedirectToAction("Index");
            }

            ViewBag.BankId = new SelectList(dbset.BankDetails.OrderBy(x => x.BankName), "BankId", "BankName");

            return View();

        }

        [HttpGet]
        public ActionResult Edit(decimal id)
        {
            BusinessLayer.QSSellerDetail fooditem = dbset.SellerDetails.Single(emp => emp.SellerId == id);
            if (fooditem == null)
            {
                return HttpNotFound();
            }
            ViewBag.BankId = new SelectList(dbset.BankDetails.OrderBy(x => x.BankName), "BankId", "BankName", fooditem.BankId);
            return View(fooditem);
        }

        //
        // POST: /StoreManagerFoodItem/Edit/5

        [HttpPost]
        //[ValidateAntiForgeryToken]
        public ActionResult Edit(BusinessLayer.QSSellerDetail fooditem)
        {
            if (ModelState.IsValid)
            {
                dbset.SaveChangesQSSellerDetailToDB(fooditem);
                //db.Entry(fooditem).State = EntityState.Modified;
                //db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.BankId = new SelectList(dbset.BankDetails.OrderBy(x => x.BankName), "BankId", "BankName", fooditem.BankId);
            return View(fooditem);
        }

    }
}
