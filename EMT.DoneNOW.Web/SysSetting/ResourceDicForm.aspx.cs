using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;

namespace EMT.DoneNOW.Web.SysSetting
{
    public partial class ResourceDicForm : BasePage
    {
        protected string type="skill";
        protected string typeName = "技能";
        protected d_general thisDic;   
        protected int generalId=(int)DicEnum.SKILLS_CATE_TYPE.SKILLS;
        protected List<d_general> cateList;
        protected bool isAdd = true;
        protected GeneralBLL genBll = new GeneralBLL();
        protected void Page_Load(object sender, EventArgs e)
        {
            type = Request.QueryString["type"];
          
            long id = 0;
            if(long.TryParse(Request.QueryString["id"],out id))
                thisDic = genBll.GetSingleGeneral(id);
            if (thisDic != null)
            {
                isAdd = false;
                if (thisDic.parent_id != null)
                {
                    var thisParent = genBll.GetSingleGeneral((long)thisDic.parent_id);
                    if (thisParent != null)
                    {
                        if (thisParent.parent_id == (int)DicEnum.SKILLS_CATE_TYPE.CERTIFICATION)
                            type = "Certificate";
                        else if (thisParent.parent_id == (int)DicEnum.SKILLS_CATE_TYPE.DEGREE)
                            type = "Degree";
                    }
                }
            }
            if (type == "Certificate")
            { generalId = (int)DicEnum.SKILLS_CATE_TYPE.CERTIFICATION; typeName = "证书"; }
            else if (type == "Degree")
            { generalId = (int)DicEnum.SKILLS_CATE_TYPE.DEGREE; typeName = "学位"; }
            cateList = new DAL.d_general_dal().GetGeneralByParentId(generalId);
            // 实体读取 table=60
            // 类别读取 table = 175
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
           if(string.IsNullOrEmpty(Request.Form["name"])|| string.IsNullOrEmpty(Request.Form["cateId"]))
            {
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert(‘未获取到名称或类别，请重试！');</script>");
                return;
            }
            d_general pageDic = new d_general()
            {
                name = Request.Form["name"],
                parent_id = int.Parse(Request.Form["cateId"]),
                remark = Request.Form["remark"],
                is_active = (sbyte)(!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on" ? 1 : 0),
                general_table_id = (int)GeneralTableEnum.RESOURCE_SKILL_TYPE,
            };

            if (isAdd)
                thisDic = pageDic;
            else
            {
                thisDic.name = pageDic.name;
                thisDic.parent_id = pageDic.parent_id;
                thisDic.remark = pageDic.remark;
                thisDic.is_active = pageDic.is_active;
            }
            bool result = false;
            if (isAdd)
                result = genBll.AddGeneral(thisDic, LoginUserId);
            else
                result = genBll.EditGeneral(thisDic,LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}