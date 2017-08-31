using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EMT.DoneNOW.Web
{
    public partial class OpportunityWinOrLossReason :BasePage
    {
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected string name;
        protected int id;
        protected List<d_general> ReasonList = new List<d_general>();
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            name = Convert.ToString(Request.QueryString["reason"]);
            if (name == "win")
            {
                name = "赢得商机的原因";
            }
            else if (name == "loss")
            {
                name = "丢失商机的原因";
            }
            else {
                //返回
                Response.Write("<script>alert('获取相关信息失败！');window.close();self.opener.location.reload();</script>");
            }
            ReasonList = new GeneralBLL().GetGeneralList(id);
            GetMenus();
        }
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
            contextMenu.Add(new PageContextMenuDto { text = "激活", click_function = "Active()" });
            contextMenu.Add(new PageContextMenuDto { text = "失活", click_function = "NoActive()" });
            contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
        }
    }
}