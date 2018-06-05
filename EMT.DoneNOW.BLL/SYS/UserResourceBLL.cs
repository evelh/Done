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
        private readonly sys_user_dal _dal1 = new sys_user_dal();

        /// <summary>
        /// 获取员工
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_resource GetResourceById(long id)
        {
            return _dal.FindById(id);
        }

        /// <summary>
        /// 获取用户
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_user GetUserById(long id)
        {
            return _dal1.FindById(id);
        }

        /// <summary>
        /// 获取激活的员工列表
        /// </summary>
        /// <returns></returns>
        public List<DictionaryEntryDto> GetResourceList()
        {
            return _dal.GetDictionary(true);
        }

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

            //权限
            var Security_Level = new sys_security_level_dal().FindListBySql("select id,name from sys_security_level where delete_time=0");
            dic.Add("Security_Level", Security_Level);

            //地址
            var Position = new sys_organization_location_dal().FindListBySql("select id,name from sys_organization_location where delete_time=0");
            dic.Add("Position", Position);
            // Position
            dic.Add("Outsource_Security", new d_general_dal().GetDictionary(new d_general_table_dal().GetById((int)GeneralTableEnum.OUTSOURCE_SECURITY)));
            //var location=new sys_organization_location_dal()
            //Position
            return dic;

        }
        /// <summary>
        /// 新增员工信息
        /// </summary>
        /// <param name="data"></param>
        /// <param name="user_id"></param>
        /// <param name="id"></param>
        /// <returns></returns>
        public ERROR_CODE Insert(SysUserAddDto data, long user_id,out long id)
        {
            id = data.sys_res.id = _dal.GetNextIdCom();
            sys_resource findRes;
            if (string.IsNullOrEmpty(data.sys_res.mobile_phone))
                findRes = _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where email='{data.sys_res.email}' and delete_time=0");
            else
                findRes = _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where (email='{data.sys_res.email}' or mobile_phone='{data.sys_res.mobile_phone}') and delete_time=0");
            if (findRes != null)
                return ERROR_CODE.SYS_NAME_EXIST;
            
            data.sys_res.create_user_id = data.sys_res.update_user_id = user_id;
            data.sys_res.create_time = data.sys_res.update_time= Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Insert(data.sys_res);
            //操作日志新增一条日志,操作对象种类：员工
            var user = UserInfoBLL.GetUserInfo(user_id);
            if (user == null)
                return ERROR_CODE.USER_NOT_FIND;
            var add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
                name =user.name,
                phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,//员工
                oper_object_id = data.sys_res.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data.sys_res),
                remark = "保存员工信息"
            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);       // 插入日志

            data.sys_user.id = id;
            //加密
           data.sys_user.password = new Tools.Cryptographys().SHA1Encrypt(data.sys_user.password);
            new sys_user_dal().Insert(data.sys_user);

          add_account_log = new sys_oper_log()
            {
                user_cate = "用户",
                user_id = (int)user.id,
              name = user.name,
              phone = user.mobile == null ? "" : user.mobile,
                oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                oper_object_id = data.sys_user.id,// 操作对象id
                oper_type_id = (int)OPER_LOG_TYPE.ADD,
                oper_description = _dal.AddValue(data.sys_user),
                remark = "保存客户信息"

            };          // 创建日志
            new sys_oper_log_dal().Insert(add_account_log);

            if (data.timeoffPolicy != null)
            {
                new TimeOffPolicyBLL().AddTimeoffResource(id.ToString(), data.timeoffPolicy.timeoff_policy_id, data.timeoffPolicy.effective_date, user_id);
            }
            if (data.internalCost != null && data.internalCost.Count > 0)
            {
                var costDal = new sys_resource_internal_cost_dal();
                foreach (var cost in data.internalCost)
                {
                    cost.resource_id = id;
                    cost.id = costDal.GetNextIdCom();
                    costDal.Insert(cost);
                }
            }
            if (data.availability != null)
            {
                data.availability.id = _dal.GetNextIdCom();
                data.availability.resource_id = id;
                data.availability.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                data.availability.update_time = data.availability.create_time;
                data.availability.create_user_id = user_id;
                data.availability.update_user_id = user_id;
                new sys_resource_availability_dal().Insert(data.availability);
            }

            sys_resource_additional_time_dal timeDal = new sys_resource_additional_time_dal();
            if (data.addTime1 != null)
            {
                data.addTime1.id = timeDal.GetNextIdCom();
                data.addTime1.resource_id = id;
                timeDal.Insert(data.addTime1);
            }
            if (data.addTime2 != null)
            {
                data.addTime2.id = timeDal.GetNextIdCom();
                data.addTime2.resource_id = id;
                timeDal.Insert(data.addTime2);
            }

            return ERROR_CODE.SUCCESS;
        }
        /// <summary>
        /// 更新员工信息
        /// </summary>
        /// <param name="data"></param>
        /// <param name="userId"></param>
        /// <param name="resourceId"></param>
        /// <returns></returns>
        public ERROR_CODE Update(SysUserAddDto data, long userId,long resourceId)
        {
            // 检查邮箱和手机号是否重复
            sys_resource findRes;
            if (string.IsNullOrEmpty(data.sys_res.mobile_phone))
                findRes = _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where email='{data.sys_res.email}' and id<>{data.sys_res.id} and delete_time=0");
            else
                findRes = _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where (email='{data.sys_res.email}' or mobile_phone='{data.sys_res.mobile_phone}') and id<>{data.sys_res.id} and delete_time=0");
            if (findRes != null)
            {
                return ERROR_CODE.SYS_NAME_EXIST;
            }

            var resOld = GetResourceById(resourceId);
            data.sys_res.update_user_id = userId;
            data.sys_res.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
            var desc = OperLogBLL.CompareValue<sys_resource>(resOld, data.sys_res);
            if (!string.IsNullOrEmpty(desc))
            {
                _dal.Update(data.sys_res);
                OperLogBLL.OperLogUpdate(desc, data.sys_res.id, userId, OPER_LOG_OBJ_CATE.RESOURCE, "编辑员工");
            }

            var userDal = new sys_user_dal();
            var userOld = userDal.FindById(resourceId);
            if (userOld.password != data.sys_user.password)
                data.sys_user.password = new Tools.Cryptographys().SHA1Encrypt(data.sys_user.password);
            desc = OperLogBLL.CompareValue<sys_user>(userOld, data.sys_user);
            if (!string.IsNullOrEmpty(desc))
            {
                userDal.Update(data.sys_user);
                OperLogBLL.OperLogUpdate(desc, data.sys_user.id, userId, OPER_LOG_OBJ_CATE.RESOURCE, "编辑员工");
            }
            

            // 员工每天工作时间
            var dal = new sys_resource_availability_dal();
            var ava = dal.FindSignleBySql<sys_resource_availability>($"select * from sys_resource_availability where resource_id={resourceId} and delete_time=0");
            if (ava == null)
            {
                data.availability.id = dal.GetNextIdCom();
                data.availability.resource_id = resourceId;
                data.availability.create_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                data.availability.update_time = data.availability.create_time;
                data.availability.create_user_id = userId;
                data.availability.update_user_id = userId;
                dal.Insert(data.availability);
            }
            else
            {
                data.availability.id = ava.id;
                data.availability.resource_id = resourceId;
                data.availability.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp();
                data.availability.update_user_id = userId;
                data.availability.create_time = ava.create_time;
                data.availability.create_user_id = ava.create_user_id;
                dal.Update(data.availability);
            }

            // 员工休假-额外时间
            sys_resource_additional_time_dal timeDal = new sys_resource_additional_time_dal();
            if (data.addTime1 != null)
            {
                var time1 = timeDal.FindSignleBySql<sys_resource_additional_time>($"select * from sys_resource_additional_time where resource_id={resourceId} and period_year={data.addTime1.period_year.Value}");
                if (time1 == null)
                {
                    data.addTime1.id = timeDal.GetNextIdCom();
                    data.addTime1.resource_id = resourceId;
                    timeDal.Insert(data.addTime1);
                }
                else
                {
                    time1.time_vacation = data.addTime1.time_vacation;
                    time1.time_personal = data.addTime1.time_personal;
                    time1.time_sick = data.addTime1.time_sick;
                    time1.time_float = data.addTime1.time_float;
                    timeDal.Update(time1);
                }
            }
            if (data.addTime2 != null)
            {
                var time2 = timeDal.FindSignleBySql<sys_resource_additional_time>($"select * from sys_resource_additional_time where resource_id={resourceId} and period_year={data.addTime2.period_year.Value}");
                if (time2 == null)
                {
                    data.addTime2.id = timeDal.GetNextIdCom();
                    data.addTime2.resource_id = resourceId;
                    timeDal.Insert(data.addTime2);
                }
                else
                {
                    time2.time_vacation = data.addTime2.time_vacation;
                    time2.time_personal = data.addTime2.time_personal;
                    time2.time_sick = data.addTime2.time_sick;
                    time2.time_float = data.addTime2.time_float;
                    timeDal.Update(time2);
                }
            }

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 获取员工休假额外时间
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="year"></param>
        /// <returns></returns>
        public sys_resource_additional_time GetResAdddtionalTime(long resId, int year)
        {
            return _dal.FindSignleBySql<sys_resource_additional_time>($"select * from sys_resource_additional_time where resource_id={resId} and period_year={year}");
        }

        /// <summary>
        /// 通过id获得员工资源信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_resource GetSysResourceSingle(long id) {
           return  _dal.FindSignleBySql<sys_resource>($"select * from sys_resource where id={id} and delete_time=0");
        }
        /// <summary>
        /// 返回员工账户信息
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public sys_user GetSysUserSingle(long id)
        {
            return _dal1.FindSignleBySql<sys_user>($"select * from sys_user where id={id}");
        }
        /// <summary>
        /// 获取所有
        /// </summary>
        /// <returns></returns>
        public List<sys_resource> GetAllSysResource() {
            return _dal.FindListBySql<sys_resource>($"select * from sys_resource where delete_time=0").ToList();
        }
        public void UpdatePermission(sys_resource res, long user_id) {
            res.update_user_id = user_id;
            res.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            if (_dal.Update(res)) {
                var add_account_log = new sys_oper_log();
                var user = UserInfoBLL.GetUserInfo(user_id);
                add_account_log = new sys_oper_log()
                {
                    user_cate = "用户",
                    user_id = (int)user.id,
                    name = user.name,
                    phone = user.mobile == null ? "" : user.mobile,
                    oper_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now),
                    oper_object_cate_id = (int)OPER_LOG_OBJ_CATE.CONTACTS,
                    oper_object_id = res.id,// 操作对象id
                    oper_type_id = (int)OPER_LOG_TYPE.UPDATE,
                    oper_description = _dal.AddValue(res),
                    remark = "更新客户信息权限"
                };          // 创建日志
                new sys_oper_log_dal().Insert(add_account_log);
            }
        }
        /// <summary>
        /// 获取员工每天工作时间
        /// </summary>
        /// <param name="resId"></param>
        /// <returns></returns>
        public sys_resource_availability GetResourceAvailability(long resId)
        {
            return _dal.FindSignleBySql<sys_resource_availability>($"select * from sys_resource_availability where resource_id={resId} and delete_time=0");
        }
        /// <summary>
        /// 获取员工每天工作时间
        /// </summary>
        /// <param name="resId"></param>
        /// <returns></returns>
        public sys_resource_availability GetResourceAvailabilityById(long id)
        {
            return new sys_resource_availability_dal().FindNoDeleteById(id); ;
        }
        public sys_resource_availability GetAvailabilityByResId(long resId)
        {
            return new sys_resource_availability_dal().FindSignleBySql<sys_resource_availability>($"SELECT * from sys_resource_availability where resource_id = {resId.ToString()} and delete_time = 0");
        }
        /// <summary>
        /// 获取员工休假策略
        /// </summary>
        /// <param name="resId"></param>
        /// <returns></returns>
        public tst_timeoff_policy_resource GetResourceTimeoffPolicy(long resId)
        {
            return _dal.FindSignleBySql<tst_timeoff_policy_resource>($"select * from tst_timeoff_policy_resource where resource_id={resId} and delete_time=0 ");
        }

        #region 编辑新增员工属性
        /// <summary>
        /// 获取员工内部成本列表
        /// </summary>
        /// <param name="resId"></param>
        /// <returns></returns>
        public List<sys_resource_internal_cost> GetInternalCostList(long resId)
        {
            var dal = new sys_resource_internal_cost_dal();
            var costList = dal.FindListBySql($"select * from sys_resource_internal_cost where resource_id={resId} order by start_date asc");
            return costList;
        }
        /// <summary>
        /// 新增员工内部成本
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="start"></param>
        /// <param name="rate"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<sys_resource_internal_cost> AddInternalCost(long resId, DateTime start, decimal rate, long userId)
        {
            var dal = new sys_resource_internal_cost_dal();
            var costList = GetInternalCostList(resId);
            if (costList.Count == 0)    // 第一条
            {
                sys_resource_internal_cost cost = new sys_resource_internal_cost
                {
                    id = dal.GetNextIdCom(),
                    resource_id = resId,
                    hourly_rate = rate
                };
                dal.Insert(cost);
                costList.Add(cost);
            }
            else
            {
                var fd = costList.Find(_ => _.start_date == start);
                if (fd != null)     // 开始时间不能重复
                {
                    return null;
                }
                sys_resource_internal_cost cost = new sys_resource_internal_cost();
                cost.id = dal.GetNextIdCom();
                cost.start_date = start;
                cost.hourly_rate = rate;
                cost.resource_id = resId;
                if (costList[0].end_date != null && costList[0].end_date.Value >= start)    // 生效时间最前，作为第二条
                {
                    costList[0].end_date = start.AddDays(-1);
                    cost.end_date = costList[1].start_date.Value.AddDays(-1);
                    dal.Update(costList[0]);    // 更新第一条的结束时间
                    costList.Insert(1, cost);
                }
                else if (costList[0].end_date == null)      // 当前只有一条，作为第二条
                {
                    costList[0].end_date = cost.start_date.Value.AddDays(-1);
                    dal.Update(costList[0]);    // 更新第一条的结束时间
                    costList.Insert(1, cost);
                }
                else if (cost.start_date.Value > costList[costList.Count - 1].start_date.Value)     // 生效时间最后，最后一条
                {
                    costList[costList.Count - 1].end_date = cost.start_date.Value.AddDays(-1);
                    dal.Update(costList[costList.Count - 1]);    // 更新最后一条的结束时间
                    costList.Add(cost);
                }
                else    // 生效时间在中间
                {
                    for (int i = 1; i < costList.Count - 2; i++)
                    {
                        if (costList[i].start_date.Value < cost.start_date.Value && costList[i + 1].start_date.Value > cost.start_date.Value)   // 找到按顺序的时间前后项
                        {
                            costList[i].end_date = cost.start_date.Value.AddDays(-1);
                            cost.end_date = costList[i + 1].start_date.Value.AddDays(-1);
                            dal.Update(costList[i]);        // 更新前一条的结束时间
                            dal.Update(costList[i + 1]);    // 更新后一条的开始时间
                            costList.Insert(i + 1, cost);
                        }
                    }
                }
                dal.Insert(cost);
            }
            return costList;
        }

        /// <summary>
        /// 删除员工内部成本
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="id"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<sys_resource_internal_cost> DeleteInternalCost(long resId, long id, long userId)
        {
            var dal = new sys_resource_internal_cost_dal();
            var costList = GetInternalCostList(resId);
            if (costList == null || costList.Count == 1)
            {
                return null;
            }

            int idx = costList.FindIndex(_ => _.id == id);
            if (idx == -1)
            {
                return costList;
            }

            if (idx == 0)   // 第一个
            {
                costList[1].start_date = null;
                dal.Update(costList[1]);
            }
            else if (idx == costList.Count - 1)  // 最后一个
            {
                costList[idx - 1].end_date = null;
                dal.Update(costList[idx - 1]);
            }
            else
            {
                costList[idx - 1].end_date = costList[idx].end_date;
                dal.Update(costList[idx - 1]);
            }
            costList.RemoveAt(idx);
            dal.Delete(costList[idx]);

            return costList;
        }

        /// <summary>
        /// 新增员工审批人
        /// </summary>
        /// <param name="approverId"></param>
        /// <param name="tier"></param>
        /// <param name="resId"></param>
        /// <param name="type">审批类型</param>
        /// <returns></returns>
        public bool AddApprover(long approverId, int tier, long resId, DicEnum.APPROVE_TYPE type)
        {
            sys_resource_approver appr = new sys_resource_approver();
            sys_resource_approver_dal appDal = new sys_resource_approver_dal();

            int count = appDal.FindSignleBySql<int>($"select count(0) from sys_resource_approver where resource_id={resId} and approver_resource_id={approverId} and approve_type_id={(int)type} and tier={tier}");
            if (count > 0)
                return false;

            appr.id = appDal.GetNextIdCom();
            appr.resource_id = resId;
            appr.approver_resource_id = approverId;
            appr.approve_type_id = (int)type;
            appr.tier = tier;
            appDal.Insert(appr);

            return true;
        }

        /// <summary>
        /// 删除员工审批人
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteApprover(long id)
        {
            sys_resource_approver_dal appDal = new sys_resource_approver_dal();
            int count = appDal.ExecuteSQL($"delete from sys_resource_approver where id={id}");
            if (count > 0)
                return true;
            return false;
        }

        /// <summary>
        /// 新增员工技能
        /// </summary>
        /// <param name="resId"></param>
        /// <param name="cate"></param>
        /// <param name="level"></param>
        /// <param name="desc"></param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddSkill(long resId, int cate, int? level, string desc, sbyte? complete, long userId)
        {
            sys_resource_skill skill = new sys_resource_skill();
            sys_resource_skill_dal skillDal = new sys_resource_skill_dal();
            skill.id = skillDal.GetNextIdCom();
            skill.resource_id = resId;
            skill.skill_type_id = cate;
            skill.skill_level_id = level;
            skill.description = desc;
            skill.is_completed = complete;
            skillDal.Insert(skill);

            return true;
        }

        /// <summary>
        /// 删除员工技能
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteSkill(long id)
        {
            sys_resource_skill_dal skillDal = new sys_resource_skill_dal();
            var skill = skillDal.FindById(id);
            if (skill == null)
                return false;

            skillDal.Delete(skill);
            return true;
        }

        /// <summary>
        /// 新增员工部门
        /// </summary>
        /// <param name="resDpt"></param>
        /// <param name="type">1:部门;2:队列</param>
        /// <param name="userId"></param>
        /// <returns></returns>
        public bool AddDepartment(sys_resource_department resDpt, int type, long userId)
        {
            sys_resource_department_dal dptDal = new sys_resource_department_dal();
            if (resDpt.is_default == 1)     // 新增默认部门，查找是否已有默认，有则更改为非默认
            {
                string sql = $"select * from sys_resource_department where resource_id={resDpt.resource_id} and is_default=1 and department_id in(select id from sys_department where cate_id={(int)DTO.DicEnum.DEPARTMENT_CATE.DEPARTMENT} and is_active =1 and delete_time = 0)";
                if (type == 2)
                    sql = $"select * from sys_resource_department where resource_id={resDpt.resource_id} and is_default=1 and department_id in(select id from sys_department where cate_id={(int)DTO.DicEnum.DEPARTMENT_CATE.SERVICE_QUEUE} and is_active =1 and delete_time = 0)";
                var dft = dptDal.FindSignleBySql<sys_resource_department>(sql);
                if (dft != null)
                {
                    dft.is_default = 0;
                    dptDal.Update(dft);
                }
            }
            resDpt.id = dptDal.GetNextIdCom();
            dptDal.Insert(resDpt);

            return true;
        }

        /// <summary>
        /// 删除员工部门
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public bool DeleteDepartment(long id)
        {
            sys_resource_department_dal dptDal = new sys_resource_department_dal();
            var dpt = dptDal.FindById(id);
            if (dpt == null)
                return false;

            dptDal.Delete(dpt);
            return true;
        }
        #endregion

        /// <summary>
        /// 根据系统设置获取自己可以审批的员工信息
        /// </summary>
        public List<sys_resource> GetAgentUser(long userId,out bool isAgent)
        {
            isAgent = false;
            List<sys_resource> resList = null;
            var entryProxySet = new SysSettingBLL().GetValueById(SysSettingEnum.SDK_ENTRY_PROXY);
            if (entryProxySet == ((int)DicEnum.PROXY_TIME_ENTRY.DISABLED).ToString())
                isAgent = false;
            else
            {
                isAgent = true;
                if (entryProxySet == ((int)DicEnum.PROXY_TIME_ENTRY.ENABLED_TIMESHEET_APPROVERS).ToString())
                    resList =  new sys_resource_dal().FindListBySql($"select sr.* from sys_resource_approver srp INNER JOIN sys_resource sr on srp.resource_id = sr.id where srp.approve_type_id=673 and srp.approver_resource_id={userId} union SELECT * from sys_resource where id = {userId} and delete_time = 0 ");
                else if(entryProxySet == ((int)DicEnum.PROXY_TIME_ENTRY.ENABLED_TIMESHEET_APPROVERS_ADMINISTRATORS).ToString())
                {
                    var powerRes = new sys_resource_dal().FindListBySql("select *  from sys_resource where  security_level_id=1");
                    if(powerRes!=null&& powerRes.Count > 0)
                    {
                        if (powerRes.Any(_ => _.id == userId))
                            return new sys_resource_dal().GetSourceList();
                    }
                    resList = new sys_resource_dal().FindListBySql($"select sr.* from sys_resource_approver srp INNER JOIN sys_resource sr on srp.resource_id = sr.id where srp.approve_type_id=673 and srp.approver_resource_id={userId} union SELECT * from sys_resource where id = {userId} and delete_time = 0 ");
                }
            }
            return resList;
        }

        /// <summary>
        /// 编辑员工的周目标
        /// </summary>
        public bool EditResAvaGoal(long resAvaId,decimal goal,long userId)
        {
            sys_resource_availability thisResAva = GetResourceAvailabilityById(resAvaId);
            if (thisResAva == null)
                return false;
            if(thisResAva.goal!= goal)
            {
                sys_resource_availability oldResAva = GetResourceAvailabilityById(resAvaId);
                thisResAva.goal = goal;
                thisResAva.update_user_id = userId;
                thisResAva.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                new sys_resource_availability_dal().Update(thisResAva);
                OperLogBLL.OperLogUpdate<sys_resource_availability>(thisResAva, oldResAva, thisResAva.id,userId,OPER_LOG_OBJ_CATE.RESOURCE,"");
            }
            return true;
        }

        /// <summary>
        /// 编辑员工的周目标
        /// </summary>
        public bool EditResProtected(long resId,bool isEdit,bool isView,bool isEditUn,bool isViewUn,long userId)
        {
            var thisRes = GetResourceById(resId);
            if (thisRes == null)
                return false;
            sys_resource oldRes = GetResourceById(resId);
            thisRes.edit_protected_data = (sbyte)(isEdit?1:0);
            thisRes.view_protected_data = (sbyte)(isView ? 1 : 0);
            thisRes.edit_unprotected_data = (sbyte)(isEditUn ? 1 : 0);
            thisRes.view_unprotected_data = (sbyte)(isViewUn ? 1 : 0);
            thisRes.update_user_id = userId;
            thisRes.update_time = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
            _dal.Update(thisRes);
            OperLogBLL.OperLogUpdate<sys_resource>(thisRes, oldRes, thisRes.id, userId, OPER_LOG_OBJ_CATE.RESOURCE, "");
            
            return true;
        }
        /// <summary>
        /// 转移员工(更改员工的客户，商机，待办，活动)
        /// </summary>
        public bool TransResource(long fromResId,long toResId,long userId)
        {
            if (fromResId == toResId)
                return true;
            var fromRes = GetResourceById(fromResId);
            var toRes = GetResourceById(toResId);
            if (fromRes == null || toRes == null)
                return false;
            CompanyBLL accBll = new CompanyBLL();
            List<crm_account> accList = accBll.GetBySql<crm_account>("SELECT * from crm_account a where a.delete_time =0 and a.resource_id = " + fromResId.ToString());
            if (accList != null && accList.Count > 0)
                accList.ForEach(_=> {
                    _.resource_id = toResId;
                    accBll.EditAccount(_,userId);
                });

            OpportunityBLL oppoBll = new OpportunityBLL();
            List<crm_opportunity> oppoList = oppoBll.GetOppoBySql($"SELECT * from crm_opportunity where delete_time =0 and resource_id = {fromResId.ToString()} and status_id not in ({(int)DicEnum.OPPORTUNITY_STATUS.LOST},{(int)DicEnum.OPPORTUNITY_STATUS.CLOSED},{(int)DicEnum.OPPORTUNITY_STATUS.IMPLEMENTED})");
            if (oppoList != null && oppoList.Count > 0)
                oppoList.ForEach(_ => {
                    _.resource_id = toResId;
                    oppoBll.EdotOpportunity(_, userId);
                });

            ActivityBLL actBll = new ActivityBLL();
            List<com_activity> actList = actBll.GetToListBySql($"select id,name,description from com_activity where delete_time =0 and resource_id = {fromResId.ToString()} and (status_id <> {(int)DicEnum.ACTIVITY_STATUS.COMPLETED} or status_id is null)");
            if (actList != null && actList.Count > 0)
                actList.ForEach(_ => {
                    _.resource_id = toResId;
                    actBll.EditActivity(_, userId);
                });
            return true;
        }
    }
}
