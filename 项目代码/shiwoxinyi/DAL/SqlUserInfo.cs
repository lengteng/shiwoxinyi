using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using IDAL;
using System.Data.Entity;
using System.Data.SqlClient;

namespace DAL
{
    public class SqlUserInfo : IUserInfo
    {
        shiwoxinyigaiEntities db = DbContextFactory.CreateDbContext();
        public void AddUserInfo(UserInfo userInfo)
        {
            db.UserInfo.Add(userInfo);
            db.SaveChanges();
        }
        public void AddUserAddress(UserAddress userAddress)
        {
            db.UserAddress.Add(userAddress);
            db.SaveChanges();
        }
        public IEnumerable<UserInfo> Search(string search)
        {
            var userInfo = from po in db.UserInfo
                           where po.UserName.Contains(search) || po.Users_id.Equals(search)
                           select po;
            return userInfo.ToList();
        }
        public int CountUserInfoById(string uid)
        {
            var shopcar = db.UserInfo.Where(c => c.Users_id == uid).Select(c => c.Users_id).Count();
            return shopcar;
        }
        public void UpdateUserInfo(UserInfo userInfo)
        {
            db.Entry(userInfo).State = EntityState.Modified;
            db.SaveChanges();
        }
        public UserInfo Denglu(string Users_id, string UserPass)
        {
            var userInfo = db.UserInfo.Where(u => u.Users_id == Users_id)
                .Where(u => u.UserPass == UserPass).FirstOrDefault();
            return userInfo;
        }
        public UserInfo GetUsersById(string Users_id)
        {
            UserInfo userInfo = db.UserInfo.Find(Users_id);
            return userInfo;
        }
        public IEnumerable<UserInfo> IEGetUsersById(string Users_id)
        {
            var userInfo = db.UserInfo.Where(c => c.Users_id == Users_id);
            return userInfo;
        }       
    }
}
