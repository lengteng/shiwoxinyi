using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Models;
using BLL;
using PagedList;
using System.Net;

namespace UI.Controllers
{
    public class ManagerAddController : Controller
    {
        shiwoxinyigaiEntities db = new shiwoxinyigaiEntities();
        ManagerManager mm = new ManagerManager();

        #region 后台附页
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult main()
        {
            return View();
        }
        #endregion

        #region 后台主页
        public ActionResult menu()
        {
            string uid = Session["Manager_id"].ToString();
            if (uid != null)
            {
                return View();
            }
            else
            {
                return Content("<script>alert('您尚未登陆，请登陆');history.go(-1);</script>");
            }
        }
        #endregion

        #region 后台登录
        [HttpPost]
        public ActionResult Login([Bind(Include = "Manager_id,ManagerPass")]string Manager_id, string ManagerPass)
        {
         
            var users = mm.Denglu(Manager_id, ManagerPass);
            if (users != null)
            {
                //保存到Session HttpContext。
                Session["Manager_id"] = Manager_id;
                Session["ManagerName"] = mm.GetManagersById(Manager_id).ManagerName;
                return RedirectToAction("menu", "ManagerAdd");
            }
            else
            {
                return RedirectToAction("Login", "ManagerAdd");
            }
          
            
        }
        #endregion

        #region 后台注销
        [HttpPost]
        public string Zhuxiao()
        {
            //保存到Session HttpContext.
            Session["Manager_id"] = null;
            string A = "a";
            return A;
        }
        #endregion
    }
}