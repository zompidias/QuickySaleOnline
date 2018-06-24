using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuickySaleOnlineShopper.Models;
using BusinessLayer;

namespace QuickySaleOnlineShopper.Controllers
{
    public class CheckOutController : Controller
    {
        OnlineStoreEntities storeDB = new OnlineStoreEntities();
        BusinessLayer.ShoppingCart sc = new BusinessLayer.ShoppingCart();
        StoreBusinessLayer dbset = new StoreBusinessLayer();

        public ActionResult Index()
        {
            return View();
        }

        //
        // GET: /CheckOut/Details/5


        public ActionResult Create()
        {
            ViewBag.StateId = new SelectList(dbset.States, "StateId", "StateName"); 
            
            return View();
        }

        //
        // POST: /CheckOut/Create

        [HttpPost]
        public ActionResult Create(BusinessLayer.CustomerDetail values)
        {
            if (ModelState.IsValid)
            {
               // try
                //{ Check if this new email already exists on DB
                if (!dbset.ConfirmEmailIsUnique(values.Email.ToString()))
                {
                    var order = new BusinessLayer.CustomerDetail();
                    var cartid = sc.GetCartId(this.HttpContext);
 
                    //Create new member into the database
                    sc.CreateMember(values);//customerDetail

                    //send admin an email to call and confirm new user
                    BusinessLayer.SendEmails sendmail = new SendEmails();
                    sendmail.NewCustomerEmail(values);


                    //Update tblUserProfile with correct UserName
                    sc.UpdatetblUserProfileWithCurrentUserName(values.Email.Trim(), cartid);

                    return RedirectToAction("Index", "ShoppingCart");
                }
                else
                { ViewBag.StateId = new SelectList(dbset.States, "StateId", "StateName"); 
                    return View("NotUniqueEmailIndex"); }
            }
            ViewBag.StateId = new SelectList(dbset.States, "StateId", "StateName");

            return View();
        }

        //
        // GET: /CheckOut/Edit/5

        public ActionResult Edit()
        {
             var cartid = sc.GetCartId(this.HttpContext); 
            string UserName = sc.GetLoginDetail(cartid);
            if (UserName == "Guest")
            {
                return View("Index");
            }
            else
            {

                BusinessLayer.CustomerDetail fooditem = dbset.CustomerDetails.Single(emp => emp.Email == UserName);
                if (fooditem == null)
                {
                    return HttpNotFound();
                }
                ViewBag.StateId = new SelectList(dbset.States.OrderBy(x => x.StateName), "StateId", "StateName", fooditem.StateId);
                return View(fooditem);
            }
        }

        //
        // POST: /CheckOut/Edit/5

        [HttpPost]
        public ActionResult Edit(BusinessLayer.CustomerDetail cusdet)
        {
             if (ModelState.IsValid)
                {
                 dbset.SaveChangesCustomerDetailToDB(cusdet);
 
                    return RedirectToAction("Index", "Home");
                }
             var cartid = sc.GetCartId(this.HttpContext);
             string UserName = sc.GetLoginDetail(cartid);
             BusinessLayer.CustomerDetail fooditem = dbset.CustomerDetails.Single(emp => emp.Email == UserName);

             ViewBag.StateId = new SelectList(dbset.States.OrderBy(x => x.StateName), "StateId", "StateName", fooditem.StateId);
             return View(fooditem);
        }

        //
        // GET: /CheckOut/Delete/5

        public ActionResult LogIn(FormCollection frmCollection)
        {
            //Check if person exists
            //var ChkCusomer = storeDB.CustomerDetails.Single(x => x.Username == frmCollection["UserName"].ToString());
            string dbUserName = frmCollection["UserName"].ToString().Trim();
            string dbPwd = frmCollection["Password"].ToString().Trim();

            if (sc.CheckMembership(dbUserName, dbPwd))
            {
                //Update tblUserProfile with correct UserName
                var cartid = sc.GetCartId(this.HttpContext);
                sc.UpdatetblUserProfileWithCurrentUserName(dbUserName, cartid);

                return RedirectToAction("Index", "ShoppingCart");
                //Take you to a cart View and then proceed to do the above once a button is clicked
                //else continue shopping
            }
            else
            {
                return View("ErrorIndex");
            }

        }

        public ActionResult CheckOutLogIn(FormCollection frmCollection)
        {
            //Double chk to ensure this profile is in the userprofile table incase back button was used
            var cartid = sc.GetCartId(this.HttpContext);
            
            if (!sc.ConfirmMemberisLoggedIn(cartid))
            {
                sc.AddGuestBrowserTotblUserProfile(cartid);
            }

            //Check if person exists
            //var ChkCusomer = storeDB.CustomerDetails.Single(x => x.Username == frmCollection["UserName"].ToString());
            string dbUserName = frmCollection["UserName"].ToString().Trim();
            string dbPwd = frmCollection["Password"].ToString().Trim();

            if (sc.CheckMembership(dbUserName, dbPwd))
            {
                //Update tblUserProfile with correct UserName
                sc.UpdatetblUserProfileWithCurrentUserName(dbUserName, cartid);

                //Put a protection block incase the back button is pressed on the site
                decimal id=0;
                if (cartid == null || cartid == "" || dbUserName == "" || dbUserName == null)
                {
                    return View("Error"); 
                    
                }
                else { 
                    id = sc.CreateOrder(cartid, dbUserName);
                    BusinessLayer.SendEmails em = new BusinessLayer.SendEmails();
                    em.ProcessEmail(cartid);

                    return RedirectToAction("Complete", "CheckOut", new { id = id });
                }
                //Send Email on order
                
            }
            else
            {
                return View("ErrorIndex");
            }

        }

        //[ChildActionOnly]
        public ActionResult Complete(decimal id)
        {
            var cartid = sc.GetCartId(this.HttpContext);

            //Check If already logged in
            string UserName = sc.GetLoginDetail(cartid);
            bool isValid = storeDB.OrderNumbers.Any(o => o.OrderNumberId == id && o.UserName == UserName);
            var addressIs = storeDB.CustomerDetails.Single(x => x.Username == UserName).Address.ToString();


            //chk addressIs has a value, if not give a default value
            if (addressIs == "" || addressIs == null)
            {
                ViewData["CustomerAddress"] = "Address On Our System";
            }
            else ViewData["CustomerAddress"] = addressIs;

            // string info = id.ToString() + " - " + custAddress;
            //bool isValid = true;
            if (isValid)
            {
                return View(id);
            }
            else
            {
                return View("Error");
            }
        }

        //[ChildActionOnly]
        public ActionResult ProceedToCheckOut()
        {
            var cartid = sc.GetCartId(this.HttpContext);
            //Check If already logged in
            string UserName = sc.GetLoginDetail(cartid);
            if (UserName == "Guest" || UserName == "")
            {
                return View("CheckOutLogin");
            }
                //Logged in process order
            else
            {
                //var cart = QuickySaleOnlineShopper.Models.ShoppingCart.GetCart(this.HttpContext);
                //Put a protection block incase the back button is pressed on the site
                decimal id=0;
                if (cartid == null || cartid == "" || UserName == "" || UserName == null)
                {
                    return View("Error");

                }
                else
                {
                    //Send Email on order
                    id = sc.CreateOrder(cartid, UserName);
                    BusinessLayer.SendEmails em = new BusinessLayer.SendEmails();
                    em.ProcessEmail(cartid);

                    return RedirectToAction("Complete", "CheckOut", new { id = id });
                }

                


            }


            // return View();
        }

        public ActionResult ForgotPassword()
        {
            //ViewBag.StateId = new SelectList(dbset.States, "StateId", "StateName");

            return View();
        }
        public ActionResult SendPasswordToCustomer(string submit)
        {
//check if this email is in the db and retrieve its password
            string fdgrp = dbset.GetPasswordForThisEmail(submit.Trim());

            if (fdgrp == "" || fdgrp== null) 
            {
                View("EmailError");
            }
            else{
            //Send Email
                 BusinessLayer.SendEmails em = new BusinessLayer.SendEmails();
                em.ForgotPassowrdEmail(submit.Trim(),fdgrp );
            return View();
            }
            return View("EmailError");
            
        }
    }
}
