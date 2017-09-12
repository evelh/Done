using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

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
            //groupid=data.id=(int)(_dal.GetNextIdCom());
            data.parent_id = (int)DicEnum.UDF_CATE.CONFIGURATION_ITEMS;
            data.general_table_id = (int)GeneralTableEnum.UDF_FILED_GROUP;
            var res = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res != null)
            {
                return ERROR_CODE.EXIST;
            }
            data.create_time = data.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.create_user_id =data.update_user_id= user_id;           
            _dal.Insert(data);
            var add_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data),
                remark = "新增自定义字段组47"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_log);       // 插入日志
            var k= _dal.FindSignleBySql<d_general>($"select * from d_general where name={data.name} and general_table_id={data.general_table_id} and delete_time=0");
            if (k == null) {
                return ERROR_CODE.ERROR;
            }else
            {
                groupid = k.id;
            }
            //新增配置项类型（table=108）
            data.ext1 = groupid.ToString();
            data.general_table_id = (int)GeneralTableEnum.INSTALLED_PRODUCT_CATE;
            var res2 = new GeneralBLL().GetSingleGeneral(data.name, data.general_table_id);
            if (res2 != null)
            {
                return ERROR_CODE.EXIST;
            }
            _dal.Insert(data);
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data),
                remark = "新增配置项类型"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
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
                    var add2_log = new sys_oper_log()
                    {
                        user_cate = "用户",
                        user_id = (int)user.id,
                        name = "",
                        phone = user.mobile == null ? "" : user.mobile,
                        oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                        oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                        oper_object_id = groupfield.id,// 操作对象id
                        oper_type_id = (int)OPER_LOG_TYPE.ADD,
                        oper_description = _dal.AddValue(groupfield),
                        remark = "新增自定义字段组"
                    };          // 创建日志
                    new sys_oper_log_dal().Insert(add2_log);       // 插入日志
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
            var add2_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(data),
                remark = "修改自定义字段组"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add2_log);       // 插入日志
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
            var add1_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                oper_object_id = data.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                oper_description = _dal.AddValue(data),
                remark = "修改配置项类型"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add1_log);       // 插入日志
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
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                            oper_object_id = groupfield.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.ADD,
                            oper_description = _dal.AddValue(groupfield),
                            remark = "新增自定义字段组"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                    }
                    else {
                        //修改
                        groupfield.is_required = t.is_required;
                        groupfield.sort_order = t.sort_order;
                        if (!udf_group_dal.Update(groupfield)) {
                            return ERROR_CODE.ERROR;
                        }
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                            oper_object_id = groupfield.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.AddValue(groupfield),
                            remark = "修改自定义字段组"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
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
                var add_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = "",
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                    oper_object_id = groupfield.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.DELETE,
                    oper_description = _dal.AddValue(groupfield),
                    remark = "删除自定义字段组"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_log);       // 插入日志
            }
            return ERROR_CODE.SUCCESS;
        }
        //删除前的数据校验
        public ERROR_CODE Delete_Valid(long id,long user_id,out string returnvalue) {
            returnvalue = string.Empty;
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            if (data.is_system > 0)
            {
                return ERROR_CODE.SYSTEM;
            }
            //d_general、ivt_product、crm_installed_product
            //有n个产品种类、n个产品、n个配置项
            int installed_product = new crm_installed_product_dal().ExecuteSQL($"select * from crm_installed_product where cate_id={id} and delete_time=0");
            int product = new ivt_product_dal().ExecuteSQL($"select * from ivt_product where installed_product_cate_id={id} and delete_time=0");
            int product_cate = _dal.ExecuteSQL($"select * from d_general where ext1='{id.ToString()}' and delete_time=0");
            if (installed_product > 0 || product > 0 || product_cate > 0) {
                returnvalue = @"有"+ product_cate + "个产品种类、"+product+"个产品、"+ installed_product + "个配置项关联此配置项类型。如果删除，则相关产品种类、产品、配置项上的配置项类型信息将会被清空，并且配置项上将会显示全部相关自定义字段。是否继续";
                return ERROR_CODE.EXIST;
            }
            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        ///  //删除操作
        /// </summary>
        /// <param name="id"></param>
        /// <param name="user_id"></param>
        /// <returns></returns>
        public ERROR_CODE Delete(long id, long user_id)
        {
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
            {   // 查询不到用户，用户丢失
                return ERROR_CODE.USER_NOT_FIND;
            }
            var data = _dal.FindById(id);
            if (data == null)
            {
                return ERROR_CODE.ERROR;
            }
            var udf_data = _dal.FindById(Convert.ToInt64(data.ext1));
            crm_installed_product_dal dal1 = new crm_installed_product_dal();
            ivt_product_dal dal2 = new ivt_product_dal();

            var installed_product = dal1.FindListBySql($"select * from crm_installed_product where cate_id={id} and delete_time=0");
            var product = dal2.FindListBySql($"select * from ivt_product where installed_product_cate_id={id} and delete_time=0");
            var product_cate = _dal.FindListBySql($"select * from d_general where ext1='{id.ToString()}' and delete_time=0");
            if (installed_product.Count > 0) {
                foreach (var i in installed_product) {
                    i.cate_id = 0;
                    i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    i.update_user_id = user_id;
                    if (dal1.Update(i)) {
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONFIGURAITEM,//
                            oper_object_id = i.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.AddValue(i),
                            remark = "修改产品配置项"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                    }
                }
            }
            if (product.Count > 0)
            {
                foreach (var i in product)
                {
                    i.installed_product_cate_id =null;
                    i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    i.update_user_id = user_id;
                    if (dal2.Update(i))
                    {
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.PRODUCT,//
                            oper_object_id = i.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.AddValue(i),
                            remark = "修改产品配置项"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                    }
                }
            }
            if (product_cate.Count > 0)
            {
                foreach (var i in product_cate)
                {
                    i.ext1 = null;
                    i.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                    i.update_user_id = user_id;
                    if (_dal.Update(i))
                    {
                        var add_log = new sys_oper_log()
                        {
                            user_cate = "用户",
                            user_id = (int)user.id,
                            name = "",
                            phone = user.mobile == null ? "" : user.mobile,
                            oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                            oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.General_Code,//
                            oper_object_id = i.id,// 操作对象id
                            oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                            oper_description = _dal.AddValue(i),
                            remark = "修改配置项种类"
                        };          // 创建日志
                        new sys_oper_log_dal().Insert(add_log);       // 插入日志
                    }
                }
            }

           long time= data.delete_time = udf_data.delete_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            data.delete_user_id = udf_data.delete_user_id = user.id;
            try
            {
                int n = new sys_udf_group_field_dal().ExecuteSQL($"update sys_udf_group_field set delete_time='{time}' and delete_user_id='{user.id}' where group_id={udf_data.id}");
            }
            catch {
                return ERROR_CODE.ERROR;
            }
            if (!_dal.Update(data)) {
                return ERROR_CODE.ERROR;
            }
            if (!_dal.Update(udf_data)) {
                return ERROR_CODE.ERROR;
            }

            return ERROR_CODE.SUCCESS;
        }
    }
}
