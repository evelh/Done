using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.BLL
{
    public class InventoryLocationBLL
    {
        private readonly ivt_warehouse_dal dal = new ivt_warehouse_dal();

        public ivt_warehouse GetLocation(long id)
        {
            return dal.FindById(id);
        }

        /// <summary>
        /// 获取除员工仓库外的仓库列表
        /// </summary>
        /// <returns></returns>
        public List<ivt_warehouse> GetLocationListUnResource()
        {
            string sql = "select * from ivt_warehouse where resource_id is null and delete_time=0";
            return dal.FindListBySql(sql);
        }

        /// <summary>
        /// 新增库存仓库
        /// </summary>
        /// <param name="name"></param>
        /// <param name="is_default"></param>
        /// <param name="is_active"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddLocation(string name,bool is_default,bool is_active,long userId)
        {
            ivt_warehouse lct = new ivt_warehouse();
            lct.name = name;
            lct.is_active = (sbyte)(is_active ? 1 : 0);
            lct.is_default = (sbyte)(is_default ? 1 : 0);
            lct.id = dal.GetNextIdCom();
            lct.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            lct.update_time = lct.create_time;
            lct.create_user_id = userId;
            lct.update_user_id = userId;

            if (lct.is_default == 1)    // 只能设置一个默认仓库
            {
                string sql = "update ivt_warehouse set is_default=0 where delete_time=0";
                dal.ExecuteSQL(sql);
            }

            dal.Insert(lct);
            OperLogBLL.OperLogAdd<ivt_warehouse>(lct, lct.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "新增库存仓库");

            return true;
        }

        /// <summary>
        /// 编辑库存仓库
        /// </summary>
        /// <param name="id"></param>
        /// <param name="name"></param>
        /// <param name="is_default"></param>
        /// <param name="is_active"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool EditLocation(long id, string name, bool is_default, bool is_active, long userId)
        {
            ivt_warehouse lct = dal.FindById(id);
            if (lct == null)
                return false;
            ivt_warehouse lctOld = dal.FindById(id);

            lct.name = name;
            lct.is_active = (sbyte)(is_active ? 1 : 0);
            lct.is_default = (sbyte)(is_default ? 1 : 0);
            lct.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            lct.update_user_id = userId;
            if (lct.resource_id != null)
                lct.is_default = 0;

            if (lctOld.is_default == 0 && lct.is_default == 1)    // 只能设置一个默认仓库
            {
                string sql = "update ivt_warehouse set is_default=0 where delete_time=0";
                dal.ExecuteSQL(sql);
            }
            dal.Update(lct);
            OperLogBLL.OperLogUpdate<ivt_warehouse>(lct, lctOld, lct.id, userId, DTO.DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "编辑库存仓库");

            return true;
        }

        /// <summary>
        /// 删除库存仓库
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool DeleteLocation(long id,long userId)
        {
            string sql = $"select count(id) from ivt_warehouse_product where warehouse_id={id} and delete_time=0";
            var cnt = dal.FindSignleBySql<int>(sql);
            if (cnt > 0)
                return false;

            sql = $"select count(id) from ivt_order_product where order_id in" +
                $"(select id from ivt_order where status_id<>{(int)DicEnum.PURCHASE_ORDER_STATUS.RECEIVED_FULL} and delete_time=0)" +
                $" and warehouse_id={id} and delete_time=0";
            cnt = dal.FindSignleBySql<int>(sql);
            if (cnt>0)
                return false;

            var lct = dal.FindById(id);
            if (lct == null)
                return false;
            if (lct.is_default == 1)    // 默认仓库不能删除
                return false;

            lct.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            lct.delete_user_id = userId;

            dal.Update(lct);
            OperLogBLL.OperLogDelete<ivt_warehouse>(lct, lct.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "删除库存仓库");
            return true;
        }

        /// <summary>
        /// 设置库存仓库激活/不激活
        /// </summary>
        /// <param name="id"></param>
        /// <param name="is_active"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SetLocationIsActive(long id, bool is_active, long userId)
        {
            var lct = dal.FindById(id);
            var lctOld = dal.FindById(id);
            if (lct == null)
                return false;

            if (is_active)
                lct.is_active = 1;
            else
                lct.is_active = 0;
            lct.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            lct.update_user_id = userId;

            dal.Update(lct);
            OperLogBLL.OperLogUpdate<ivt_warehouse>(lct, lctOld, lct.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "修改库存仓库激活状态");
            return true;
        }

        /// <summary>
        /// 设置库存仓库为默认仓库，如果仓库为停用状态，设置为激活
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool SetLocationDefault(long id,long userId)
        {
            var lct = dal.FindById(id);
            if (lct == null)
                return false;
            if (lct.resource_id != null)    // 员工仓库不能设置为默认
                return false;
            var lctOld = dal.FindById(id);

            string sql = "update ivt_warehouse set is_default=0 where delete_time=0";
            dal.ExecuteSQL(sql);

            lct.is_default = 1;
            lct.is_active = 1;
            lct.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            lct.update_user_id = userId;

            dal.Update(lct);
            OperLogBLL.OperLogUpdate<ivt_warehouse>(lct, lctOld, lct.id, userId, DicEnum.OPER_LOG_OBJ_CATE.INVENTORY_LOCATION, "修改库存仓库为默认");
            return true;
        }

        /// <summary>
        /// 返回仓库的激活、默认等信息
        /// </summary>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns>
        /// 字符串数组
        ///     字符元素1:1：员工仓库；0：非员工仓库
        ///     字符元素2:1：默认仓库；0：非默认仓库
        ///     字符元素3:1：激活状态；0：停用状态
        /// </returns>
        public string[] GetLocationInfo(long id, long userId)
        {
            string[] strs = new string[3] { "0", "0", "0" };
            var lct = dal.FindById(id);
            if (lct == null)
                return null;
            if (lct.resource_id != null)
                strs[0] = "1";
            if (lct.is_default == 1)
                strs[1] = "1";
            if (lct.is_active == 1)
                strs[2] = "1";

            return strs;
        }
    }
}
