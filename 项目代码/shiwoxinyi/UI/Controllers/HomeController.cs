using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Web;
using System.Web.Mvc;
using BLL;
using Models;

namespace UI.Controllers
{
    public class HomeController : Controller
    {
        shiwoxinyigaiEntities db = new shiwoxinyigaiEntities();
        GoodsManager goodsmanager = new GoodsManager();
        UserInfoManager userInfoManager = new UserInfoManager();
        public ActionResult Index()
        {
            var goodses1 = goodsmanager.whereGoodsById(2);
            var goodses2 = goodsmanager.whereGoodsById(3);
            var goodses3 = goodsmanager.whereGoodsById(4);
            var goodses4 = goodsmanager.whereGoodsById(5);
            Models.HomeIndexViewModel homevm = new Models.HomeIndexViewModel();
            homevm.Goodses1 = goodses1;
            homevm.Goodses2 = goodses2;
            homevm.Goodses3 = goodses3;
            homevm.Goodses4 = goodses4;
            return View(homevm);
        }
      
        public ActionResult About()
        {
            ViewBag.Message = "Your application description page.";

            return View();
        }

        public ActionResult Contact()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}