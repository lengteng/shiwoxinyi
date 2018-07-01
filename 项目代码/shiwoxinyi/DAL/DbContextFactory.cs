using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Models;
using System.Runtime.Remoting.Messaging;

namespace DAL
{
    public class DbContextFactory
    {
        public static shiwoxinyigaiEntities CreateDbContext()
        {
            shiwoxinyigaiEntities dbContext = (shiwoxinyigaiEntities)CallContext.GetData("dbContext");
            if (dbContext == null)
            {
                dbContext = new shiwoxinyigaiEntities();
                CallContext.SetData("dbContext", dbContext);
            }
            return dbContext;
        }
    }
}
