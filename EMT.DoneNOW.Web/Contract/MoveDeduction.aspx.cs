using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DTO;


namespace EMT.DoneNOW.Web.Contract
{
    public partial class MoveDeduction : BasePage
    {
        protected crm_account_deduction deduction;
        protected v_widget_posted_item vItem;
        protected ctt_contract contract;
        protected ctt_contract_block block;
        protected InvoiceBLL invBll = new InvoiceBLL();
        protected Dictionary<long, List<MoveDeductionDto>> dic = new Dictionary<long, List<MoveDeductionDto>>();
        protected decimal? dedNum;
        protected decimal befotMoveNum;  // 转移前的数量 （余额）
        protected void Page_Load(object sender, EventArgs e)
        {
            long id = 0;
            if (!string.IsNullOrEmpty(Request.QueryString["id"]) && long.TryParse(Request.QueryString["id"], out id))
                deduction = invBll.GetDeduction(id);

            if (deduction != null)
            {
                vItem = new DAL.v_widget_posted_item_dal().FindById(deduction.id);
                if (deduction.contract_id != null)
                    contract = new ContractBLL().GetContract((long)deduction.contract_id);
                if (deduction.contract_block_id != null)
                    block = new ContractBlockBLL().GetBlockById((long)deduction.contract_block_id);
                if(block!=null)
                    contract = new ContractBLL().GetContract(block.contract_id);
                
                string contractTypeSql = string.Empty;  // 合同类型过滤
                if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER)
                {
                    contractTypeSql = $" and cc.type_id = {(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER} ";
                    dedNum = deduction.extended_price;

                    if (block != null)
                        befotMoveNum = Convert.ToDecimal(new DAL.crm_account_dal().GetSingle($"SELECT round(b.rate*b.quantity - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = b.id	AND delete_time = 0	),0),2) AS rate FROM ctt_contract_block b WHERE b.delete_time = 0 and b.id = {block.id} "));
                }
                else if (contract?.type_id == (int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS)
                {
                    contractTypeSql = $" and cc.type_id = {(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS} ";
                    dedNum = deduction.quantity;
                    if (block != null)
                        befotMoveNum = Convert.ToDecimal(new DAL.crm_account_dal().GetSingle($"SELECT sum(round(b.rate - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = b.id AND delete_time = 0 ),0),2)) AS rate FROM ctt_contract_block b WHERE b.delete_time = 0 and b.id ={block.id} "));
                }
                var dtoList = new CompanyBLL().GetBySql<MoveDeductionDto>($@"SELECT ccb.id,ccb.start_date,ccb.end_date,cc.id as contract_id,cc.name as contract_name, ca.id as account_id, ca.name as account_name,ccb.status_id,
case cc.type_id 
when {(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.RETAINER} 
then round(ccb.rate*ccb.quantity - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = ccb.id	AND delete_time = 0	),0),2) 
when  {(int)EMT.DoneNOW.DTO.DicEnum.CONTRACT_TYPE.BLOCK_HOURS} 
then round(ccb.rate - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = ccb.id AND delete_time = 0 ),0),2)
else 0 end as balance from ctt_contract_block ccb 
INNER JOIN  ctt_contract cc on ccb.contract_id = cc.id
INNER JOIN crm_account ca on cc.account_id = ca.id
where ccb.delete_time =0 and cc.delete_time =0 and (cc.account_id = {deduction.account_id} or ca.parent_id = {deduction.account_id}) {contractTypeSql} and (round(ccb.rate*ccb.quantity - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = ccb.id	AND delete_time = 0	),0),2) >0 or round(ccb.rate - ifnull((SELECT sum(extended_price)FROM crm_account_deduction WHERE contract_block_id = ccb.id AND delete_time = 0 ),0),2)>0)");
                if (dtoList != null && dtoList.Count > 0)
                {
                    dtoList = dtoList.OrderBy(_ => _.start_date).ToList();
                    dic = dtoList.GroupBy(_ => _.contract_id).ToDictionary(_ => _.Key, _ => _.ToList());
                }
            }
            else
            {
                Response.Write("<script>alert('未获取到相关条目!');window.close();</script>");
            }
        }

        protected void save_close_Click(object sender, EventArgs e)
        {
            long? blockId=null;
            if (!string.IsNullOrEmpty(Request.Form["ToblockSelect"]))
                blockId = long.Parse(Request.Form["ToblockSelect"]);
            bool result = new InvoiceBLL().MoveDeduction(deduction.id,blockId,LoginUserId);

            ClientScript.RegisterStartupScript(this.GetType(), "提示信息", $"<script>alert('保存{(result?"成功":"失败")}！');self.opener.location.reload();window.close();</script>");
        }
    }
    public class MoveDeductionDto
    {
        public long id;
        public DateTime start_date;
        public DateTime end_date;
        public long contract_id;
        public string contract_name;
        public long account_id;
        public string account_name;
        public sbyte status_id;
        public decimal balance;
    }
}