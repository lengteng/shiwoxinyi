﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DALFactory;
using IDAL;
using Models;

namespace BLL
{
    public class OrdersManager
    {
        IOrders iorders = DataAccess.CreateOrders();
        public IEnumerable<Orders> GetOrders()
        {
            var orderss = iorders.GetOrders();
            return orderss;
        }
        public Orders GetOrdersById(int? id)
        {
            Orders orders = iorders.GetOrdersById(id);
            return orders;
        }

        public void Goumai(string uid, string uname, string userphone, string address, string note)
        {
            iorders.Goumai(uid, uname, userphone, address, note);
        }
        public void RemoveOrders(Orders orders)
        {
            iorders.RemoveOrders(orders);

        }
        public void EditOrders(Orders orders)
        {
            iorders.EditOrders(orders);

        }
    }
}
