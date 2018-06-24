using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BusinessLayer;


namespace QuickySaleOnlineShopper.Controllers
{
    public class ContactUsController : Controller
    {
        StoreBusinessLayer dbset = new StoreBusinessLayer();
        // GET: /ContactUs/

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /ContactUs/Details/5

        

        //
        // GET: /ContactUs/Create

        public ActionResult Create()
        {
            return View();
        }

        //
        // POST: /ContactUs/Create

        [HttpPost]
        public ActionResult Create(BusinessLayer.ContactUs frmCollection)
        {
            if (ModelState.IsValid)
            {
               // try
                //{
                    // TODO: Add insert logic here
                    dbset.AddEnquiryToDB(frmCollection);

                    //Send information to Administrator email
                    BusinessLayer.SendEmails em = new BusinessLayer.SendEmails();
                    em.SendEnquiryToEmail(frmCollection);
                    return RedirectToAction("Index");
                //}
                //catch
                //{
                   // return View();
                //}
            }
            return View();
        }

        //
        // GET: /ContactUs/Edit/5

     
    }
}
