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
        public List<sys_resource> GetAccountList(long id) {            
            return new sys_resource_dal().FindListBySql<sys_resource>($"select b.name,b.id from sys_resource_territory a,sys_resource b where a.resource_id=b.id  and a.delete_time=0  and b.delete_time=0 and a.territory_id={id}").ToList();
        }
        /// <summary>
        ///  根据地域的id，查找不属于该地域的员工信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_resource> GetAccount(long id)
        {
            return new sys_resource_dal().FindListBySql<sys_resource>($"select id,`name` from sys_resource where id not in(select resource_id from sys_resource_territory where territory_id={id} and delete_time=0 ) and delete_time=0").ToList();
        }

        /// <summary>
        /// 获取员工对应的地域列表
        /// </summary>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public List<sys_resource_territory> GetTerritoryByResource(long resourceId)
        {
            return new sys_resource_territory_dal().GetListByResourceId(resourceId);
        }
        
        /// <summary>
        /// 新增员工和地域之间的关联记录
        /// </summary>
        /// <param name="cat"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(sys_resource_territory cat,long user_id) {
            cat.id = (int)_dal.GetNextIdCom();
            //不得插入重复数据
           var kk= new sys_resource_territory_dal().FindSignleBySql<sys_resource_territory>($"select * from sys_resource_territory where territory_id={cat.territory_id} and resource_id={cat.resource_id} and delete_time=0");
            if (kk != null) {
                return ERROR_CODE.EXIST;
            }
            new sys_resource_territory_dal().Insert(cat);
            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 新增地域
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE SaveTerritory(d_general data, long user_id, ref int id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            if (id > 0)
            {
                var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
                if (res != null && res.id != data.id)
                {
                    return ERROR_CODE.EXIST;
                }
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
                var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
                if (res != null)
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
        /// <summary>
        /// 获取区域
        /// </summary>
        /// <returns></returns>
        public Dictionary<string, object> GetRegionDownList()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("Region", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.REGION)));
            return dic;
        }
        /// <summary>
        /// 删除sys_resource_territory中的员工和地域的关系
        /// </summary>
        /// <param name="aid"></param>
        /// <param name="tid"></param>
        /// <returns></returns>
        public bool DeleteAccount_Territory(long aid,long tid,long user_id) {
            sys_resource_territory_dal cat_dal= new sys_resource_territory_dal();
           var i= cat_dal.FindSignleBySql<sys_resource_territory>($"select * from sys_resource_territory where resource_id={aid} and territory_id={tid} and delete_time=0");
            if (i != null) {
                i.delete_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                i.delete_user_id = user_id;
                if (cat_dal.Update(i)) {
                    return true;
                }
            }
            return false;
        }
    }
}
