using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Models;

namespace UI.Models
{
    public class HomeIndexViewModel
    {
        public IEnumerable<Goods> Goodses1 { get; set; }
        public IEnumerable<Goods> Goodses2 { get; set; }
        public IEnumerable<Goods> Goodses3 { get; set; }
        public IEnumerable<Goods> Goodses4 { get; set; }
        public IEnumerable<UserInfo> UserInfo1 { get; set; }
    }
}