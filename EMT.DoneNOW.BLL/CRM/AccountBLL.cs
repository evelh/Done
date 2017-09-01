using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.BLL
{
    public class AccountBLL
    {
        private readonly crm_account_dal _dal = new crm_account_dal();
        //获取客户类型为供应商的客户集合//缺少供应商
        public List<crm_account> GetAccount_Vendor() {
            return _dal.FindListBySql<crm_account>($"select * from crm_account where type_id=16 and delete_time=0 order by id").ToList();
        }
    }
}
