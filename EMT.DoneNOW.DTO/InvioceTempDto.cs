using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EMT.DoneNOW.DTO
{
    public class InvioceTempDto
    {
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
        }
        //字段设置
        public class CUSTOMIZE_THE_ITEM_COLUMNITEM
        {
            /// <summary>
            /// 显示顺序
            /// </summary>
            public string Order { get; set; }
            /// <summary>
            /// 类型ID
            /// </summary>
            public string Type_of_Invoice_Item_ID { get; set; }
            /// <summary>
            /// 类型名称
            /// </summary>
            public string Type_of_Invoice_Item { get; set; }
            /// <summary>
            /// 显示内容
            /// </summary>
            public string Display_Format { get; set; }
            /// <summary>
            /// 扩展
            /// </summary>
            public string Add_Display_Format { get; set; }
            //扩展字段设置
            public List<SETTING_ITEM> ADD_SETTING { get; set; }
        }
        /// <summary>
        /// 扩展字段设置
        /// </summary>
        public class SETTING_ITEM
        {
            public string id = "0";
            public string name { get; set; }
            public string value { get; set; }
        }
        /// <summary>
        /// 模板正文
        /// </summary>
        public class Invoice_Body
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
            /// 字段设置 支持收缩，默认展开，可以定义不同类型的（名称）字段显示内容
            /// </summary>
            public List<CUSTOMIZE_THE_ITEM_COLUMNITEM> CUSTOMIZE_THE_ITEM_COLUMN { get; set; }
            /// <summary>
            /// 扩展(工时和服务)
            /// </summary>
            public List<SETTING_ITEM> ADD_SETTING { get; set; }
        }
        public class Invoice_ext
        {
            public List<SETTING_ITEM> Bottom_Item { get; set; }
            public List<SETTING_ITEM> Labour_Item { get; set; }
            public List<SETTING_ITEM> Service_Bundle_Item { get; set; }
        }
        public class Invoice_ext2
        {
            public List<SETTING_ITEM> item { get; set; }
        }
        public class TempContent
        {
            public Int32 id { get; set; }
            public string name { get; set; }
            public string head { get; set; }
            public string top { get; set; }
            public string body { get; set; }
            public string bottom { get; set; }
            public string foot { get; set; }
            public string Invoice_text { get; set; }
            public string foot_note { get; set; }
            //税
            public int tax_cat { get; set; }
            public int tax_sup { get; set; }
            public int tax_group { get; set; }
            //分组
            public int body_group_by { get; set; }
            public int body_order_by { get; set; }
            public int body_itemize_id { get; set; }
        }
    }
}
