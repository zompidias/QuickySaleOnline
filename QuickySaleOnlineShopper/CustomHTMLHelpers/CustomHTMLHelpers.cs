using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.WebPages.Html;

namespace QuickySaleOnlineShopper.CustomHTMLHelpers
{
    public static class CustomHTMLHelpers
    {
        public static IHtmlString Image(this System.Web.Mvc.HtmlHelper helper, string src, string alt)
        {
            // Build <img> tag
            TagBuilder tb = new TagBuilder("img");
            // Add "src" attribute
            tb.Attributes.Add("src", VirtualPathUtility.ToAbsolute(src));
            // Add "alt" attribute
            tb.Attributes.Add("alt", alt);
            // return MvcHtmlString. This class implements IHtmlString
            // interface. IHtmlStrings will not be html encoded.
            return new MvcHtmlString(tb.ToString(TagRenderMode.SelfClosing));

        }
    }
}