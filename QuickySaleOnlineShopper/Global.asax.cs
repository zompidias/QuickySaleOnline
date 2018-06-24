using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using System.Web.WebPages;

namespace QuickySaleOnlineShopper
{
    // Note: For instructions on enabling IIS6 or IIS7 classic mode, 
    // visit http://go.microsoft.com/?LinkId=9394801

    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            System.Data.Entity.Database.SetInitializer<QuickySaleOnlineShopper.Models.OnlineStoreEntities>(null);

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            BundleConfig.RegisterBundles(BundleTable.Bundles);
            AuthConfig.RegisterAuth();
            BundleMobileConfig.RegisterBundles(BundleTable.Bundles);


            if (DisplayModeProvider.Instance != null)
                if (DisplayModeProvider.Instance.Modes != null)
                   // DisplayModeProvider.Instance.Modes.Insert(0, new DefaultDisplayMode("Tablet")
                    DisplayModeProvider.Instance.Modes.Insert(0, new DefaultDisplayMode("iPad")
                    {
                    ContextCondition = (ctx =>
                    ctx.Request.UserAgent != null &&
                    (
                    ctx.Request.UserAgent.IndexOf("iPad", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    ctx.Request.UserAgent.IndexOf("Android", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    ctx.Request.UserAgent.IndexOf("iPhone", StringComparison.OrdinalIgnoreCase) >= 0 ||
                    ctx.Request.UserAgent.IndexOf("Mac OS", StringComparison.OrdinalIgnoreCase) >= 0))// &&
                    //ctx.Request.UserAgent.IndexOf("mobile", StringComparison.OrdinalIgnoreCase) < 1)
                });

            
            /* DisplayModeProvider.Instance.Modes.Insert(0, new DefaultDisplayMode("iPad")
            {
                ContextCondition = (context => context.Request.UserAgent != null && context.GetOverriddenUserAgent().IndexOf("iPad", StringComparison.OrdinalIgnoreCase) >= 0)
            });

         /*   DisplayModeProvider.Instance.Modes.Insert(0, new DefaultDisplayMode()
            {
                ContextCondition = (context => context.GetOverriddenUserAgent().IndexOf("iPad", StringComparison.OrdinalIgnoreCase) >= 0)
            });*/

            /* DisplayModeProvider.Instance.Modes.Insert(0, new DefaultDisplayMode("iPad")

             {

                 ContextCondition = (context => context.Request.UserAgent.IndexOf

                 ("iPad", StringComparison.OrdinalIgnoreCase) >= 0)

             });*/
           // DisplayModes.Modes.Insert(0, new DefaultDisplayMode("iPad"){}


        }
    }
}