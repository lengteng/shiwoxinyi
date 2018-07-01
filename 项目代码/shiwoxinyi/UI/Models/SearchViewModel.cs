using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models;

namespace UI.Models
{
    public class SearchViewModel
    {
        public IEnumerable<UserInfo> UserInfo1 { get; set; }
        public IEnumerable<Goods> Goods1 { get; set; }
    }
}