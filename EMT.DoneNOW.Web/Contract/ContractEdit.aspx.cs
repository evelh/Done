using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractEdit : BasePage
    {
        protected List<DictionaryEntryDto> contractCate;    // 合同种类
        protected List<DictionaryEntryDto> periodType;      // 计费周期类型
        protected List<DictionaryEntryDto> billPostType;    // 工时计费设置
        protected List<d_sla> slaList;      // SLA列表
        protected ContractEditDto contract;     // 编辑的合同对象
        protected string contractTypeName;      // 合同类型名称
        protected List<UserDefinedFieldDto> udfList;        // 自定义字段信息
        private ContractBLL bll = new ContractBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            var contract_id = Convert.ToInt64(Request.QueryString["id"]);
            contract = bll.GetContractEdit(contract_id);

            Dictionary<string, object> dics = bll.GetField();
            contractCate = dics["cate"] as List<DictionaryEntryDto>;
            periodType = dics["periodType"] as List<DictionaryEntryDto>;
            billPostType = dics["billPostType"] as List<DictionaryEntryDto>;
            contractTypeName = bll.GetContractTypeName(contract.contract.type_id);
            slaList = bll.GetSLAList();
            udfList = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.CONTRACTS);

            if (!IsPostBack)
            {
                // 绑定联系人列表
                var contactList = new ContactBLL().GetContactByCompany(contract.contract.account_id);
                contact_id.DataTextField = "name";
                contact_id.DataValueField = "id";
                contact_id.DataSource = contactList;
                contact_id.DataBind();
                if (contract.contract.contact_id == null)
                    contact_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
                else
                {
                    contact_id.Items.Insert(0, new ListItem() { Value = "", Text = "   " });
                    contact_id.SelectedValue = ((long)contract.contract.contact_id).ToString();
                }

                // 绑定商机列表
                var oppList = new OpportunityBLL().GetOpportunityByCompany(contract.contract.account_id);
                opportunity_id.DataTextField = "name";
                opportunity_id.DataValueField = "id";
                opportunity_id.DataSource = oppList;
                opportunity_id.DataBind();
                if (contract.contract.opportunity_id == null)
                    opportunity_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
                else
                {
                    opportunity_id.Items.Insert(0, new ListItem() { Value = "", Text = "   " });
                    opportunity_id.SelectedValue = ((long)contract.contract.opportunity_id).ToString();
                }

                // 绑定通知联系人列表
                if (contract.contract.bill_to_account_id == null)
                {
                    bill_to_contact_id.Enabled = false;
                }
                else
                {
                    var billContact = new ContactBLL().GetContactByCompany(contract.contract.account_id);
                    bill_to_contact_id.DataTextField = "name";
                    bill_to_contact_id.DataValueField = "id";
                    bill_to_contact_id.DataSource = billContact;
                    bill_to_contact_id.DataBind();
                    if (contract.contract.bill_to_contact_id == null)
                        bill_to_contact_id.Items.Insert(0, new ListItem() { Value = "", Text = "   ", Selected = true });
                    else
                    {
                        bill_to_contact_id.Items.Insert(0, new ListItem() { Value = "", Text = "   " });
                        bill_to_contact_id.SelectedValue = ((long)contract.contract.bill_to_contact_id).ToString();
                    }
                }
            }
        }

        protected void SaveClose_Click(object sender, EventArgs e)
        {
            ctt_contract contractEdit = AssembleModel<ctt_contract>();
            bll.EditContract(contractEdit, GetLoginUserId());
            Response.Write("<script>alert('编辑合同成功！');window.close();self.opener.location.reload();</script>");
        }
    }
}