using System;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;
using System;
using System.Collections.Generic;

namespace EMT.DoneNOW.Web
{
    public partial class OppoAdvancedField :BasePage
    {
        public List<d_general> GeneralList = new List<d_general>();
        public int id;
        public string name;
        protected GeneralBLL gbll = new GeneralBLL();
        protected List<PageContextMenuDto> contextMenu = null;  // 右键菜单信息
        protected void Page_Load(object sender, EventArgs e)
        {
            id = Convert.ToInt32(Request.QueryString["id"]);
            GeneralList = new GeneralBLL().GetGeneralList(id);
            GetMenus();
        }
        private void GetMenus()
        {
            contextMenu = new List<PageContextMenuDto>();
            contextMenu.Add(new PageContextMenuDto { text = "修改", click_function = "Edit()" });
            contextMenu.Add(new PageContextMenuDto { text = "删除", click_function = "Delete()" });
        }
    }
}