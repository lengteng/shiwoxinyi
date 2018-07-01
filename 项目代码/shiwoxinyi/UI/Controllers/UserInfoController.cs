using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services.Protocols;
using BLL;
using Models;
using PagedList;
using UI.Attributes;
using UI.Models;

namespace UI.Controllers
{
    public class UserInfoController : Controller
    {
        shiwoxinyigaiEntities db = new shiwoxinyigaiEntities();
        UserInfoManager userinfomanager = new UserInfoManager();
        // GET: UserInfo
        public ActionResult Index()
        {
            return View();
        }
        #region 注册
        public ActionResult Register()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Register([Bind(Include = "Users_id,UserPass,UserMail")] UserInfo userInfo)
        {
            if (ModelState.IsValid)
            {
                userInfo.Addtime = System.DateTime.Now;
                userinfomanager.AddUserInfo(userInfo);
                return Content("<script>;alert('注册成功!');window.history.go(-2); window.location.reload(); </script>");
            }
            else
            {
                return Content("<script>;alert('注册失败！');history.go(-1)</script>");
            }
        }
        public string Pipei(string id)
        {
            var num = userinfomanager.GetUsersById(id);
            if (num != null)
            {
                return "1";
            }
            else
            {
                return "0";
            }
        }
        #endregion
        #region 登录
        [HttpPost]
        public string Login([Bind(Include = "Users_id,UserPass")]string Users_id, string UserPass)
        {
            try
            {
                var users = userinfomanager.Denglu(Users_id, UserPass);
                if (users != null)
                {
                    //保存到Session HttpContext.
                    Session["Users_id"] = Users_id;
                    Session["UserImage"] = userinfomanager.GetUsersById(Users_id).UserImage;
                    string data = "登录成功";
                    return data;
                }
                else
                {
                    string data = "登录失败";
                    return data;
                }
            }
            catch (Exception ex)
            {
                string data = "错误";
                return data;
            }
        }
        #endregion
        #region 头像
        public ActionResult TouXiang()
        {

            return View();
        }
        #endregion
        #region 注销
        [HttpPost]
        public string Zhuxiao()
        {
            //保存到Session HttpContext.
            Session["Users_id"] = null;
            string A = "a";
            return A;
        }
        #endregion
        #region 个人中心
        public ActionResult UserCenter(string Users_id)
        {
            UserCenterViewModel uc = new UserCenterViewModel();
            uc.Uses1 = userinfomanager.IEGetUsersById(Users_id);
            ViewBag.Users_id = Users_id;
            uc.List1 = new SelectList(db.UserAddress.Where(c => c.Users_id == Users_id), "Address", "Address");//下拉列表数据绑定
            uc.UserInfo = db.UserInfo.Find(Users_id);
            return View(uc);
        }
        #endregion
        #region 修改资料
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult Ziliao(UserInfo userInfo)
        {
            HttpPostedFileBase userImage = Request.Files["UserImage"];
            try
            {
                if (userImage.FileName != "")
                {
                    string filePath = userImage.FileName;
                    string filename = DateTime.Now.ToString("yyyyMMddHHmmssfffffff") +
                                      filePath.Substring(filePath.LastIndexOf("\\") + 1);
                    string serverpath = Server.MapPath(@"\Images\userInfo\") + filename;
                    string relativepath = @"/Images/userInfo/" + filename;
                    userImage.SaveAs(serverpath);
                    userInfo.UserImage = relativepath;
                }
                else
                {
                    userInfo.UserImage = db.UserInfo.Find(userInfo.Users_id).UserImage;
                }
                if (ModelState.IsValid)
                {
                    userInfo.UserImage = db.UserInfo.Find(userInfo.Users_id).UserImage;
                    userInfo.UserPass = db.UserInfo.Find(userInfo.Users_id).UserPass;
                    userInfo.Addtime = db.UserInfo.Find(userInfo.Users_id).Addtime;
                    userInfo.Pifu = db.UserInfo.Find(userInfo.Users_id).Pifu;
                    userinfomanager.UpdateUserInfo(userInfo);
                    return RedirectToAction("UserCenter", "UserInfo", new { Users_id = userInfo.Users_id });                   
                }
                else
                {
                    return Content("<script>;alert('修改失败！');window.history.go(-1);window.location.reload();</script>");
                }
            }
            catch (Exception ex)
            {
                //return ex.ToString();
                return Content(ex.Message);
            }
        }
        #endregion
        #region 修改皮肤
        public string ChangePifu(UserInfo userInfo)
        {
            if (ModelState.IsValid)
            {
                userInfo.UserName = db.UserInfo.Find(userInfo.Users_id).UserName;
                userInfo.UserPhone = db.UserInfo.Find(userInfo.Users_id).UserPhone;
                userInfo.UserMail = db.UserInfo.Find(userInfo.Users_id).UserMail;
                userInfo.Sex = db.UserInfo.Find(userInfo.Users_id).Sex;
                userInfo.UserSign = db.UserInfo.Find(userInfo.Users_id).UserSign;
                userInfo.UserImage = db.UserInfo.Find(userInfo.Users_id).UserImage;
                userInfo.SafeQues = db.UserInfo.Find(userInfo.Users_id).SafeQues;
                userInfo.Answer = db.UserInfo.Find(userInfo.Users_id).Answer;
                userInfo.Address = db.UserInfo.Find(userInfo.Users_id).Address;
                userInfo.UserPass = db.UserInfo.Find(userInfo.Users_id).UserPass;
                userInfo.Addtime = db.UserInfo.Find(userInfo.Users_id).Addtime;
                userinfomanager.UpdateUserInfo(userInfo);
                //db.Post.Add(post);
                //db.SaveChanges();
                //return RedirectToAction("Index");
                return "aa";
                //return RedirectToAction("UserCenter", "UserInfo", new { Users_id = userInfo.Users_id });
                //return Content("<script>;alert('修改成功！');</script>");
            }
            else
            {
                return "bb";
            }

        }
        #endregion
    }
}