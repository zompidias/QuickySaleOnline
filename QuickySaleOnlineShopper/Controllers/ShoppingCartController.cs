using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using QuickySaleOnlineShopper.Models;
using QuickySaleOnlineShopper.ViewModels;
using BusinessLayer;

namespace QuickySaleOnlineShopper.Controllers
{
    public class ShoppingCartController : Controller
    {
        OnlineStoreEntities storeDB = new OnlineStoreEntities();
        BusinessLayer.ShoppingCart sc = new BusinessLayer.ShoppingCart();
        StoreBusinessLayer dbset = new StoreBusinessLayer();
        //BusinessLayer.ShoppingCartViewModel ShopCVM = new BusinessLayer.ShoppingCartViewModel();
        //BusinessLayer.ShoppingCartRemoveViewModel shopRemoveCVM = new BusinessLayer.ShoppingCartRemoveViewModel();

        public ActionResult Index()
        {

            //string id = sc.
            var cart = QuickySaleOnlineShopper.Models.ShoppingCart.GetCart(this.HttpContext);
            //BusinessLayer.ShoppingCart cart2 = BusinessLayer.ShoppingCart.GetCart(this.HttpContext);

            //var fd = storeDB.StoreCarts.Include("FoodItems").Where(grp => grp.StoreCartId == (string)cart2.GetCartId(this.HttpContext)).ToList();
            // Set up our ViewModel
            // var giveModel = new MVCQuickySale.Models.StoreCart();
            var cartid = sc.GetCartId(this.HttpContext);
            var fd = storeDB.StoreCarts.Include("FoodItems").Where(grp => grp.StoreCartId == (string)cartid);
            //var fdsc = sc.GetCartItems((string)cartid);
            // 
            var viewModel = new QuickySaleOnlineShopper.ViewModels.ShoppingCartViewModel
            {
                StoreCart = cart.GetCartItems(),
                CartTotal = cart.GetTotal(),
                //cartid = cart.GetCartId
            };
            //string cartid = viewModel.StoreCart.
            // Return the view
            if (viewModel.StoreCart.Count > 0)
            {
                //return View(viewModel);
                return View("Index", fd);
            }
            else
            {
                return View("EmptyCart");
            }

        }
        //
        // GET: /Store/AddToCart/5
        //[ChildActionOnly]
        public ActionResult AddToCart(decimal id)
        //public ActionResult AddToCart(BusinessLayer.FoodItem id)
        {
            // Retrieve the album from the database
            /*BusinessLayer.FoodItem addedAlbum = storeDB.FoodItems
                .Single(album => album.FoodItemId == id);*/
            BusinessLayer.FoodItem fooditem = dbset.FoodItems.Single(emp => emp.FoodItemId == id);

            //Get SubgroupID

            decimal subgrpId = fooditem.FoodGroupId;
            // Add it to the shopping cart
            BusinessLayer.ShoppingCart cart = BusinessLayer.ShoppingCart.GetCart(this.HttpContext);

            cart.AddToCart(fooditem);
            //cart.AddToCart(id);

            // Go back to the main store page for more shopping
            //return RedirectToAction("Index", "Home");
            return RedirectToAction("Browse", "Store", new { id = subgrpId });
        }
        //
        // AJAX: /ShoppingCart/RemoveFromCart/5
        [HttpPost]
        //[ChildActionOnly]
        public ActionResult RemoveFromCart(int id)
        {
            // Remove the item from the cart
            var cart = BusinessLayer.ShoppingCart.GetCart(this.HttpContext);

            // Get the name of the album to display confirmation
            string albumName = storeDB.StoreCarts
                .Single(item => item.RecordId == id).FoodItems.FoodName;

            // Remove from cart
            int itemCount = cart.RemoveFromCart(id);

            // Display the confirmation message
            var results = new BusinessLayer.ShoppingCartRemoveViewModel
            {
                Message = Server.HtmlEncode(albumName) +
                    " has been removed from your shopping cart.",
                CartTotal = cart.GetTotal(),
                CartCount = cart.GetCount(),
                ItemCount = itemCount,
                DeleteId = id
            };
            return Json(results);
        }
        //
       // [ChildActionOnly]
        public ActionResult Increase(decimal increaseId)
        {

            //id = obj.RecordId;
            sc.IncreaseCartItemFromDB(increaseId);
            //var cartid = sc.GetCartId(this.HttpContext);
            //var fd = storeDB.StoreCarts.Include("FoodItems").Where(grp => grp.StoreCartId == (string)cartid);
            return RedirectToAction("Index");

            //return View();
        }
        //[ChildActionOnly]
        public ActionResult Decrease(decimal decreaseId)
        {

            //id = obj.RecordId;
            sc.DecreaseCartItemFromDB(decreaseId);
            //var cartid = sc.GetCartId(this.HttpContext);
            //var fd = storeDB.StoreCarts.Include("FoodItems").Where(grp => grp.StoreCartId == (string)cartid);
            return RedirectToAction("Index");

            //return View();
        }

        //[ChildActionOnly]
        public ActionResult Delete(decimal deleteId)
        {
            sc.DeleteCartItemFromDB(deleteId);

            //var cartid = sc.GetCartId(this.HttpContext);
            //var fd = storeDB.StoreCarts.Include("FoodItems").Where(grp => grp.StoreCartId == (string)cartid);
            return RedirectToAction("Index");

            //return View();
        }


        // GET: /ShoppingCart/CartSummary
        [ChildActionOnly]
        public ActionResult CartSummary()
        {
            var cart = BusinessLayer.ShoppingCart.GetCart(this.HttpContext);

            ViewData["CartCount"] = cart.GetCount();
            return PartialView("CartSummary");
        }

        [ChildActionOnly]
        public ActionResult LoginDetail()
        {
            var cart = BusinessLayer.ShoppingCart.GetCart(this.HttpContext);
            var cartid = sc.GetCartId(this.HttpContext);
            ViewData["UserName"] = cart.GetLoginDetail(cartid);
            return PartialView("LoginDetail");
        }

    }
}
