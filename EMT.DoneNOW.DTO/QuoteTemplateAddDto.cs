using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class QuoteTemplateAddDto
    {
        public Tax_Total_Disp tax_total_disp;
        /// <summary>
        /// 税收汇总
        /// </summary>
        public class Tax_Total_Disp {
            public string Subtotal;//子汇总
            public string Semi_Annual_Total;//半年总汇总
            public string Semi_Annual_Subtotal;//半年子汇总
            public string Yearly_Subtotal;//全年子汇总
            public string Total;//总汇总
            public string Total_Taxes;//税收汇总
            public string Yearly_Total;//全年总汇总
            public string Item_Total;//子项汇总
            public string Shipping_Subtotal;//配送子汇总
            public string One_Time_Subtotal;//一次性子汇总
            public string Shipping_Total;//配送总汇总
            public string One_Time_Total;//一次性总汇总
            public string One_Time_Discount_Subtotal;//一次性子折扣汇总
            public string Monthly_Subtotal;//月度子汇总
            public string One_Time_Discount_Total;//一次性折扣汇总
            public string Monthly_Total;//月度总汇总
            public string Optional_Subtotal;//可选项子汇总
            public string Quarterly_Subtotal;//季收费子汇总
            public string Optional_Total;//可选项汇总
            public string Quarterly_Total;//季收费汇总
            public string Including_Optional_Quote_Items;//包括可选项汇总
        }

        //表格显示字段设置
        public class GRID_COLUMNITEM
        {
            /// <summary>
            /// 显示顺序（从左到右）
            /// </summary>
            public string Order { get; set; }
            /// <summary>
            /// 字段内容
            /// </summary>
            public string Column_Content { get; set; }
            /// <summary>
            /// 显示名称
            /// </summary>
            public string Column_label { get; set; }
            /// <summary>
            /// 显示
            /// </summary>
            public string Display { get; set; }
        }
        //表格格式设置
        public class GRID_OPTIONSITEM
        {
            /// <summary>
            /// 显示表头
            /// </summary>
            public string Show_grid_header { get; set; }
            /// <summary>
            /// 显示表格的竖线
            /// </summary>
            public string Show_vertical_lines { get; set; }
            /// <summary>
            /// 显示报价备注
            /// </summary>
            public string Show_QuoteComment { get; set; }
        }
        //报价项字段设置
        public class CUSTOMIZE_THE_ITEM_COLUMNITEM
        {
            /// <summary>
            /// 报价项类型ID
            /// </summary>
            public string Type_of_Quote_Item_ID { get; set; }
            /// <summary>
            /// 报价项类型
            /// </summary>
            public string Type_of_Quote_Item { get; set; }
            /// <summary>
            /// 显示内容
            /// </summary>
            public string Display_Format { get; set; }
        }
        //分组名称设置
        public class GROUPING_HEADER_TEXTITEM
        {
            /// <summary>
            /// 一次性收费
            /// </summary>
            public string One_Time_items { get; set; }
            /// <summary>
            /// 月收费
            /// </summary>
            public string Monthly_items { get; set; }
            /// <summary>
            /// 季收费
            /// </summary>
            public string Quarterly_items { get; set; }
            /// <summary>
            /// 半年收费
            /// </summary>
            public string Semi_Annual_items { get; set; }
            /// <summary>
            /// 年收费
            /// </summary>
            public string Yearly_items { get; set; }
            /// <summary>
            /// 配送费
            /// </summary>
            public string Shipping_items { get; set; }
            /// <summary>
            /// 一次性折扣
            /// </summary>
            public string One_Time_Discount_items { get; set; }
            /// <summary>
            /// 可选项
            /// </summary>
            public string Optional_items { get; set; }
            /// <summary>
            /// 无分类
            /// </summary>
            public string No_category { get; set; }
        }
        /// <summary>
        /// 报价模板正文
        /// </summary>
        public class BODY
        {
            /// <summary>
            /// 表格显示字段设置 支持收缩，默认展开，指定显示的字段，可以修改显示名称、是否显示和显示顺序
            /// </summary>
            public List<GRID_COLUMNITEM> GRID_COLUMN { get; set; }
            /// <summary>
            /// 表格格式设置 支持收缩，默认展开，
            /// </summary>
            public List<GRID_OPTIONSITEM> GRID_OPTIONS { get; set; }
            /// <summary>
            /// 报价项字段设置 支持收缩，默认展开，可以定义不同类型的报价项（名称）字段显示内容
            /// </summary>
            public List<CUSTOMIZE_THE_ITEM_COLUMNITEM> CUSTOMIZE_THE_ITEM_COLUMN { get; set; }
            /// <summary>
            /// 分组名称设置 支持收缩，默认展开
            /// </summary>
            public List<GROUPING_HEADER_TEXTITEM> GROUPING_HEADER_TEXT { get; set; }
        }
        public class AlertVariableList {
            public string value { get; set; }
            public string name { get; set; }
        }
    }
}
