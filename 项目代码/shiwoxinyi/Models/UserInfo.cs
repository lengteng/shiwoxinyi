//------------------------------------------------------------------------------
// <auto-generated>
//     此代码已从模板生成。
//
//     手动更改此文件可能导致应用程序出现意外的行为。
//     如果重新生成代码，将覆盖对此文件的手动更改。
// </auto-generated>
//------------------------------------------------------------------------------

namespace Models
{
    using System;
    using System.Collections.Generic;
    
    public partial class UserInfo
    {
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2214:DoNotCallOverridableMethodsInConstructors")]
        public UserInfo()
        {
            this.Orders = new HashSet<Orders>();
            this.ShopCar = new HashSet<ShopCar>();
            this.UserAddress = new HashSet<UserAddress>();
        }
    
        public string Users_id { get; set; }
        public string UserName { get; set; }
        public string UserPass { get; set; }
        public string UserPhone { get; set; }
        public string UserMail { get; set; }
        public string Sex { get; set; }
        public Nullable<System.DateTime> Addtime { get; set; }
        public string SafeQues { get; set; }
        public string Answer { get; set; }
        public string Address { get; set; }
        public string UserSign { get; set; }
        public string UserImage { get; set; }
        public string Pifu { get; set; }
    
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<Orders> Orders { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<ShopCar> ShopCar { get; set; }
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Usage", "CA2227:CollectionPropertiesShouldBeReadOnly")]
        public virtual ICollection<UserAddress> UserAddress { get; set; }
    }
}
