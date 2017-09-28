using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.Core;

namespace EMT.DoneNOW.Web.Contract
{
    public partial class ContractMilestone : BasePage
    {
        protected long milestoneId;         // 里程碑id
        protected string duDate = "";       // 截至日期
        protected string billCode = "";     // 计费代码
        protected int statu = 0;            // 编辑合同的状态
        protected List<DictionaryEntryDto> statuList;
        private long contractId;            // 合同id
        private ContractBLL bll = new ContractBLL();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string rid = Request.QueryString["id"];
                if (!long.TryParse(rid, out milestoneId))
                    milestoneId = 0;
                rid = Request.QueryString["contractId"];
                if (!long.TryParse(rid, out contractId))
                {
                    Response.Close();
                    return;
                }

                contract_id.Value = contractId.ToString();
                milstId.Value = milestoneId.ToString();

                statuList = bll.GetMilestoneStatuDic();

                if (milestoneId > 0)
                {
                    InitFieldEdit();
                }
                else    // 新增里程碑
                {
                    statuList.Remove(statuList.Find(s => s.val.Equals(((int)DicEnum.MILESTONE_STATUS.BILLED).ToString()))); // 移除已计费选项
                }
            }
            else
                SaveClose();
        }

        private void InitFieldEdit()
        {
            var entity = bll.GetMilestone(milestoneId);
            name.Text = entity.name;
            dollars.Text = (entity.dollars == null ? "" : ((decimal)entity.dollars).ToString());
            duDate = entity.due_date.ToString("yyyy-MM-dd");
            billCode = entity.cost_code_id == null ? "" : ((long)entity.cost_code_id).ToString();
            description.Text = entity.description;
            statu = entity.status_id;
        }

        protected void SaveClose()
        {
            ctt_contract_milestone milst = AssembleModel<ctt_contract_milestone>();

            if (long.Parse(milstId.Value) == 0)
            {
                milst.id = long.Parse(milstId.Value);
                bll.AddMilestone(milst, GetLoginUserId());
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('编辑里程碑成功');window.parent.location.reload();window.close();</script>");
            }
            else
            {
                bll.UpdateMilestone(milst, GetLoginUserId());
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('新增里程碑成功');window.parent.location.reload();window.close();</script>");
            }
        }
    }
}