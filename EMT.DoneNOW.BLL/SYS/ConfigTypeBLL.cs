using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.BLL
{
    /// <summary>
    /// 配置项类型
    /// </summary>
   public class ConfigTypeBLL
    {
        private readonly d_general_dal _dal = new d_general_dal();//字典项对象
        private readonly sys_udf_group_field_dal udf_group_dal = new sys_udf_group_field_dal();//用户自定义字段组
        private readonly sys_udf_field_dal udf_dal = new sys_udf_field_dal();//用户自定义字段
        /// <summary>
        /// 获取所有的用户自定义项
        /// </summary>
        /// <returns></returns>
        public List<sys_udf_field> GetAlludf(long group_id) {
            return udf_dal.FindListBySql<sys_udf_field>($"SELECT a.id,a.col_comment,b.is_required,a.is_protected,b.sort_order from sys_udf_field a left join (select * from sys_udf_group_field where id={group_id}) b on a.id=b.udf_field_id where a.delete_time=0 order by b.sort_order,a.sort_order");
        }
        /// <summary>
        /// 通过字段组id获取所有关联字段
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public List<sys_udf_group_field> GetUdfGroup(long id) {
            return udf_group_dal.FindListBySql<sys_udf_group_field>($"select * from sys_udf_group_field where group_id={id} and delete_time=0");
        }
        /// <summary>
        /// 新增配置项类型
        /// </summary>
        /// <param name="data"></param>
        /// <param name="group"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE InsertConfigType(d_general data,List<ConfigUserDefinedFieldDto> group,long user_id) {
            int groupid;//自定义分组id
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //新增自定义字段组47
            groupid=data.id=(int)(_dal.GetNextIdCom());
            data.general_table_id = (int)GeneralTableEnum.UDF_FILED_GROUP;
            var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res != null)
            {
                return ERROR_CODE.EXIST;
            }
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id =data.update_user_id= user_id;           
            _dal.Insert(data);

            //新增配置项类型（table=108）

            data.ext1 = data.id.ToString();
            data.id= (int)(_dal.GetNextIdCom());
            data.general_table_id = (int)GeneralTableEnum.INSTALLED_PRODUCT_CATE;
            var res2 = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res2 != null)
            {
                return ERROR_CODE.EXIST;
            }
            _dal.Insert(data);
            //自定义字段组
            sys_udf_group_field groupfield = new sys_udf_group_field();
            groupfield.create_time=groupfield.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            groupfield.create_user_id = groupfield.update_user_id = user.id;
            groupfield.group_id = groupid;
            foreach (var t in group) {
                if (t.id != 0) {
                    groupfield.udf_field_id = t.id;
                    groupfield.is_required = t.is_required;
                    groupfield.sort_order = t.sort_order;
                    udf_group_dal.Insert(groupfield);
                }
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新配置项类型
        /// </summary>
        /// <param name="data"></param>
        /// <param name="group"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE UpdateConfigType(d_general data, List<ConfigUserDefinedFieldDto> group, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            //新增自定义字段组47
            data.general_table_id = (int)GeneralTableEnum.UDF_FILED_GROUP;
            var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res != null)
            {
                return ERROR_CODE.EXIST;
            }
           data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.update_user_id = user_id;
            if (!_dal.Update(data)) {
                return ERROR_CODE.ERROR;
            }
            //新增配置项类型（table=108）
            var res2 = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res2 != null)
            {
                return ERROR_CODE.EXIST;
            }
            if (!_dal.Update(data))
            {
                return ERROR_CODE.ERROR;
            }
            //自定义字段组
            sys_udf_group_field groupfield = new sys_udf_group_field();
           groupfield.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
           groupfield.update_user_id = user.id;
            var oldgroup = GetUdfGroup(data.id).ToDictionary(d=>d.id);
            foreach (var t in group)
            {
                if (t.id != 0)
                {
                    if(!oldgroup.ContainsKey(t.id))//如果原本的字段组不包含这个字段的id，则说明，这个字段是新增的
                    //var rere = udf_group_dal.FindSignleBySql<sys_udf_group_field>($"select * from sys_udf_group_field where group_id={data.id} and udf_field_id={t.id} and delete_time=0");
                    //if (rere == null)
                    {//新增
                        groupfield.udf_field_id = t.id;
                        groupfield.is_required = t.is_required;
                        groupfield.sort_order = t.sort_order;
                        udf_group_dal.Insert(groupfield);
                    }
                    else {
                        //修改
                        groupfield.is_required = t.is_required;
                        groupfield.sort_order = t.sort_order;
                        if (!udf_group_dal.Update(groupfield)) {
                            return ERROR_CODE.ERROR;
                        }
                    }
                    //记录失去的自定义字段
                    oldgroup.Remove(t.id);
                }
            }
            //删除失去的自定义字段
            foreach (var old in oldgroup) {
                old.Value.delete_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                old.Value.delete_user_id = user.id;
                if (!udf_group_dal.Update(old.Value)) {
                    return ERROR_CODE.ERROR;
                }
            }
            return ERROR_CODE.SUCCESS;
        }
    }
}
