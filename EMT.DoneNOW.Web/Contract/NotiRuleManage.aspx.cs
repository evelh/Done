using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class NotiRuleManage : BasePage
    {
        public ctt_contract_notify_rule thisRule = null;
        public bool isAdd = true;
        public ctt_contract thisContract = null;
        public string conTypeName = "";   // 合同类型的名称
        public List<sys_resource> thisRuleResList = null;
        public List<crm_contact> thisRuleConList = null;
        public List<sys_resource> otherRuleResList = null;
        public List<crm_contact> otherRuleConList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                // 预付时间合同、预付费合同、事件合同的详情主界面

                var contract_id = Request.QueryString["contract_id"];
                if (!string.IsNullOrEmpty(contract_id))
                {
                    thisContract = new ctt_contract_dal().FindNoDeleteById(long.Parse(contract_id));
                }

                var thisId = Request.QueryString["id"];
                var srDal = new sys_resource_dal();
                var ccDal = new crm_contact_dal();
                if (!string.IsNullOrEmpty(thisId))
                {
                    thisRule = new ctt_contract_notify_rule_dal().FindNoDeleteById(long.Parse(thisId));
                    if (thisRule != null)
                    {
                        isAdd = false;
                        thisContract = new ctt_contract_dal().FindNoDeleteById(thisRule.contract_id);
                        new ctt_contract_notify_rule_recipient_dal();
                        thisRuleResList = srDal.GetConRuleList(thisRule.id);
                        otherRuleResList = srDal.GetNotInConRuleList(thisRule.id);

                        thisRuleConList = ccDal.GetConRuleList(thisRule.id);
                        otherRuleConList = ccDal.GetNotInConRuleList(thisRule.id, thisContract.account_id);
                    }
                }
                else
                {
                    otherRuleResList = srDal.GetSourceList();
                    otherRuleConList = ccDal.GetContactByAccountId(thisContract.account_id);
                }

                if (thisContract == null)
                {
                    Response.Write("<script>window.close();</script>");
                    Response.End();
                }
                if(thisContract.type_id==(int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS|| thisContract.type_id == (int)DicEnum.CONTRACT_TYPE.RETAINER || thisContract.type_id == (int)DicEnum.CONTRACT_TYPE.PER_TICKET)
                {
                    // conTypeName
                    List<sys_notify_tmpl> thisTemp = null;
                    var sntDal = new sys_notify_tmpl_dal();
                    if (thisContract.type_id == (int)DicEnum.CONTRACT_TYPE.BLOCK_HOURS){
                        conTypeName = "预付时间";
                        thisTemp = sntDal.GetTempByEvent(DicEnum.NOTIFY_EVENT.BLOCK_CONTRACT_RULE);
                    }
                    else if (thisContract.type_id == (int)DicEnum.CONTRACT_TYPE.RETAINER)
                    {
                        conTypeName = "预付费";
                        thisTemp = sntDal.GetTempByEvent(DicEnum.NOTIFY_EVENT.RETAINER_CONTRACT_RULE);
                    }
                    else
                    {
                        conTypeName = "事件";
                        thisTemp = sntDal.GetTempByEvent(DicEnum.NOTIFY_EVENT.PER_CONTRACT_RULE);
                    }
                    notify_tmpl_id.DataTextField = "name";
                    notify_tmpl_id.DataValueField = "id";
                    notify_tmpl_id.DataSource = thisTemp;
                    notify_tmpl_id.DataBind();
                    if (thisRule != null)
                    {
                        notify_tmpl_id.SelectedValue = thisRule.notify_tmpl_id.ToString();
                    }

                }
                else
                {
                    Response.Write("<script>alert('该合同类型暂不能添加通知规则');window.close();</script>");
                    Response.End();
                }
            }
            catch (Exception)
            {
                Response.End();
            }
           
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            // RuleRes  RuleCon
            string perIds = "";
            var RuleRes = Request.Form["RuleRes"];
            var RuleCon = Request.Form["RuleCon"];
            if (!string.IsNullOrEmpty(RuleRes))
            {
                perIds += RuleRes;
            }
            if (!string.IsNullOrEmpty(RuleCon))
            {
                if (!string.IsNullOrEmpty(perIds))
                {
                    perIds += ","+ RuleCon;
                }
                else
                {
                    perIds += RuleCon;
                }
            }
            var param = GetParam();
            bool result = false;
            if (isAdd)
            {
                result = new ContractBLL().AddContractRule(param,perIds,LoginUserId);
            }
            else
            {
                result = new ContractBLL().EditContractRule(param, perIds, LoginUserId);
            }
            if (result)
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
            }
            else
            {

                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close();self.opener.location.reload();</script>");
            }
        }

        private ctt_contract_notify_rule GetParam()
        {
            var pageRule = AssembleModel<ctt_contract_notify_rule>();
            pageRule.contract_id = thisContract.id;
            if (isAdd)
            {
            
            }
            else
            {
                pageRule.id = thisRule.id;
                pageRule.oid = thisRule.oid;
                pageRule.create_time = thisRule.create_time;
                pageRule.create_user_id = thisRule.create_user_id;
                pageRule.delete_time = thisRule.delete_time;
                pageRule.delete_user_id = thisRule.delete_user_id;
            }
            return pageRule;
        }

    }
}