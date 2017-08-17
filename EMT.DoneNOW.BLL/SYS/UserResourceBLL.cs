using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class UserResourceBLL
    {
        private readonly sys_resource_dal _dal = new sys_resource_dal();
        //对页面SysManage.aaspx的数据填充
        public Dictionary<string, object> GetDownList()
        {
            Dictionary<string, object> dic = new Dictionary<string, object>();
            dic.Add("DateFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.DATE_DISPLAY_FORMAT)));              // 日期格式
            dic.Add("NumberFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NUMBER_DISPLAY_FORMAT)));              // 数字格式
            dic.Add("TimeFormat", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.TIME_DISPLAY_FORMAT)));              // 时间格式（正数）
            dic.Add("EmailType", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.EMAILTYPE)));
            dic.Add("Sex", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.SEX)));
            dic.Add("NameSuffix", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.NAME_SUFFIX)));
            dic.Add("Security_Level", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.LICENSE_TYPE)));
            dic.Add("Outsource_Security", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OUTSOURCE_SECURITY)));

            return dic;

        }
        public ERROR_CODE Insert(sys_resource resource, long user_id) {
            resource.id= (int)(_dal.GetNextIdCom());
            resource.create_user_id = resource.update_user_id = user_id;
            resource.create_time =resource.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Insert(resource);
            //操作日志新增一条日志,操作对象种类：员工
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name = "",
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CUSTOMER,
                oper_object_id = resource.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(resource),
                remark = "保存客户信息"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            return ERROR_CODE.SUCCESS;
        }

    }
}
