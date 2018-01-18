using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using Newtonsoft.Json.Linq;
using static EMT.DoneNOW.DTO.DicEnum;

namespace EMT.DoneNOW.BLL
{
    public class ExpenseBLL
    {
        private sdk_expense_report_dal _dal = new sdk_expense_report_dal();
        /// <summary>
        /// 费用报表 管理（新增，编辑）
        /// </summary>
        public bool ReportManage(sdk_expense_report report,long userId,bool isCopy=false,long copyId=0)
        {
            try
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                report.update_user_id = userId;
                report.update_time = timeNow;
                if (report.id == 0)
                {
                    report.id = _dal.GetNextIdCom();
                    report.create_time = timeNow;
                    report.create_user_id = userId;
                    report.submit_user_id = userId;
                    report.submit_time = report.create_time;
                    _dal.Insert(report);
                    OperLogBLL.OperLogAdd<sdk_expense_report>(report, report.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "新增费用报表");
                    // 代表是复制操作
                    if (isCopy&& copyId!=0)
                    {
                        var seDal = new sdk_expense_dal();
                        // 复制时，将原有的费用复制，已经审批提交的只复制相关信息，审批状态不复制
                        var thisExpList = seDal.GetExpByReport(copyId);
                        if (thisExpList != null && thisExpList.Count > 0)
                        {
                            thisExpList.ForEach(_ => {
                                _.id = seDal.GetNextIdCom();
                                _.oid = 0;
                                _.expense_report_id = report.id;
                                _.create_time = timeNow;
                                _.update_time = timeNow;
                                _.create_user_id = userId;
                                _.update_user_id = userId;
                                _.approve_and_post_date = null;
                                _.approve_and_post_user_id = null;
                                seDal.Insert(_);
                                OperLogBLL.OperLogAdd<sdk_expense>(_, _.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE, "新增费用");
                            });
                        }
                    }
                }
                else
                {
                    var oldReport = _dal.FindNoDeleteById(report.id);
                    if (oldReport != null)
                    {
                        _dal.Update(report);
                        OperLogBLL.OperLogUpdate<sdk_expense_report>(report,oldReport, report.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");
                    }
                }
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }

        /// <summary>
        /// 删除费用报表
        /// </summary>
        public bool DeleteReport(long rId,long userId,out string reason)
        {
            reason = "";
            try
            {
                var thisReport = _dal.FindNoDeleteById(rId);
                if (thisReport != null)
                {
                    if(thisReport.status_id==(int)DTO.DicEnum.EXPENSE_REPORT_STATUS.PAYMENT_BEEN_APPROVED|| thisReport.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.ALREADY_PAID)
                    {
                        reason = "费用报表已审批通过，不能删除。请审批人员先拒绝";
                        return false;
                    }
                    else
                    {
                        var teprDal = new tst_expense_report_log_dal();
                        var logList = teprDal.GetListByReportId(thisReport.id);

                       

                        _dal.SoftDelete(thisReport,userId);
                        OperLogBLL.OperLogDelete<sdk_expense_report>(thisReport, thisReport.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "删除费用报表");

                        if (logList != null && logList.Count > 0)
                        {
                            logList.ForEach(_ => {
                                teprDal.SoftDelete(_,userId);
                            });
                        }
                    }
                    
                }
                else
                {
                    reason = "费用已经删除";
                    return false;
                }

                // GetListByReportId
            }
            catch (Exception)
            {
                return false;
            }
            return true;
        }
        /// <summary>
        /// 审批通过-费用
        /// </summary>
        public bool Approval(long eid, long user_id, out string failReason, string notiIds = "")
        {
            failReason = "";
            var thisExp = _dal.FindNoDeleteById(eid);
            if (thisExp != null && thisExp.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.WAITING_FOR_APPROVAL)
            {
                var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                #region 审批 插入工时表日志
                var expLog = new tst_expense_report_log()
                {
                    id = _dal.GetNextIdCom(),
                    expense_report_id = thisExp.id,
                    oper_user_id = user_id,
                    oper_time = timeNow,
                    oper_type_id = (int)DTO.DicEnum.EXPENSE_RECORD_OPER.APPROVAL_PASS,
                };
                new tst_expense_report_log_dal().Insert(expLog);
                // 日志表无需再存储日志
                #endregion

                var oldExp = _dal.FindNoDeleteById(eid);
                thisExp.status_id = (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.PAYMENT_BEEN_APPROVED;
                thisExp.update_time = timeNow;
                thisExp.update_user_id = user_id;
                if (_dal.Update(thisExp))
                {
                    OperLogBLL.OperLogUpdate<sdk_expense_report>(thisExp, oldExp, thisExp.id, user_id, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");
                    #region 发送邮件相关 
                    var srDal = new sys_resource_dal();
                    var thisRes = srDal.FindNoDeleteById(user_id);
                    var thisCreate = srDal.FindNoDeleteById(thisExp.create_user_id);
                    if (thisRes != null&& thisCreate!=null)
                    {
                        var toEmail = thisCreate.email;
                        if (!string.IsNullOrEmpty(notiIds))
                        {
                            var notiArr = notiIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            foreach (var notiID in notiArr)
                            {
                                var notiRes = srDal.FindNoDeleteById(long.Parse(notiID));
                                if (notiRes != null)
                                {
                                    toEmail += notiRes.email+ ";";
                                }
                            }
                        }
                     
                        var notify = new com_notify_email()
                        {
                            id = _dal.GetNextIdCom(),
                            cate_id = (int)NOTIFY_CATE.TIME_SHEET,
                            from_email = thisRes.email,
                            from_email_name = thisRes.name,
                            subject = $"费用报表被{thisRes.name}审批通过",
                            body_text = $"员工姓名的费用报表被审批通过\r名称：{thisExp.title}\r费用总额：{(thisExp.amount??0).ToString("#0.00")}\r",
                            to_email = toEmail,
                            create_user_id = user_id,
                            update_user_id = user_id,
                            create_time = timeNow,
                            update_time = timeNow,
                        };
                        notify.is_success =  (sbyte)(new ProjectBLL().SendEmail(notify)?1:0);
                        new com_notify_email_dal().Insert(notify);
                        OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, user_id, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知信息");
                    }
                    #endregion

                    return true;
                }

            }
            else
            {
                if(thisExp == null)
                {
                    failReason = "未查询到审批的费用报表";
                } 
                else
                {
                    failReason = thisExp.title+ "费用报表的状态必须是待审批。";
                }
            }
            return false;
        }
        /// <summary>
        /// 审批拒绝-费用 
        /// </summary>
        /// <returns></returns>
        public bool ApprovalRefuse(long eid, string reason, long userId,out string failReason, string notiIds = "",string refIds="", bool isRecord = false)
        {
            failReason = "";
            try
            {
                var thisReport = _dal.FindNoDeleteById(eid);
                if (thisReport != null&& thisReport.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.WAITING_FOR_APPROVAL)
                {
                    var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

                    #region 审批 插入工时表日志
                    var expLog = new tst_expense_report_log()
                    {
                        id = _dal.GetNextIdCom(),
                        expense_report_id = thisReport.id,
                        oper_user_id = userId,
                        oper_time = timeNow,
                        oper_type_id = (int)DTO.DicEnum.EXPENSE_RECORD_OPER.APPROVAL_REFUSE,
                        description = reason
                    };
                    if (isRecord&&!string.IsNullOrEmpty(refIds))
                    {
                        expLog.rejection_expense_id_list = refIds;
                    }
                    new tst_expense_report_log_dal().Insert(expLog);
                    // 日志表无需再存储日志
                    #endregion

                    var oldExp = _dal.FindNoDeleteById(eid);
                    thisReport.status_id = (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.REJECTED;
                    thisReport.update_time = timeNow;
                    thisReport.update_user_id = userId;
                    thisReport.rejection_reason = reason;
                    if (isRecord && !string.IsNullOrEmpty(refIds))
                    {
                        var oldExpIds = thisReport.rejection_expense_id_list;
                        if (!string.IsNullOrEmpty(oldExpIds))
                        {
                            var oldIdArr = oldExpIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                            var newArr = refIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                            var result = oldIdArr.Union(newArr).ToArray() ;
                            string ids = "";
                            foreach (var thisId in result)
                            {
                                ids += thisId + ",";
                            }
                            if (ids != "")
                            {
                                ids = ids.Substring(0, ids.Length-1);
                                thisReport.rejection_expense_id_list = ids;
                            }
                        }
                        else
                        {
                            thisReport.rejection_expense_id_list = refIds;
                        }
                    }
                    if (_dal.Update(thisReport))
                    {
                        OperLogBLL.OperLogUpdate<sdk_expense_report>(thisReport, oldExp, thisReport.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");

                        #region 发送邮件相关 
                        var srDal = new sys_resource_dal();
                        var thisRes = srDal.FindNoDeleteById(userId);
                        var thisCreate = srDal.FindNoDeleteById(thisReport.create_user_id);
                        if (thisRes != null&& thisCreate!=null)
                        {
                            var toEmail = thisCreate.email;
                            if (!string.IsNullOrEmpty(notiIds))
                            {
                                var notiArr = notiIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                                foreach (var notiID in notiArr)
                                {
                                    var notiRes = srDal.FindNoDeleteById(long.Parse(notiID));
                                    if (notiRes != null)
                                    {
                                        toEmail += notiRes.email + ";";
                                    }
                                }
                            }
                            var notify = new com_notify_email()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)NOTIFY_CATE.TIME_SHEET,
                                from_email = thisRes.email,
                                from_email_name = thisRes.name,
                                to_email = toEmail,
                                subject = $"费用报表被{thisRes.name}审批时被拒绝",
                                body_text = $"员工姓名的费用报表被审批通过\r名称：{thisReport.title}\r费用总额：{(thisReport.amount ?? 0).ToString("#0.00")}\r说明：{reason}",
                                create_user_id = userId,
                                update_user_id = userId,
                                create_time = timeNow,
                                update_time = timeNow,
                            };
                            notify.is_success = (sbyte)(new ProjectBLL().SendEmail(notify) ? 1 : 0);
                            new com_notify_email_dal().Insert(notify);
                            OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, userId, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知信息");
                        }
                        #endregion
                    }
                }
                else
                {
                    if (thisReport == null)
                    {
                        failReason = "未查询到拒绝的费用报表";
                    }
                    else
                    {
                        failReason = "费用报表的状态必须是待审批";
                    }
                    return false;
                }
            }
            catch (Exception e)
            {
                failReason = e.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 提交费用报表
        /// </summary>
        public bool SubmitReport(long eid,long userId,ref string faileReason)
        {
            try
            {
                var thisReport = _dal.FindNoDeleteById(eid);
                if (thisReport != null)
                {
                    if (thisReport.status_id == (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.HAVE_IN_HAND)
                    {
                        var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);
                        #region 修改费用报表状态
                        var oldRep = _dal.FindNoDeleteById(eid);
                        thisReport.submit_time = timeNow;
                        thisReport.submit_user_id = userId;
                        thisReport.update_time = timeNow;
                        thisReport.update_user_id = userId;
                        thisReport.status_id = (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.WAITING_FOR_APPROVAL;
                        _dal.Update(thisReport);
                        OperLogBLL.OperLogUpdate<sdk_expense_report>(thisReport, oldRep, thisReport.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");
                        #endregion

                        #region 记录操作日志
                        var expLog = new tst_expense_report_log()
                        {
                            id = _dal.GetNextIdCom(),
                            expense_report_id = thisReport.id,
                            oper_user_id = userId,
                            oper_time = timeNow,
                            oper_type_id = (int)DTO.DicEnum.EXPENSE_RECORD_OPER.SUBMIT,
                        };
                        new tst_expense_report_log_dal().Insert(expLog);
                        #endregion

                        #region 发送邮件相关 
                        var srDal = new sys_resource_dal();
                        var thisRes = srDal.FindNoDeleteById(userId);
                        var thisCreate = srDal.FindNoDeleteById(thisReport.create_user_id);
                        if (thisRes != null && thisCreate != null)
                        {
                            var toEmail = thisCreate.email;
                            var ensDateString = thisReport.end_date != null ? ((DateTime)thisReport.end_date).ToString("yyyy-MM-dd") : "";
                            var notify = new com_notify_email()
                            {
                                id = _dal.GetNextIdCom(),
                                cate_id = (int)NOTIFY_CATE.TIME_SHEET,
                                from_email = thisRes.email,
                                from_email_name = thisRes.name,
                                subject = $"{thisCreate.name}费用报表(周期{ensDateString})需要审批",
                                body_text = $"我提交了费用报表（周期{ensDateString}），请审批",
                                to_email = toEmail,
                                create_user_id = userId,
                                update_user_id = userId,
                                create_time = timeNow,
                                update_time = timeNow,
                            };
                            notify.is_success = (sbyte)(new ProjectBLL().SendEmail(notify) ? 1 : 0);
                            new com_notify_email_dal().Insert(notify);
                            OperLogBLL.OperLogAdd<com_notify_email>(notify, notify.id, userId, OPER_LOG_OBJ_CATE.NOTIFY, "新增通知信息");
                        }
                        #endregion
                    }
                    else
                    {
                        faileReason = "只有进行中的报表报表才可以进行提交操作！";
                        return false;
                    }
                }
                else
                {
                    faileReason = "未找到相关费用报表";
                    return false;
                }
            }
            catch (Exception msg)
            {
                faileReason = msg.Message;
                return false;
            }
            return true;
        }
        /// <summary>
        /// 将报表标记为 已支付
        /// </summary>
        public bool PaidReport(long eid,long userId,out string faileReason)
        {
            faileReason = "";
            var thisExp = _dal.FindNoDeleteById(eid);
            if (thisExp == null)
            {
                faileReason = "未查询到该费用报表";
                return false;
            }
            if (thisExp.status_id != (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.PAYMENT_BEEN_APPROVED)
            {
                faileReason = thisExp.title+":状态不是已审批，不可以进行支付操作！";
                return false;
            }
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            #region 记录操作日志
            var expLog = new tst_expense_report_log()
            {
                id = _dal.GetNextIdCom(),
                expense_report_id = thisExp.id,
                oper_user_id = userId,
                oper_time = timeNow,
                oper_type_id = (int)DTO.DicEnum.EXPENSE_RECORD_OPER.PAYMENT,
            };
            new tst_expense_report_log_dal().Insert(expLog);
            #endregion


            #region 修改费用报表状态
            var oldExp = _dal.FindNoDeleteById(eid);
            thisExp.update_time = timeNow;
            thisExp.update_user_id = userId;
            thisExp.status_id = (int)EXPENSE_REPORT_STATUS.ALREADY_PAID;
            _dal.Update(thisExp);
            OperLogBLL.OperLogUpdate<sdk_expense_report>(thisExp, oldExp, thisExp.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");
            #endregion


            return true;
        }

        /// <summary>
        /// 将已经支付的费用报表返回为审批状态
        /// </summary>
        public bool ReturnApproval(long eid, long userId, out string faileReason)
        {
            faileReason = "";
            var thisExp = _dal.FindNoDeleteById(eid);
            if (thisExp == null)
            {
                faileReason = "未查询到该费用报表";
                return false;
            }
            if (thisExp.status_id != (int)DTO.DicEnum.EXPENSE_REPORT_STATUS.ALREADY_PAID)
            {
                faileReason = thisExp.title + ":状态不是已支付，不可以进行标记为已审批操作！";
                return false;
            }
            var timeNow = Tools.Date.DateHelper.ToUniversalTimeStamp(DateTime.Now);

            #region 记录操作日志
            var expLog = new tst_expense_report_log()
            {
                id = _dal.GetNextIdCom(),
                expense_report_id = thisExp.id,
                oper_user_id = userId,
                oper_time = timeNow,
                oper_type_id = (int)DTO.DicEnum.EXPENSE_RECORD_OPER.RETURN_APPROVAL,
            };
            new tst_expense_report_log_dal().Insert(expLog);
            #endregion


            #region 修改费用报表状态
            var oldExp = _dal.FindNoDeleteById(eid);
            thisExp.update_time = timeNow;
            thisExp.update_user_id = userId;
            thisExp.status_id = (int)EXPENSE_REPORT_STATUS.PAYMENT_BEEN_APPROVED;
            _dal.Update(thisExp);
            OperLogBLL.OperLogUpdate<sdk_expense_report>(thisExp, oldExp, thisExp.id, userId, OPER_LOG_OBJ_CATE.SDK_EXPENSE_REPORT, "修改费用报表");
            #endregion
            return true;
        }
    }
}
