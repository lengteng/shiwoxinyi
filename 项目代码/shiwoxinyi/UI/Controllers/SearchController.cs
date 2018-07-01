using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using BLL;

namespace UI.Controllers
{
    public class SearchController : Controller
    {
        UserInfoManager userInfoManager = new UserInfoManager();
        GoodsManager goodsManager = new GoodsManager();
        Models.SearchViewModel searchvm = new Models.SearchViewModel();
        // GET: Search
        public ActionResult Index()
        {
            string search = Session["Search"].ToString();
            searchvm.Goods1 = goodsManager.Search(search);
            searchvm.UserInfo1 = userInfoManager.Search(search);
            return View(searchvm);
        }

        #region 搜索页面
        [HttpPost]
        public ActionResult Index(string search)
        {
            Session["Search"] = search;
            searchvm.Goods1 = goodsManager.Search(search);
            searchvm.UserInfo1 = userInfoManager.Search(search);
            return View(searchvm);
        }
        #endregion
    }
}