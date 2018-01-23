using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using EMT.DoneNOW.DTO;
using EMT.DoneNOW.BLL;
using EMT.DoneNOW.Core;
using EMT.DoneNOW.DAL;

namespace EMT.DoneNOW.Web.ConfigurationItem
{
    public partial class QuoteItemWizard : BasePage
    {
        protected crm_quote quote = null;
        protected List<crm_quote_item> productItemList = new List<crm_quote_item>();       // 未生成配置项的产品报价项
        protected List<crm_quote_item> ExistProductItemList = new List<crm_quote_item>();  // 生成配置项的产品报价项
        protected bool isShowProduct = false;
        protected List<crm_quote_item> chargeItemList = new List<crm_quote_item>();        // 未生成配置项的成本报价项
        protected List<crm_quote_item> ExistChargeItemList = new List<crm_quote_item>();   // 生成配置项的成本报价项
        protected bool isShowCharge = false;
        protected ivt_product defaultPro = new ivt_product_dal().GetDefaultProduct();
        protected void Page_Load(object sender, EventArgs e)
        {
            var quote_id = Request.QueryString["quote_id"];
            if (!string.IsNullOrEmpty(quote_id))
            {
                quote = new crm_quote_dal().FindNoDeleteById(long.Parse(quote_id));
            }
            if (quote != null)
            {
                // 如何获取到已经生成配置项 的报价项和为生成配置项的报价项 

                // 1 获取产品相关报价项
                // 2 根据产品报价项的数量，去获取相应的配置项数量，数量不足时，将剩余的报价项放入展示的报价项中
                // 3 成本同理

                var cqiDal = new crm_quote_item_dal();
                var cipDal = new crm_installed_product_dal();
                #region 获取相应的产品报价项
                var productList = cqiDal.GetItemByType(quote.id, (int)DTO.DicEnum.QUOTE_ITEM_TYPE.PRODUCT);
                if (productList!=null&& productList.Count > 0)
                {
                    isShowProduct = true;
                    
                    foreach (var item in productList)
                    {
                        if (item.quantity != null&&item.quote_id!=null)
                        {
                            var insProList = cipDal.GetInsProByQuoteId((long)item.id, (long)item.quantity);
                            int num = (int)item.quantity; // 获取多少次 这个报价项
                            if(insProList!=null&& insProList.Count > 0)
                            {
                                num = (int)item.quantity - insProList.Count;
                                var itemList = cqiDal.GetItemByNum(item.id, insProList.Count);
                                if(itemList!=null&& itemList.Count > 0)
                                {
                                    ExistProductItemList.AddRange(itemList);
                                }
                            }
                            if (num > 0)
                            {
                                var itemList = cqiDal.GetItemByNum(item.id, num);
                                if (itemList != null && itemList.Count > 0)
                                {
                                    productItemList.AddRange(itemList);
                                }
                            }
                        }
                    }

                }
                #endregion


                #region 获取相应的成本报价项
                var chargeList = cqiDal.GetItemByType(quote.id, (int)DTO.DicEnum.QUOTE_ITEM_TYPE.DEGRESSION);
                if (chargeList != null && chargeList.Count > 0)
                {
                    isShowCharge = true;

                    foreach (var item in chargeList)
                    {
                        if (item.quantity != null && item.quote_id != null)
                        {
                            var insProList = cipDal.GetInsProByQuoteId((long)item.id, (long)item.quantity);
                            int num = (int)item.quantity; // 获取多少次 这个报价项
                            if (insProList != null && insProList.Count > 0)
                            {
                                num = (int)item.quantity - insProList.Count;
                                var itemList = cqiDal.GetItemByNum(item.id, insProList.Count);
                                if (itemList != null && itemList.Count > 0)
                                {
                                    ExistChargeItemList.AddRange(itemList);
                                }
                            }
                            if (num > 0)
                            {
                                var itemList = cqiDal.GetItemByNum(item.id, num);
                                if (itemList != null && itemList.Count > 0)
                                {
                                    chargeItemList.AddRange(itemList);
                                }
                            }
                        }
                    }

                }

                #endregion

                if (!IsPostBack)
                {
                    rbBuyDate.Enabled = false;
                }
             
            }
        }

        protected void btnFinish_Click(object sender, EventArgs e)
        {
            var QuoteConfigItemDto = new QuoteConfigItemDto();
            var proItemIds = Request.Form["ChooseProductIds"];
            if (!string.IsNullOrEmpty(proItemIds))
            {
                List<InsProDto> proList = new List<InsProDto>();
                var proItemIdArr = proItemIds.Split(new char[] {','},StringSplitOptions.RemoveEmptyEntries);
                foreach (var proItemId in proItemIdArr)
                {
                    var thisProItemArr = proItemId.Split('_');
                    var InsProDto = new InsProDto();
                    InsProDto.itemId = long.Parse(thisProItemArr[0]);
                    var start_date = Request.Form[proItemId + "_start_date"];
                    if (!string.IsNullOrEmpty(start_date))
                    {
                        InsProDto.insDate = DateTime.Parse(start_date);
                    }
                    var through_date = Request.Form[proItemId+"_through_date"];
                    if (!string.IsNullOrEmpty(through_date))
                    {
                        InsProDto.expDate = DateTime.Parse(through_date);
                    }
                    InsProDto.pageProId = proItemId;
                    InsProDto.serNumber = Request.Form[proItemId+"_serial_number"];
                    InsProDto.refNumber = Request.Form[proItemId + "_reference_number"];
                    InsProDto.refName = Request.Form[proItemId + "_reference_name"];
                    proList.Add(InsProDto);
                }
                QuoteConfigItemDto.insProList = proList;
            }

            var chooseSubIds = Request.Form["ChooseSubIds"];
            if (!string.IsNullOrEmpty(chooseSubIds))
            {
                List<InsProSubDto> proList = new List<InsProSubDto>();
                var subProItemIdArr = chooseSubIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var subProItemId in subProItemIdArr)
                {
                    var thisSubProItemArr = subProItemId.Split('_');
                    var InsProSubDto = new InsProSubDto();
                    InsProSubDto.insProId = thisSubProItemArr[0] + '_' + thisSubProItemArr[1];
                    InsProSubDto.subName = Request.Form[InsProSubDto.insProId+"_name"];
                    InsProSubDto.subDes = Request.Form[InsProSubDto.insProId + "_des"];
                    InsProSubDto.perType = int.Parse(Request.Form[InsProSubDto.insProId + "_period"]);
                    var start_date = Request.Form[subProItemId + "_start_date"];
                    if (!string.IsNullOrEmpty(start_date))
                    {
                        InsProSubDto.effDate = DateTime.Parse(start_date);
                    }
                    var through_date = Request.Form[subProItemId + "_through_date"];
                    if (!string.IsNullOrEmpty(through_date))
                    {
                        InsProSubDto.expDate = DateTime.Parse(through_date);
                    }
                    var per_price = Request.Form[subProItemId + "_per_price"];
                    if (!string.IsNullOrEmpty(per_price))
                    {
                        InsProSubDto.sunPerPrice = decimal.Parse(per_price);
                    }
                    proList.Add(InsProSubDto);
                }
                QuoteConfigItemDto.insProSubList = proList;
            }
            var chooseChargeIds = Request.Form["ChooseChargeIds"];
            if (!string.IsNullOrEmpty(chooseChargeIds))
            {
                
                List<InsChargeDto> proList = new List<InsChargeDto>();
                var chaItemIdArr = chooseChargeIds.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
                foreach (var chaItemId in chaItemIdArr)
                {
                    var thisChaItemArr = chaItemId.Split('_');
                    var ChaItemDto = new InsChargeDto();
                    ChaItemDto.itemId = long.Parse(thisChaItemArr[0]);
                    var product_id = Request.Form[thisChaItemArr[0] + '_' + thisChaItemArr[1] + "_product_id"];
                    if (!string.IsNullOrEmpty(product_id))
                    {
                        ChaItemDto.productId = long.Parse(product_id);
                    }
                    var insDate = Request.Form[thisChaItemArr[0]+'_'+ thisChaItemArr[1]+"_charge_start_date"];
                    if (!string.IsNullOrEmpty(insDate))
                    {
                        ChaItemDto.insDate = DateTime.Parse(insDate);
                    }
                    var through_date = Request.Form[thisChaItemArr[0] + '_' + thisChaItemArr[1] + "_charge_through_date"];
                    if (!string.IsNullOrEmpty(through_date))
                    {
                        ChaItemDto.warExpDate = DateTime.Parse(through_date);
                    }
                    ChaItemDto.serNumber = Request.Form[thisChaItemArr[0] + '_' + thisChaItemArr[1] + "_charge_serial_number"];
                    ChaItemDto.refNumber = Request.Form[thisChaItemArr[0] + '_' + thisChaItemArr[1] + "_charge_reference_number"];
                    ChaItemDto.refName = Request.Form[thisChaItemArr[0] + '_' + thisChaItemArr[1] + "_charge_reference_name"];

                    proList.Add(ChaItemDto);
                }
                QuoteConfigItemDto.insChargeList = proList;
            }
            QuoteConfigItemDto.quote_id = quote.id;
            if (string.IsNullOrEmpty(proItemIds) && string.IsNullOrEmpty(chooseChargeIds))
            {
                // 代表没有选择生成配置项 - 关闭页面
                ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>window.close();self.opener.location.reload();</script>");
            }
            else
            {
                var result = new InstalledProductBLL().AddInsProByQuote(QuoteConfigItemDto, LoginUserId);
                if (result)
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存成功！');window.close();self.opener.location.reload();</script>");
                }
                else
                {
                    ClientScript.RegisterStartupScript(this.GetType(), "提示信息", "<script>alert('保存失败！');window.close();self.opener.location.reload();</script>");
                }
            }
            

        }
    }
}