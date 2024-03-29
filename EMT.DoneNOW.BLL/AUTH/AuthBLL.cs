﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.DTO;
using EMT.Tools;
using JWT;

namespace EMT.DoneNOW.BLL
{
    public class AuthBLL
    {

        #region 登录
        /// <summary>
        /// 登录（不使用token）
        /// </summary>
        /// <param name="loginName"></param>
        /// <param name="password">md5后的登录密码</param>
        /// <param name="ip"></param>
        /// <param name="agent"></param>
        /// <param name="userInfo"></param>
        /// <returns></returns>
        public ERROR_CODE Login(string loginName, string password, string ip, string agent, out UserInfoDto userInfo)
        {
            userInfo = null;
            StringBuilder where = new StringBuilder();
            string loginType = "";
            // 判断登录类型是邮箱还是手机号
            if (new RegexOp().IsEmail(loginName))
            {
                where.Append($" email='{loginName}' ");
                loginType = "email";
            }
            else if (new RegexOp().IsMobilePhone(loginName))
            {
                where.Append($" mobile_phone='{loginName}' ");
                loginType = "mobile_phone";
            }
            else
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            List<sys_user> user = _dal.FindListBySql($"SELECT * FROM sys_user WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            if (!new Cryptographys().SHA1Encrypt(password).Equals(user[0].password))    // 密码错误
            {
                return ERROR_CODE.PASSWORD_ERROR;
            }
            if (user[0].status_id != (int)DicEnum.USER_STATUS.NORMAL)       // 用户状态不可用
                return ERROR_CODE.USER_NOT_FIND;

            //向sys_login_log表中插入日志
            sys_login_log login_log = new sys_login_log
            {
                id = _dal.GetNextIdSys(),
                ip = ip,
                agent = agent,
                login_time = DateTime.Now,
                name = "",
                user_id = user[0].id
            };
            if (loginType.Equals("email"))
            {
                login_log.email = loginName;
            }
            else if (loginType.Equals("mobile_phone"))
            {
                login_log.mobile_phone = loginName;
            }
            new sys_login_log_dal().Insert(login_log);

            userInfo = new UserInfoDto
            {
                id = user[0].id,
                name= user[0].name,
                mobile= user[0].mobile_phone,
                email= user[0].email,
            };
            var resource = new sys_resource_dal().FindById(user[0].id);
            userInfo.security_Level_id = (int)resource.security_level_id;

            return ERROR_CODE.SUCCESS;
        }
        #endregion

        #region 判断数据权限

        /// <summary>
        /// 判断用户对客户的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="companyId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserCompanyAuth(long userId, long secLevelId, long companyId)
        {
            AuthDetailDto dto = new AuthDetailDto();
            var limitViewCustomer = GetLimitValue(secLevelId, AuthLimitEnum.CRMCompanyViewCustomer);
            var limitViewVerdor = GetLimitValue(secLevelId, AuthLimitEnum.CRMCompanyViewVerdor);
            var limitViewPros = GetLimitValue(secLevelId, AuthLimitEnum.CRMCompanyViewProspect);

            if (limitViewCustomer == DicEnum.LIMIT_TYPE_VALUE.NONE961 && limitViewPros == DicEnum.LIMIT_TYPE_VALUE.NONE961 && limitViewVerdor == DicEnum.LIMIT_TYPE_VALUE.NONE963)
                return dto;

            crm_account_dal dal = new crm_account_dal();
            crm_account company = dal.FindById(companyId);
            if (company == null)
                return dto;

            var limitEdit = GetLimitValue(secLevelId, AuthLimitEnum.CRMCompanyEdit);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMCompanyDelete);
            if (company.type_id == (int)DicEnum.ACCOUNT_TYPE.MANUFACTURER || company.type_id == (int)DicEnum.ACCOUNT_TYPE.COOPERATIVE_PARTNER)  // 供应商或合作伙伴
            {
                if (limitViewVerdor == DicEnum.LIMIT_TYPE_VALUE.NONE963)
                    return dto;

                dto.CanView = true;
                if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                    dto.CanEdit = true;

                if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                    dto.CanDelete = true;

                if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962 || limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)   // 编辑或删除权限是我的
                {
                    if (company.resource_id == userId)
                    {
                        if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                            dto.CanEdit = true;
                        if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                            dto.CanDelete = true;
                    }
                    else
                    {
                        string sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId}";
                        if (company.territory_id != null)
                            sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId} or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id={company.territory_id} and resource_id={userId}) ";
                        if (!string.IsNullOrEmpty(dal.FindSignleBySql<string>(sql)))
                        {
                            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                dto.CanEdit = true;
                            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                dto.CanDelete = true;
                        }
                    }
                }
            }
            else    // 剩下五种处理方式相同
            {
                DicEnum.LIMIT_TYPE_VALUE limitValue;
                if (company.type_id == (int)DicEnum.ACCOUNT_TYPE.CUSTOMER || company.type_id == (int)DicEnum.ACCOUNT_TYPE.CANCELLATION_OF_CUSTOMER)
                    limitValue = limitViewCustomer;
                else
                    limitValue = limitViewPros;

                if (limitValue == DicEnum.LIMIT_TYPE_VALUE.NONE961)
                    return dto;

                if (limitValue == DicEnum.LIMIT_TYPE_VALUE.ALL961)   // 查看全部
                {
                    dto.CanView = true;
                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                        dto.CanEdit = true;

                    if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                        dto.CanDelete = true;

                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962 || limitDel== DicEnum.LIMIT_TYPE_VALUE.MINE962)   // 编辑或删除权限是我的
                    {
                        if (company.resource_id == userId)
                        {
                            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                dto.CanEdit = true;
                            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                dto.CanDelete = true;
                        }
                        else
                        {
                            string sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId}";
                            if (company.territory_id != null)
                                sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId} or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id={company.territory_id} and resource_id={userId}) ";
                            if (!string.IsNullOrEmpty(dal.FindSignleBySql<string>(sql)))
                            {
                                if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                    dto.CanEdit = true;
                                if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                                    dto.CanDelete = true;
                            }
                        }
                    }
                }
                else     // 查看我的/我的地域
                {
                    if (company.resource_id == userId)
                        dto.CanView = true;
                    else
                    {
                        string sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId}";
                        if (limitValue == DicEnum.LIMIT_TYPE_VALUE.MY_TORRITORY961 && company.territory_id != null)
                            sql = $"select 1 from crm_account_team where account_id={company.id} and resource_id={userId} or exists(select 1 from sys_resource_territory where delete_time=0 and territory_id={company.territory_id} and resource_id={userId}) ";
                        if (!string.IsNullOrEmpty(dal.FindSignleBySql<string>(sql)))
                            dto.CanView = true;
                    }
                    if (dto.CanView && limitEdit != DicEnum.LIMIT_TYPE_VALUE.NONE962)
                        dto.CanEdit = true;
                    if (dto.CanView && limitDel != DicEnum.LIMIT_TYPE_VALUE.NONE962)
                        dto.CanDelete = true;
                    
                }
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对联系人的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="contactId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserContactAuth(long userId, long secLevelId, long contactId)
        {
            var contact = new crm_contact_dal().FindById(contactId);
            if (contact == null)
                return new AuthDetailDto();
            return GetUserCompanyAuth(userId, secLevelId, contact.account_id);
        }

        /// <summary>
        /// 判断用户对商机的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="oppId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserOppAuth(long userId, long secLevelId, long oppId)
        {
            AuthDetailDto dto = new AuthDetailDto();
            crm_opportunity_dal dal = new crm_opportunity_dal();
            crm_opportunity opp = dal.FindById(oppId);
            if (opp == null)
                return dto;

            AuthDetailDto companyDto = GetUserCompanyAuth(userId, secLevelId, opp.account_id);
            if (companyDto.CanView == false)
                return dto;

            var limitView = GetLimitValue(secLevelId, AuthLimitEnum.CRMOpportunityQuoteView);
            var limitEdit = GetLimitValue(secLevelId, AuthLimitEnum.CRMOpportunityQuoteEdit);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMOpportunityQuoteDelete);
            if (limitView == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanView = true;
            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanEdit = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanDelete = true;

            if (limitView == DicEnum.LIMIT_TYPE_VALUE.MINE962
                || limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962
                || limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)    // 查看、编辑和删除有权限为我的
            {
                if (opp.resource_id == userId)    // 是我的商机
                {
                    if (limitView == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanView = true;
                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanEdit = true;
                    if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanDelete = true;
                }
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对报价的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="saleorderId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserQuoteAuth(long userId, long secLevelId, long quoteId)
        {
            var quote = new crm_quote_dal().FindById(quoteId);
            if (quote == null)
                return new AuthDetailDto();
            return GetUserOppAuth(userId, secLevelId, quote.opportunity_id);
        }

        /// <summary>
        /// 判断用户对销售订单的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="saleorderId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserSaleorderAuth(long userId, long secLevelId, long saleorderId)
        {
            var so = new crm_sales_order_dal().FindById(saleorderId);
            AuthDetailDto dto = new AuthDetailDto();
            if (so == null)
                return dto;
            var opp = new crm_opportunity_dal().FindById(so.opportunity_id);
            if (opp == null)
                return dto;
            var companyAuth = GetUserCompanyAuth(userId, secLevelId, opp.account_id);   // 客户可见才能操作
            if (companyAuth.CanView == false)
                return dto;

            var limitView = GetLimitValue(secLevelId, AuthLimitEnum.CRMSalesOrderView);
            var limitEdit = GetLimitValue(secLevelId, AuthLimitEnum.CRMSalesOrderEdit);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMSalesOrderDelete);

            if (limitView == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanView = true;
            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanEdit = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanDelete = true;

            if (limitView == DicEnum.LIMIT_TYPE_VALUE.MINE962
                || limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962
                || limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)    // 查看、编辑和删除有权限为我的
            {
                if (so.owner_resource_id == userId)    // 是我的销售订单
                {
                    if (limitView == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanView = true;
                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanEdit = true;
                    if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanDelete = true;
                }
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对备注的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="noteId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserNoteAuth(long userId,long secLevelId,long noteId)
        {
            AuthDetailDto dto = new AuthDetailDto();
            var note = new com_activity_dal().FindById(noteId);
            if (note == null || note.account_id == null)
                return dto;

            //var companyAuth = GetUserCompanyAuth(userId, secLevelId, (long)note.account_id);   // 客户可见才能操作
            //if (companyAuth.CanView == false)
            //    return dto;

            dto.CanView = true;     // 客户可见备注就可见
            var limitEdit = GetLimitValue(secLevelId, AuthLimitEnum.CRMNotesEdit);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMNotesDelete);
            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanEdit = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanDelete = true;

            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962 || limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)    // 编辑和删除有权限为我的
            {
                if (note.resource_id == userId)    // 是我的
                {
                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanEdit = true;
                    if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanDelete = true;
                }
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对待办的查看、修改、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="todoId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserTodoAuth(long userId, long secLevelId, long todoId)
        {
            AuthDetailDto dto = new AuthDetailDto();
            var todo = new com_activity_dal().FindById(todoId);
            if (todo == null || todo.account_id == null)
                return dto;

            //var companyAuth = GetUserCompanyAuth(userId, secLevelId, (long)todo.account_id);   // 客户可见才能操作
            //if (companyAuth.CanView == false)
            //    return dto;

            dto.CanView = true;     // 客户可见备注就可见
            var limitEdit = GetLimitValue(secLevelId, AuthLimitEnum.CRMTodoEdit);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMTodoDelete);
            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanEdit = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanDelete = true;

            if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962 || limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)    // 编辑和删除有权限为我的
            {
                if (todo.resource_id == userId)    // 是我的
                {
                    if (limitEdit == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanEdit = true;
                    if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
                        dto.CanDelete = true;
                }
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对附件的查看、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="attId"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserAttAuth(long userId, long secLevelId, long attId)
        {
            AuthDetailDto dto = new AuthDetailDto();

            var limitView = GetLimitValue(secLevelId, AuthLimitEnum.CRMAttachmentView);
            var limitDel = GetLimitValue(secLevelId, AuthLimitEnum.CRMAttachmentDelete);
            if (limitView == DicEnum.LIMIT_TYPE_VALUE.NONE963)
                return dto;

            var att = new com_attachment_dal().FindById(attId);
            if (att == null || att.account_id == null)
                return dto;

            var companyAuth = GetUserCompanyAuth(userId, secLevelId, (long)att.account_id);   // 客户可见才能操作
            if (companyAuth.CanView == false)
                return dto;

            dto.CanView = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.ALL962)
                dto.CanDelete = true;
            if (limitDel == DicEnum.LIMIT_TYPE_VALUE.MINE962)
            {
                if (att.create_user_id == userId)
                    dto.CanDelete = true;
            }

            return dto;
        }

        /// <summary>
        /// 判断用户对项目的查看，编辑、删除权限
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="secLevelId"></param>
        /// <param name="project_id"></param>
        /// <returns></returns>
        public static AuthDetailDto GetUserProjectAuth(long userId, long secLevelId, long project_id)
        {
            AuthDetailDto dto = new AuthDetailDto();
            var project = new pro_project_dal().FindNoDeleteById(project_id);
            if (project == null)
            {
                return dto;
            }
            // 项目当中我的，（我在团队中，我是创建人，我是主负责人）
            // 项目中 查看/编辑/删除 权限相同，通用一个limit
            var limitView = DicEnum.LIMIT_TYPE_VALUE.NONE962;
            if (project.type_id == (int)DicEnum.PROJECT_TYPE.ACCOUNT_PROJECT || project.type_id == (int)DicEnum.PROJECT_TYPE.IN_PROJECT)
            {
                limitView = GetLimitValue(secLevelId, AuthLimitEnum.PROClientView);
            }
            else if (project.type_id == (int)DicEnum.PROJECT_TYPE.PROJECT_DAY)
            {
                limitView = GetLimitValue(secLevelId, AuthLimitEnum.PROProposalView);
            }
            else if (project.type_id == (int)DicEnum.PROJECT_TYPE.TEMP)
            {
                limitView = GetLimitValue(secLevelId, AuthLimitEnum.PROTemplatesView);
            }
            if (limitView == DicEnum.LIMIT_TYPE_VALUE.ALL962)
            {
                dto.CanDelete = true;
                dto.CanEdit = true;
                dto.CanView = true;
            }
            else if (limitView == DicEnum.LIMIT_TYPE_VALUE.MINE962)
            {
                string sql = $"select 1 from pro_project pp INNER JOIN crm_account acc on pp.account_id = acc.id where pp.delete_time = 0 and acc.delete_time = 0 and (exists(select 1 from pro_project_team where delete_time=0 and project_id=pp.id and resource_id={userId})or exists(select 1  from sys_resource_department where is_lead=1 and department_id=pp.department_id and resource_id={userId}) or acc.resource_id={userId}  or pp.owner_resource_id={userId}  or exists(select 1 from crm_opportunity where delete_time=0 and id=pp.opportunity_id and resource_id={userId})  or exists(select 1 from sys_workgroup_resouce x,sys_workgroup y,sys_workgroup_resouce z where x.workgroup_id=y.id and y.delete_time=0 and(FIND_IN_SET(x.resource_id, (select GROUP_CONCAT(resource_id) from pro_project_team where delete_time = 0 and project_id = pp.id)) > 0 or x.resource_id = pp.owner_resource_id) and y.id = z.workgroup_id and z.is_leader = 1 and z.resource_id = {userId})) and pp.id = {project_id}";
                if (!string.IsNullOrEmpty(dal.FindSignleBySql<string>(sql)))
                {
                    dto.CanDelete = true;
                    dto.CanEdit = true;
                    dto.CanView = true;
                }
            }

            return dto;
        }

        #endregion

        #region 新的权限
        private static List<AuthPermitDto> allPermitsDtoList;       // 所有的权限点信息集合
        private static Dictionary<long, AuthSecurityLevelDto> secLevelPermitDic;    // 所有权限等级的权限点信息字典

        /// <summary>
        /// 初始化权限等级对应的权限点
        /// </summary>
        public static void InitSecLevelPermit()
        {
            secLevelPermitDic = new Dictionary<long, AuthSecurityLevelDto>();
            allPermitsDtoList = new List<AuthPermitDto>();

            // 配置的所有的权限点信息
            var allPermits = new sys_permit_dal().FindAll();
            foreach (var pmt in allPermits)
            {
                AuthPermitDto permit = new AuthPermitDto
                {
                    permit = pmt,
                    url = GetAuthUrlList(pmt.url),
                };
                allPermitsDtoList.Add(permit);
            }

            // 权限等级
            var secLevelList = new sys_security_level_dal().GetSecLevelList();
            var dal = new sys_limit_permit_dal();
            foreach(var sec in secLevelList)
            {
                AuthSecurityLevelDto slDto = new AuthSecurityLevelDto();
                var available = new List<AuthPermitDto>();
                var unAvailable = new List<AuthPermitDto>();

                // 查询sys_security_level对应的所有sys_permit的id
                string sql = $"SELECT permit_id FROM sys_limit_permit WHERE limit_id IN (SELECT limit_id FROM sys_security_level_limit WHERE security_level_id={sec.id} AND limit_type_value_id NOT IN (973,976,978,989,1242))";
                var pmtIds = dal.FindListBySql<int>(sql);

                foreach(var pmt in allPermitsDtoList)
                {
                    if (pmtIds.Exists(_ => _ == pmt.permit.id))
                        available.Add(pmt);
                    else
                        unAvailable.Add(pmt);
                }
                slDto.availablePermitList = available;
                slDto.unAvailablePermitList = unAvailable;
                var limits = new sys_security_level_limit_dal().GetLimitsBySecLevelId(sec.id).ToDictionary(d => (AuthLimitEnum)d.limit_id, d => (DicEnum.LIMIT_TYPE_VALUE)d.limit_type_value_id);
                slDto.limitList = limits;
                secLevelPermitDic.Add(sec.id, slDto);
            }
        }

        /// <summary>
        /// 获取权限点的url信息
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        private static List<AuthUrlDto> GetAuthUrlList(string url)
        {
            if (string.IsNullOrEmpty(url))
                return null;

            List<AuthUrlDto> list = new List<AuthUrlDto>();
            var arr = url.Split(';');
            foreach(var u in arr)
            {
                list.Add(GetAuthUrl(u));
            }

            return list;
        }

        /// <summary>
        /// 格式化url分割参数等
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        private static AuthUrlDto GetAuthUrl(string url)
        {
            AuthUrlDto dto = new AuthUrlDto();
            int index = url.IndexOf('?');
            if (index == -1)
            {
                dto.url = url;
                dto.parms = null;
            }
            else
            {
                dto.url = url.Substring(0, index);
                dto.parms = new List<UrlPara>();
                var prms = url.Substring(index + 1).Split('&');
                for (int i = 0; i <= prms.Length - 1; ++i)
                {
                    UrlPara prm = new UrlPara();
                    prm.value = null;
                    int valueIndex = prms[i].IndexOf('=');
                    if (valueIndex == -1)
                        prm.name = prms[i];
                    else
                    {
                        prm.name = prms[i].Substring(0, valueIndex);
                        if (valueIndex < prms[i].Length - 1)
                            prm.value = prms[i].Substring(valueIndex + 1);
                    }
                    dto.parms.Add(prm);
                }
            }

            return dto;
        }

        /// <summary>
        /// 获取用户在指定搜索页的需要权限而没有权限的右键菜单
        /// </summary>
        /// <param name="levelId"></param>
        /// <param name="userPermit"></param>
        /// <param name="queryType"></param>
        /// <returns></returns>
        public static List<string> GetSearchContextMenu(long levelId, List<AuthPermitDto> userPermit, QueryType queryType)
        {
            List<string> menus = new List<string>();
            string sn = "SEARCH_" + queryType.ToString().ToUpper(); // 搜索页的sn

            AuthPermitDto permit = allPermitsDtoList.Find(_ => sn.Equals(_.permit.sn));
            if (permit == null)     // 该页不需要权限
                return menus;

            var list = secLevelPermitDic[levelId];
            permit = userPermit.Find(_ => sn.Equals(_.permit.sn));    // 搜索页权限点
            if (permit == null)
            {
                permit = list.availablePermitList.Find(_ => sn.Equals(_.permit.sn));
            }
            if (permit == null)     // 用户没有访问此搜索页的权限
                return null;

            List<string> ALLmenus = new List<string>();     // 该搜索页所有需要权限的右键菜单
            List<string> availableMenus = new List<string>();   // 用户可用的右键菜单
            IEnumerable<string> find = from pmt in allPermitsDtoList where pmt.permit.parent_id == permit.permit.id select pmt.permit.name;
            ALLmenus.AddRange(find);

            find = from pmt in userPermit where pmt.permit.parent_id == permit.permit.id select permit.permit.name;
            availableMenus.AddRange(find);
            find = from pmt in list.availablePermitList where pmt.permit.parent_id == permit.permit.id select pmt.permit.name;
            availableMenus.AddRange(find);

            foreach(var m in ALLmenus)
            {
                if (!availableMenus.Exists(_ => _.Equals(m)))
                    menus.Add(m);
            }

            return menus;
        }

        /// <summary>
        /// 判断用户在搜索页是否有新增按钮权限
        /// </summary>
        /// <param name="levelId"></param>
        /// <param name="userPermit"></param>
        /// <param name="queryType"></param>
        /// <returns></returns>
        public static bool CheckAddAuth(long levelId, List<AuthPermitDto> userPermit, QueryType queryType)
        {
            string sn = "SEARCH_" + queryType.ToString().ToUpper() + "_ADD";    // 新增按钮的sn

            AuthPermitDto permit = allPermitsDtoList.Find(_ => sn.Equals(_.permit.sn));
            if (permit == null)     // 该按钮不需要权限
                return true;

            return CheckAuth(levelId, userPermit, sn);
        }

        /// <summary>
        /// 获取每个用户单独配置的权限
        /// </summary>
        /// <param name="userId"></param>
        /// <returns></returns>
        public List<AuthPermitDto> GetUserPermit(long userId)
        {
            List<AuthPermitDto> permits = new List<AuthPermitDto>();
            string sql = $"SELECT can_edit_skills,required_to_submit_timesheets,allow_send_bulk_email,can_manage_kb_articles,outsource_security_role_type_id,edit_protected_data,view_protected_data,edit_unprotected_data,view_unprotected_data FROM sys_resource WHERE id={userId} AND delete_time=0";
            var user = new sys_resource_dal().FindSignleBySql<sys_resource>(sql);
            if (user == null)
                return permits;

            string limitids = "";
            if (user.can_edit_skills == 1)
                limitids += "2001,";
            if (user.required_to_submit_timesheets == 1)
                limitids += "2002,";
            if (user.allow_send_bulk_email == 1)
                limitids += "2003,";
            if (user.can_manage_kb_articles == 1)
                limitids += "2004,";
            if (user.outsource_security_role_type_id != (int)DicEnum.OUTSOURCE_SECURITY_ROLE_TYPE.NONE)
                limitids += "2005,";
            if (user.edit_protected_data == 1)
                limitids += "2006,";
            if (user.view_protected_data == 1)
                limitids += "2007,";
            if (user.edit_unprotected_data == 1)
                limitids += "2008,";
            if (user.view_unprotected_data == 1)
                limitids += "2009,";

            if (limitids.Equals(""))
                return permits;

            limitids = limitids.Remove(limitids.Length - 1, 1);

            sql = $"SELECT * FROM sys_permit WHERE id IN (SELECT permit_id FROM sys_limit_permit WHERE limit_id IN ({limitids}))";
            var userPermits = new sys_permit_dal().FindListBySql(sql);
            foreach(var pmt in userPermits)
            {
                AuthPermitDto permit = new AuthPermitDto
                {
                    permit = pmt,
                    url = GetAuthUrlList(pmt.url),
                };
                permits.Add(permit);
            }
            return permits;
        }

        /// <summary>
        /// 判断是否有对应权限
        /// </summary>
        /// <param name="levelId">用户的权限等级id</param>
        /// <param name="userPermit">用户单独的权限信息</param>
        /// <param name="sn">判断的权限点sn</param>
        /// <returns></returns>
        public static bool CheckAuth(long levelId, List<AuthPermitDto> userPermit, string sn)
        {
            AuthPermitDto permit = userPermit.Find(_ => sn.Equals(_.permit.sn));
            if (permit != null)
                return true;

            var list = secLevelPermitDic[levelId];
            permit = list.availablePermitList.Find(_ => sn.Equals(_.permit.sn));
            if (permit != null)
                return true;

            return false;
        }

        /// <summary>
        /// 判断是否有权限访问url
        /// </summary>
        /// <param name="levelId"></param>
        /// <param name="userPermit"></param>
        /// <param name="url"></param>
        /// <returns></returns>
        public static bool CheckUrlAuth(long levelId, List<AuthPermitDto> userPermit, string url)
        {
            /**** 权限等级中不可用权限点包含有userPermit权限点，验证顺序先验证userPermit，后验证权限等级中不可用权限点 ****/

            // 判断是否有完全匹配
            if (userPermit.Exists(_ => url.Equals(_.permit.url)))
                return true;
            AuthSecurityLevelDto secLevelPermit = secLevelPermitDic[levelId];
            if (secLevelPermit.availablePermitList.Exists(_ => url.Equals(_.permit.url)))
                return true;
            if (secLevelPermit.unAvailablePermitList.Exists(_ => url.Equals(_.permit.url)))
                return false;


            // 没有完全匹配项，拆解url验证
            AuthUrlDto requestUrl = GetAuthUrl(url);
            if (requestUrl.parms == null)    // 没有参数，且没有完全匹配到，说明不在不可用权限点列表中
                return true;

            // 从所有的权限点中找到匹配该url参数最多的
            AuthPermitDto mostSatifyPermit = null;
            AuthPermitDto permitTmp = null;
            int permitParamCnt = -1;
            foreach(var permit in allPermitsDtoList)
            {
                if (permit.url == null)
                    continue;
                foreach (var u in permit.url)
                {
                    if (CheckUrlSatifyPermit(requestUrl, u))
                    {
                        int paraCnt = 0;    // u的参数个数
                        if (u.parms!=null)
                        {
                            paraCnt = u.parms.Count;
                        }

                        if (paraCnt > permitParamCnt)
                        {
                            mostSatifyPermit = permit;
                            permitTmp = null;
                            permitParamCnt = paraCnt;
                        }
                        else if(paraCnt == permitParamCnt)
                        {
                            permitTmp = permit;
                        }
                    }
                }
            }
            if (permitTmp != null)  // 匹配到最多的个数有多个
                new EMT.DoneNOW.BLL.ErrorLogBLL().AddLog(0, url, "URL匹配异常警告", "");

            if (mostSatifyPermit == null)   // 该url不做权限限制
                return true;

            if (userPermit.Exists(_ => _.permit.id == mostSatifyPermit.permit.id))
                return true;
            if (secLevelPermit.unAvailablePermitList.Exists(_ => _.permit.id == mostSatifyPermit.permit.id))
                return false;

            return true;
        }

        /// <summary>
        /// 判断请求url是否符合条件url的设定
        /// </summary>
        /// <param name="url"></param>
        /// <param name="permit"></param>
        /// <returns></returns>
        private static bool CheckUrlSatifyPermit(AuthUrlDto requestUrl, AuthUrlDto conditionUrl)
        {
            if (!requestUrl.url.Equals(conditionUrl.url))    // url不相等
                return false;

            if (conditionUrl.parms == null)
                return true;

            bool haveNotSatifyParam = false;    // 是否查找到有不满足设定的参数
            foreach (var p in conditionUrl.parms)     // 验证url参数中是否包含条件url所有的参数
            {
                if (string.IsNullOrEmpty(p.value))
                {
                    if (!requestUrl.parms.Exists(_ => _.name.Equals(p.name)))
                    {
                        haveNotSatifyParam = true;
                        break;
                    }
                }
                else
                {
                    if (!requestUrl.parms.Exists(_ => _.name.Equals(p.name) && p.value.Equals(_.value)))
                    {
                        haveNotSatifyParam = true;
                        break;
                    }
                }
            }
            return !haveNotSatifyParam;
        }

        /// <summary>
        /// 获取安全等级的一个limit值
        /// </summary>
        /// <param name="levelId"></param>
        /// <param name="limit"></param>
        /// <returns></returns>
        public static DicEnum.LIMIT_TYPE_VALUE GetLimitValue(long levelId, AuthLimitEnum limit)
        {
            return secLevelPermitDic[levelId].limitList[limit];
        }
        #endregion

        #region 权限
        /// <summary>
        /// 获取指定用户指定权限点的权限值
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="levelId"></param>
        /// <param name="limit"></param>
        /// <returns></returns>
        public static DicEnum.LIMIT_TYPE_VALUE GetLimitValue(long userId, long levelId, AuthLimitEnum limit)
        {
            var dto = securityLevels.FirstOrDefault(l => l.id == levelId);

            return dto.limit[limit];
        }

        /// <summary>
        /// 获取用户可访问的模块列表
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="levelId"></param>
        /// <returns></returns>
        public static List<ModuleEnum> GetModuleList(long userId, long levelId)
        {
            var dto = GetSecLevelInfo(levelId);
            if (dto == null)
                return new List<ModuleEnum>();

            return dto.modules;
        }

        /// <summary>
        /// 判断用户在对应权限点对应操作对象是否有权限，限权限点取值类型962(全部我的无)
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="levelId">用户权限等级</param>
        /// <param name="limit">需要验证的权限点</param>
        /// <param name="objType">操作对象类型</param>
        /// <param name="objId">操作对象id</param>
        /// <returns></returns>
        public static bool CheckAuth(long userId, long levelId, AuthLimitEnum limit, ObjectEnum objType, long objId)
        {
            var dto = GetSecLevelInfo(levelId);
            if (dto == null)
                throw new Exception("安全等级错误");
            
            if (secLevelLimits.First(l => l.id == (int)limit).type_id == (int)DicEnum.LIMIT_TYPE.ALL_MINE_NONE)
                return CheckAuthAllMyNone(userId, levelId, limit, objType, objId);
            else
                throw new Exception("安全等级错误");
        }

        /// <summary>
        /// 判断用户在对应权限点是否有权限，限权限点取值类型960(有无)或者963(全部无)
        /// </summary>
        /// <param name="userId">用户id</param>
        /// <param name="levelId">用户权限等级</param>
        /// <param name="limit">需要验证的权限点</param>
        /// <returns></returns>
        public static bool CheckAuth(long userId, long levelId, AuthLimitEnum limit)
        {
            var dto = GetSecLevelInfo(levelId);
            if (dto == null)
                throw new Exception("安全等级错误");

            // 权限取值类型是否为960或963
            var secLimit = secLevelLimits.First(l => l.id == (int)limit);
            if (secLimit.type_id != (int)DicEnum.LIMIT_TYPE.HAVE_NONE
                && secLimit.type_id != (int)DicEnum.LIMIT_TYPE.ALL_NONE)
                throw new Exception("安全等级错误");

            if (secLimit.type_id == (int)DicEnum.LIMIT_TYPE.HAVE_NONE
                && dto.limit[limit] == DicEnum.LIMIT_TYPE_VALUE.HAVE960)
                return true;
            if (secLimit.type_id == (int)DicEnum.LIMIT_TYPE.ALL_NONE
                && dto.limit[limit] == DicEnum.LIMIT_TYPE_VALUE.ALL963)
                return true;

            return false;
        }

        /// <summary>
        /// 判断是否有权限查看客户(对应权限点类型961)
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="levelId">安全等级</param>
        /// <param name="accountId">客户id</param>
        /// <returns></returns>
        public static bool CheckAuth(long userId, long levelId, long accountId)
        {
            var company = new CompanyBLL().GetCompany(accountId);
            if (company == null)
                throw new Exception("参数错误");

            var dto = GetSecLevelInfo(levelId);
            if (dto == null)
                throw new Exception("安全等级错误");

            // 客户类型为合作伙伴或者厂商
            if (company.type_id == (int)DicEnum.ACCOUNT_TYPE.COOPERATIVE_PARTNER
                || company.type_id == (int)DicEnum.ACCOUNT_TYPE.MANUFACTURER)
            {
                if (dto.limit[AuthLimitEnum.CRMCompanyViewVerdor] == DicEnum.LIMIT_TYPE_VALUE.ALL963) // 员工权限可查看所有
                    return true;
                else
                    return false;
            }

            // 其他客户类型
            AuthLimitEnum needLimit;
            if (company.type_id == (int)DicEnum.ACCOUNT_TYPE.CUSTOMER
                || company.type_id == (int)DicEnum.ACCOUNT_TYPE.CANCELLATION_OF_CUSTOMER)
            {
                needLimit = AuthLimitEnum.CRMCompanyViewCustomer;
            }
            else
            {
                needLimit = AuthLimitEnum.CRMCompanyViewProspect;
            }

            if (dto.limit[needLimit] == DicEnum.LIMIT_TYPE_VALUE.ALL961) // 员工权限可查看所有
            {
                return true;
            }
            else if (dto.limit[needLimit] == DicEnum.LIMIT_TYPE_VALUE.NONE961)   // 员工权限不可查看
            {
                return false;
            }
            else if (dto.limit[needLimit] == DicEnum.LIMIT_TYPE_VALUE.MINE961)   // 员工权限可查看仅自己的客户
            {
                if (company.resource_id == userId)
                    return true;
                else
                    return false;
            }
            else    // 员工权限可查看自己的地域
            {
                var userTerritories = new TerritoryBLL().GetTerritoryByResource(userId);
                if (company.territory_id == null || userTerritories == null || userTerritories.Count == 0)
                    return false;

                if (userTerritories.Exists(t => t.territory_id == company.territory_id))
                    return true;
                else
                    return false;
            }
        }

        /// <summary>
        /// 从缓存中返回指定id的安全等级
        /// </summary>
        /// <param name="secLevelId"></param>
        /// <returns></returns>
        public static SecurityLevelDto GetSecLevelInfo(long secLevelId)
        {
            return securityLevels.FirstOrDefault(l => l.id == secLevelId);
        }

        /// <summary>
        /// 加载所有可用的安全等级信息
        /// </summary>
        public static void InitSecurityLevels()
        {
            var list = dal.GetSecLevelList();
            securityLevels = new List<SecurityLevelDto>();

            foreach(var sec in list)
            {
                securityLevels.Add(GetSecLevelInfoFromDB(sec.id));
            }

            secLevelLimits = new sys_limit_dal().FindAll().ToList();
        }

        /// <summary>
        /// 获取一个安全等级的信息
        /// </summary>
        /// <param name="secLevelId"></param>
        /// <returns></returns>
        private static SecurityLevelDto GetSecLevelInfoFromDB(long secLevelId)
        {
            var secLevel = dal.FindById(secLevelId);
            var limits = new sys_security_level_limit_dal().GetLimitsBySecLevelId(secLevelId).ToDictionary(d => (AuthLimitEnum)d.limit_id, d => (DicEnum.LIMIT_TYPE_VALUE)d.limit_type_value_id);
            var modules = new sys_security_level_module_dal().GetModulesBySecLevelId(secLevelId).Select(m => (ModuleEnum)m.module_id).ToList();

            SecurityLevelDto dto = new SecurityLevelDto
            {
                id = secLevelId,
                isSystem = secLevel.is_system,
                name = secLevel.name,
                description = secLevel.description,
                limit = limits,
                modules = modules,
            };

            return dto;
        }

        /// <summary>
        /// 判断是否有权限，限权限点取值类型962
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="levelId"></param>
        /// <param name="limit"></param>
        /// <param name="objType"></param>
        /// <param name="objId"></param>
        /// <returns></returns>
        private static bool CheckAuthAllMyNone(long userId, long levelId, AuthLimitEnum limit, ObjectEnum objType, long objId)
        {
            return true;
        }

        private static sys_security_level_dal dal = new sys_security_level_dal();

        private static List<SecurityLevelDto> securityLevels = null;   // 所有权限等级信息
        private static List<sys_limit> secLevelLimits = null;    // 所有权限点信息
        #endregion
        
        #region Token鉴权
        private readonly sys_user_dal _dal = new sys_user_dal();
        private const int expire_time_mins = 60 * 6;                // token过期时间分钟(6小时)
        private const int expire_time_mins_refresh = 60 * 16;       // refreshtoken过期时间分钟(16小时)
        private const int expire_time_secs= 60 * expire_time_mins;                  // token过期时间秒
        private const int expire_time_secs_refresh = 60 * expire_time_mins_refresh;     // refreshtoken过期时间秒
        private const string secretKey = "GQDstcKsx0NHjPOuXOYg5MbeJ1XT0uFiwDVvVBrk";

        /// <summary>
        /// 生成token，创建缓存
        /// </summary>
        /// <param name="loginName">登录名，邮箱或手机号</param>
        /// <param name="password">登录密码</param>
        /// <param name="tokenDto"></param>
        /// <returns></returns>
        public ERROR_CODE Login(string loginName, string password, string userAgent,string ip, out TokenDto tokenDto)
        {
            tokenDto = null;
            StringBuilder where = new StringBuilder();
            string loginType = "";
            if (new RegexOp().IsEmail(loginName))
            {
                where.Append($" email='{loginName}' ");
                loginType = "email";
            }
            else if (new RegexOp().IsMobilePhone(loginName))
            {
                where.Append($" mobile_phone='{loginName}' ");
                loginType = "mobile_phone";
            }
            else
            {
                return ERROR_CODE.PARAMS_ERROR;
            }

            List<sys_user> user = _dal.FindListBySql($"SELECT * FROM sys_user WHERE {where.ToString()}");
            if (user.Count < 1)
                return ERROR_CODE.USER_NOT_FIND;
            if (!new Cryptographys().SHA1Encrypt(password).Equals(user[0].password))
            {
                // TODO: 输入错误密码处理
                return ERROR_CODE.PASSWORD_ERROR;
            }

           


            // TODO: user status判断
            
            
            // 根据user表信息进入租户数据库获取详细信息，以判断用户状态
            sys_resource resource = new sys_resource_dal().FindById(user[0].id);
            if (resource.is_locked == 1)
                return ERROR_CODE.LOCK;
            if (resource.is_active == 0)
                return ERROR_CODE.LOCK;
            // TODO: 更多校验及处理
            
            var start = Math.Round((DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
            var exp = (long)(start + expire_time_secs);
            var random = new Random();
            TokenStructDto payload = new TokenStructDto
            {
                uid = resource.id,
                timestamp = (long)start,
                expire = exp,
                rand = random.Next(int.MaxValue)
            };    // 获取token
            var refreshexp = (long)(start + expire_time_secs_refresh);
            TokenStructDto refreshPayload = new TokenStructDto
            {
                uid = resource.id,
                timestamp = (long)start,
                expire = refreshexp,
                rand = random.Next(int.MaxValue)
            };   // 获取refreshtoken

            //JwtEncoder encoder = new JwtEncoder(new JWT.Algorithms.HMACSHA512Algorithm(), new JWT.Serializers.JsonNetSerializer(), new JwtBase64UrlEncoder());
            string token = EncodeToken(payload);
            string refreshToken = EncodeToken(refreshPayload);

            UserInfoDto userinfo = new UserInfoDto();
            userinfo.id = resource.id;
            userinfo.email = resource.email;
            userinfo.mobile = resource.mobile_phone;
            userinfo.name = resource.name;
            userinfo.security_Level_id = (int)resource.security_level_id;
            CachedInfoBLL.SetUserInfo(token, userinfo, expire_time_mins);
            CachedInfoBLL.SetToken(refreshToken, token, expire_time_mins_refresh);
            CachedInfoBLL.SetUserPermit(token + "_permit", new AuthBLL().GetUserPermit(resource.id), expire_time_mins);

            tokenDto = new TokenDto
            {
                token = token,
                refresh = refreshToken
            };


            #region 插入日志
            //1.判断token中用户数量
            if (_dal.IsBeyond(user[0].id))  //未超过登陆限制
            {
                sys_login_log login_log = new sys_login_log {
                    agent =userAgent,id= Convert.ToInt64(_dal.GetNextIdSys()),
                    ip =ip,login_time= DateTime.Now,name="",user_id=user[0].id};
                if (loginType.Equals("email"))
                {
                    login_log.email = loginName;
                }
                else if (loginType.Equals("mobile_phone"))
                {
                    login_log.mobile_phone = loginName; 
                }
                new sys_login_log_dal().Insert(login_log); //向sys_login_log表中插入日志

                sys_token token_log = new sys_token() {
                    expire_time = DateTime.Now.AddMinutes(expire_time_mins),
                    id = Convert.ToInt64(_dal.GetNextIdSys()),
                    user_id =user[0].id,
                      port=1,//端口1web 2APP 目前只有web，赋默认值1
                    //  product=user[0].cate_id,
                    token = token,
                    refresh_token=refreshToken
                };
                new sys_token_dal().Insert(token_log); //向sys_token表中插入日志

            }
            else  //超出登陆限制，返回登陆数量超出
            {
                return ERROR_CODE.USER_LIMITCOUNT;
            }




            #endregion

            return ERROR_CODE.SUCCESS;
        }

        /// <summary>
        /// 根据token获取用户信息
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        public static UserInfoDto GetLoginUserInfo(string token)
        {
            return CachedInfoBLL.GetUserInfo(token);
        }

        public static List<AuthPermitDto> GetLoginUserPermit(string token)
        {
            return CachedInfoBLL.GetUserPermit(token + "_permit");
        }
        
        /// <summary>
        /// 生成token
        /// </summary>
        /// <param name="refreshToken"></param>
        /// <param name="tokenDto"></param>
        /// <returns></returns>
        public bool RefreshToken(string refreshToken, out TokenDto tokenDto)
        {
            tokenDto = null;
            string token = CachedInfoBLL.GetToken(refreshToken);
            if (string.IsNullOrEmpty(token))
                return false;
            UserInfoDto info = CachedInfoBLL.GetUserInfo(token);
            if (info != null) // token未过期
            {
                tokenDto = new TokenDto
                {
                    token = token,
                    refresh = refreshToken
                };
                return true;
            }
            else  // token过期，refreshtoken未过期，重新生成
            {
                var tokeninfo = DecodeToken(refreshToken);
                if (tokeninfo == null)
                    return false;

                var start = Math.Round((DateTime.UtcNow - new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc)).TotalSeconds);
                var random = new Random();
                TokenStructDto newTokenInfo = new TokenStructDto
                {
                    uid = tokeninfo.uid,
                    timestamp = (long)start,
                    expire = (long)(start + expire_time_secs),
                    rand = random.Next(int.MaxValue)
                };
                TokenStructDto newRefreshTokenInfo = new TokenStructDto
                {
                    uid = tokeninfo.uid,
                    timestamp = (long)start,
                    expire = (long)(start + expire_time_secs_refresh),
                    rand = random.Next(int.MaxValue)
                };
                string newToken = EncodeToken(newTokenInfo);
                string newRefreshToken = EncodeToken(newRefreshTokenInfo);

                UserInfoDto userinfo = new UserInfoDto();
                userinfo.id = tokeninfo.uid;
                CachedInfoBLL.SetUserInfo(newToken, userinfo, expire_time_mins);
                CachedInfoBLL.SetToken(newRefreshToken, newToken, expire_time_mins_refresh);

                tokenDto = new TokenDto
                {
                    token = token,
                    refresh = refreshToken
                };
                return true;
            }
        }

        private string EncodeToken(TokenStructDto token)
        {
            JwtEncoder encoder = new JwtEncoder(new JWT.Algorithms.HMACSHA256Algorithm(), new JWT.Serializers.JsonNetSerializer(), new JwtBase64UrlEncoder());
            return encoder.Encode(token, secretKey);
        }

        private TokenStructDto DecodeToken(string token)
        {
            var jser = new JWT.Serializers.JsonNetSerializer();
            JwtDecoder decoder = new JwtDecoder(jser, new JWT.JwtValidator(jser, new JWT.UtcDateTimeProvider()), new JwtBase64UrlEncoder());
            return decoder.DecodeToObject<TokenStructDto>(token, secretKey, true);
        }
        #endregion
    }
}
