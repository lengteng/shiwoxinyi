using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Reflection;
using Models;
using IDAL;

namespace DALFactory
{
    public class DataAccess
    {
        private static string AssemblyName = ConfigurationManager.AppSettings["Path"].ToString();
        private static string db = ConfigurationManager.AppSettings["DB"].ToString();
        public static IGoods CreateGoods()
        {
            string className = AssemblyName + "." + db + "Goods";
            return (IGoods)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IUserInfo CreateUserInfo()
        {
            string className = AssemblyName + "." + db + "UserInfo";
            return (IUserInfo)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IShopCar CreateShopCar()
        {
            string className = AssemblyName + "." + db + "ShopCar";
            return (IShopCar)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IGoodsK CreateGoodsK()
        {
            string className = AssemblyName + "." + db + "GoodsK";
            return (IGoodsK)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IManager CreateManager()
        {
            string className = AssemblyName + "." + db + "Manager";
            return (IManager)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IOrders CreateOrders()
        {
            string className = AssemblyName + "." + db + "Orders";
            return (IOrders)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IOrdersDetails CreateOrdersDetails()
        {
            string className = AssemblyName + "." + db + "OrdersDetails";
            return (IOrdersDetails)Assembly.Load(AssemblyName).CreateInstance(className);
        }
        public static IUserInfo CreateUserInfor()
        {
            string className = AssemblyName + "." + db + "UserInfo";
            return (IUserInfo)Assembly.Load(AssemblyName).CreateInstance(className);
        }
    }
}
