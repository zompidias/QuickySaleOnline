using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace QuickySaleOnlineShopper.Controllers
{
    public class StoreManagerItemsController : Controller
    {
        //
        // GET: /StoreManagerItems/

        //[OutputCache(Duration = 600)]
        public ActionResult Index()
        {
            return View();
        }

    }
}
