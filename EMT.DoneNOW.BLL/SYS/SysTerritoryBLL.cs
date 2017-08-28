using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    public class SysTerritoryBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();
        /// <summary>
        /// 根据地域的id，查找属于该地域的员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<crm_account> GetAccountList(long id) {            
            return new crm_account_dal().FindListBySql<crm_account>($"select a.name,a.id from crm_account a,crm_account_territory b where a.id=b.account_id  and a.delete_time=0 and b.territory_id={id}").ToList();
        }
        public List<crm_account> GetAccount(long id)
        {
            return new crm_account_dal().FindListBySql<crm_account>($"select name,id from crm_account  where id not in (SELECT account_id from crm_account_territory where territory_id={id}) and delete_time=0 ").ToList();
        }


        public ERROR_CODE Insert(crm_account_territory cat,long user_id) {
            cat.id = (int)_dal.GetNextIdCom();
            new crm_account_territory_dal().Insert(cat);
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 新增地域
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertTerritory(d_general data, long user_id, ref int id)
        {
            if (id > 0)
            {
                data.general_table_id = (int)GeneralTableEnum.TERRITORY;
                data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                data.update_user_id = user_id;
                if (!_dal.Update(data))
                {
                    return ERROR_CODE.ERROR;
                }
            }
            else
            {
                data.general_table_id = (int)GeneralTableEnum.TERRITORY;
                data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                data.create_user_id = user_id;
                //唯一性校验
                var general = _dal.FindSignleBySql<d_general>($"select * from d_general where name={data.name}");
                if (general != null && general.delete_time == 0)
                {
                    return ERROR_CODE.EXIST;
                }
                _dal.Insert(data);
                var re = _dal.FindSignleBySql<d_general>($"select * from d_general where name={data.name}");
                if (re != null)
                {
                    id = re.id;
                }
            }
            return ERROR_CODE.SUCCESS;
        }
        public Dictionary<string, object> GetRegionDownList()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("Region", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.REGION)));
            return dic;
        }
        /// <summary>
        /// 删除crm_account_territory表中的客户和地域的关系
        /// </summary>
        /// <param name="aid"></param>
        /// <param name="tid"></param>
        /// <returns></returns>
        public bool DeleteAccount_Territory(long aid,long tid) {
            crm_account_territory_dal cat_dal= new crm_account_territory_dal();
           var i= cat_dal.FindSignleBySql<crm_account_territory>($"select * from crm_account_territory where account_id={aid} and territory_id={tid}");
            if (i != null) {
                if (cat_dal.Delete(i)) {
                    return true;
                }
            }
            return false;
        }
    }
}
