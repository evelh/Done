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
    public partial class ChangeBoardManage : BasePage
    {
        protected bool isAdd = true;
        protected d_change_board board;
        protected List<d_change_board_person> personList;
        protected string resIds;
        protected ChangeBoardBll cbBll = new ChangeBoardBll();
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                board = cbBll.GetBoard(id);
            if (board != null)
            {
                isAdd = false; personList = cbBll.GerPersonList(board.id);
            }
            if (personList != null && personList.Count > 0)
                personList.ForEach(_ => {
                    resIds += _.resource_id.ToString() + ',';
                });
            if (!string.IsNullOrEmpty(resIds))
                resIds = resIds.Substring(0, resIds.Length-1);
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            d_change_board pageBoard = AssembleModel<d_change_board>();
            if (!string.IsNullOrEmpty(Request.Form["isActive"]) && Request.Form["isActive"] == "on")
                pageBoard.is_active = 1;
            else
                pageBoard.is_active = 0;
            if (!string.IsNullOrEmpty(Request.Form["isContact"]) && Request.Form["isContact"] == "on")
                pageBoard.include_ticket_contact = 1;
            else
                pageBoard.include_ticket_contact = 0;
            if (!string.IsNullOrEmpty(Request.Form["isPriContact"]) && Request.Form["isPriContact"] == "on")
                pageBoard.include_primary_contact = 1;
            else
                pageBoard.include_primary_contact = 0;
            if (!string.IsNullOrEmpty(Request.Form["isParPriContact"]) && Request.Form["isParPriContact"] == "on")
                pageBoard.include_parent_account_primary_contact = 1;
            else
                pageBoard.include_parent_account_primary_contact = 0;
            if (!string.IsNullOrEmpty(Request.Form["isAccMan"]) && Request.Form["isAccMan"] == "on")
                pageBoard.include_account_resource = 1;
            else
                pageBoard.include_account_resource = 0;

            if (!isAdd)
            {
                board.name = pageBoard.name;
                board.is_active = pageBoard.is_active;
                board.description = pageBoard.description;
                board.include_ticket_contact = pageBoard.include_ticket_contact;
                board.include_primary_contact = pageBoard.include_primary_contact;
                board.include_parent_account_primary_contact = pageBoard.include_parent_account_primary_contact;
                board.include_account_resource = pageBoard.include_account_resource;
            }
            string resIds = Request.Form["resIds"];
            bool result = false;
            if (isAdd)
                result = cbBll.AddBoard(pageBoard, resIds, LoginUserId);
            else
                result = cbBll.EditBoard(board, resIds, LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result ? "成功" : "失败")}!');self.opener.location.reload();window.close();</script>");
        }
    }
}