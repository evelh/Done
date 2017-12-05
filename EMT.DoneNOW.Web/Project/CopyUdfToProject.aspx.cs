using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DAL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.Project
{
    public partial class CopyUdfToProject : BasePage
    {
        protected pro_project thisProject = null;
        protected crm_account thisAccount = null;
        protected crm_opportunity thisOppo = null;
        protected List<UserDefinedFieldDto> project_udf_list = null;
        protected List<UserDefinedFieldValue> project_udfValueList = null;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                var project_id = Request.QueryString["project_id"];
                thisProject = new pro_project_dal().FindNoDeleteById(long.Parse(project_id));
                if (thisProject != null)
                {
                    project_udf_list = new UserDefinedFieldsBLL().GetUdf(DicEnum.UDF_CATE.PROJECTS);
                    project_udfValueList = new UserDefinedFieldsBLL().GetUdfValue(DicEnum.UDF_CATE.PROJECTS, thisProject.id, project_udf_list);
                    thisAccount = new CompanyBLL().GetCompany(thisProject.account_id);
                    if (thisProject.opportunity_id != null)
                    {
                        thisOppo = new crm_opportunity_dal().FindNoDeleteById((long)thisProject.opportunity_id);
                    }
                }
            }
            catch (Exception)
            {
                Response.End();
            }

        }

        protected void finish_Click(object sender, EventArgs e)
        {
            if(project_udf_list!=null&& project_udf_list.Count > 0)
            {
                List<UserDefinedFieldValue> udfValueList = new List<UserDefinedFieldValue>(); 
                foreach (var proUdf in project_udf_list)
                {
                    var thisUdfValue = Request.Form[proUdf.id.ToString()];
                    if (!string.IsNullOrEmpty(thisUdfValue))
                    {
                        udfValueList.Add(new UserDefinedFieldValue() {id = proUdf.id,value = thisUdfValue });
                    }
                    else
                    {
                        udfValueList.Add(project_udfValueList.FirstOrDefault(_=>_.id==proUdf.id));
                    }
                }
                new UserDefinedFieldsBLL().UpdateUdfValue(DicEnum.UDF_CATE.PROJECTS, project_udf_list,thisProject.id, udfValueList,new UserInfoDto() { id=LoginUser.id,name=LoginUser.name}, DicEnum.OPER_LOG_OBJ_CATE.PROJECT_EXTENSION_INFORMATION);
            }
            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>document.getElementsByClassName('Workspace1')[0].style.display = 'none'document.getElementsByClassName('Workspace3')[0].style.display = 'none';document.getElementsByClassName('Workspace4')[0].style.display = '';</script>");
        }
    }
}