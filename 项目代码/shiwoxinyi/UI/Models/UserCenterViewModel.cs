using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Models;

namespace UI.Models
{
    public class UserCenterViewModel
    {
        public IEnumerable<UserInfo> Uses1 { get; set; }
        public UserInfo UserInfo { get; set; } //用来修改资料     
        public UserAddress UserAddress { get; set; }
        public IEnumerable<SelectListItem> List1 { get; set; }
    }
}