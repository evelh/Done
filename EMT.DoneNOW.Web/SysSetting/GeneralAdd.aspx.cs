using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class GeneralAdd :BasePage 
    {
        protected long id;//需要修改的id
        protected long type;     // 需要操作的功能判断
        protected long parentid;
        protected string typename;//操作的名称
        private GeneralBLL gbll=new GeneralBLL ();
        protected d_general general=new d_general ();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!long.TryParse(Request.QueryString["type"], out type))
            {
                Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>");
            }
            if (!long.TryParse(Request.QueryString["id"], out id))
            {
                id = 0;
            }
            //测试业务范围
            //type = 99;
            //id = 1102;
            //测试项目状态
            //type = 100;
            //id = 1345;
            //测试任务类别
            //type = 101;
            //id = 1807;
            //付款期限
            //type = 102;
            //id = 475;
            //付款类型
            //type = 103;
            //id = 478;
            //配送类型
            //type = 104;
            //id = 493;
            switch (type)
            {
                case (long)QueryType.Line_Of_Business:
                    typename = "新增-组织：业务范围";
                    break;
                case (long)QueryType.Project_Status:
                    typename = "新增-项目和任务：项目状态";
                    break;
                case (long)QueryType.Task_Type:
                    typename = "新增-项目和任务：任务类型";
                    break;
                case (long)QueryType.Payment_Term:
                    typename = "新增-财务、会计和发票：付款期限";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), OpenWindow.GeneralJs.ToString(), @"$('#newicon').show();", true);
                    this.Save_New.Visible = true;
                    break;
                case (long)QueryType.Payment_Type:
                    typename = "新增-财务、会计和发票：付款类型";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), OpenWindow.GeneralJs.ToString(), @"$('#newicon').show();", true);
                    this.Save_New.Visible = true;
                    break;
                case (long)QueryType.Payment_Ship_Type:
                    typename = "新增-财务、会计和发票：配送类型";
                    Page.ClientScript.RegisterStartupScript(this.GetType(), OpenWindow.GeneralJs.ToString(), @"$('#newicon').show();", true);
                    this.Cost_Code.Visible = true;
                    this.Save_New.Visible = true;                   
                    break;
                default: Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>"); break;
            }
            if (!IsPostBack)
            {
                if (type == (long)QueryType.Payment_Ship_Type)
                {
                    Cost_Code.DataTextField = "value";
                    Cost_Code.DataValueField = "key";
                    Cost_Code.DataSource = gbll.GetCodeList();
                    Cost_Code.DataBind();
                    Cost_Code.Items.Insert(0, new ListItem() { Value = "0", Text = "   ", Selected = true });
                }
                this.Active.Checked = true;
                if (id > 0)//修改
                {
                    general = gbll.GetSingleGeneral(id);
                    if (general != null)
                    {
                        typename = typename.Replace("新增", "修改");
                        this.Name.Text = general.name;
                        if (!string.IsNullOrEmpty(general.remark))
                        {
                            this.Description.Text = general.remark;
                        }
                        if (general.is_active > 0)
                        {
                            this.Active.Checked = true;
                        }
                        else
                        {
                            this.Active.Checked = false;
                        }
                        if (general.sort_order != null)
                            this.Sort.Text = general.sort_order.ToString();
                        if (type == (long)QueryType.Payment_Term && general.ext1 != null)
                        {
                            this.termday.Text = general.ext1;
                        }
                        if (type == (long)QueryType.Payment_Type && general.ext1 != null)
                        {
                            int re;
                            if (int.TryParse(general.ext1, out re))
                            {
                                if (re > 0)
                                {
                                    this.Reimbursable.Checked = true;
                                }
                            }
                        }
                        if (type == (long)QueryType.Payment_Ship_Type)
                        {
                            int co;
                            if (int.TryParse(general.ext1, out co))
                            {
                                if (co > 0)
                                {
                                    this.Cost_Code.SelectedValue = co.ToString();
                                }
                            }
                        }
                    }
                    else
                    {
                        Response.Write("<script>alert('获取相关信息失败，返回上一页');window.close();</script>");
                    }
                }
                else {
                   
                }
            }
            else {

            }
        }
        protected void Save_Close_Click(object sender, EventArgs e)
        {
            if (save()) {
              Response.Write("<script>window.close();self.opener.location.reload();</script>");
            }
        }

        protected void Save_New_Click(object sender, EventArgs e)
        {
            if (save())
            {
                Response.Write("<script>window.location.href = 'GeneralAdd.aspx?type='"+type+";</script>");
            }           
        }
        private bool save() {
            switch (type)
            {
                case (long)QueryType.Line_Of_Business:
                    parentid = (long)GeneralTableEnum.LINE_OF_BUSINESS;
                    break;
                case (long)QueryType.Project_Status:
                    parentid = (long)GeneralTableEnum.PROJECT_STATUS;
                    break;
                case (long)QueryType.Task_Type:
                    parentid = (long)GeneralTableEnum.TASK_TYPE;
                    break;
                case (long)QueryType.Payment_Term:
                    parentid = (long)GeneralTableEnum.PAYMENT_TERM;
                    break;
                case (long)QueryType.Payment_Type:
                    parentid = (long)GeneralTableEnum.PAYMENT_TYPE;
                    break;
                case (long)QueryType.Payment_Ship_Type:
                    parentid = (long)GeneralTableEnum.PAYMENT_SHIP_TYPE;
                    break;
                default: break;
            }
            if (id > 0)//修改
            {
                general = gbll.GetSingleGeneral(id);
            }
            general.name = this.Name.Text.Trim().ToString();
            if (!string.IsNullOrEmpty(this.Description.Text.Trim().ToString()))
            {
                general.remark = this.Description.Text.Trim().ToString();
            }
            else
            {
                general.remark = null;
            }
            if (this.Active.Checked)
            {
                general.is_active = 1;
            }
            else
            {
                general.is_active = 0;
            }
            if (!string.IsNullOrEmpty(this.Sort.Text.Trim().ToString()))
            {
                general.sort_order = Convert.ToDecimal(this.Sort.Text.Trim().ToString());
            }
            else
            {
                general.sort_order = null;
            }
            if (parentid == (long)GeneralTableEnum.PAYMENT_TERM)
            {
                if (!string.IsNullOrEmpty(this.termday.Text.Trim().ToString()))
                {
                    general.ext1 = this.termday.Text.Trim().ToString();
                }
                else
                {
                    general.ext1 = null;
                }
            }
            if (parentid == (long)GeneralTableEnum.PAYMENT_TYPE)
            {
                if (this.Reimbursable.Checked)
                {
                    general.ext1 = "1";
                }
                else
                {
                    general.ext1 = null;
                }
            }
            if (parentid == (long)GeneralTableEnum.PAYMENT_SHIP_TYPE) {
                if (this.Cost_Code.SelectedIndex > 0)
                {
                    general.ext1 = this.Cost_Code.SelectedValue;
                }
                else {
                    general.ext1 = null;
                }
            }
            if (id > 0)
            {
                var result = gbll.Update(general, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('修改成功！');</script>");
                    return true;
                }
                if (result == DTO.ERROR_CODE.USER_NOT_FIND)
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            else
            {
                general.general_table_id = (int)parentid;
                var result = gbll.Insert(general, GetLoginUserId());
                if (result == DTO.ERROR_CODE.SUCCESS)
                {
                    Response.Write("<script>alert('添加成功！');</script>");
                    return true;
                }
                else if (result == DTO.ERROR_CODE.USER_NOT_FIND)
                {
                    Response.Write("<script>alert('查询不到用户，请重新登陆');</script>");
                    Response.Redirect("../Login.aspx");
                }
                else if (result == DTO.ERROR_CODE.EXIST)
                {
                    Response.Write("<script>alert('已经存在相同名称，请修改！');</script>");
                }
            }
            return false;
        }
    }
}