using EMT.DoneNOW.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class VendorDto
    {
        public ivt_product_vendor vendor = new ivt_product_vendor();
        public string vendorname;
    }
    public class VendorData {
        public List<vendor_item> VENDOR = new List<vendor_item>();
    }
    public class  vendor_item {
        public Int64 id = 0;
        public Int64 product_id = 0;
        public Int64 vendor_account_id = 0;
        public String vendor_product_no = string.Empty;
        public Decimal vendor_cost = 0;
        public UInt64 is_default = 0;
        public SByte is_active = 0;
        public int operate = 0;//1,是删除，2、更新，3、新增
    }
}
