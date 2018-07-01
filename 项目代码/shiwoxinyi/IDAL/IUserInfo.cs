using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;

namespace IDAL
{
    public interface IUserInfo
    {
        void AddUserInfo(UserInfo userInfo);
        void AddUserAddress(UserAddress userAddress);
        UserInfo Denglu(string Users_id, string UserPass);
        UserInfo GetUsersById(string Users_id);
        void UpdateUserInfo(UserInfo userInfo);
        IEnumerable<UserInfo> IEGetUsersById(string Users_id);
        IEnumerable<UserInfo> Search(string search);
    }
}
