using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Globalization;
namespace EMT.Tools.Date
{
    /// <summary>
    /// 日期相关的扩展方法
    /// </summary>
    public static class DateHelper
    {
        /// <summary>
        /// 时间转换为标准时间的毫秒时间戳
        /// </summary>
        /// <param name="dt"></param>
        /// <returns></returns>
        public static long ToUniversalTimeStamp(DateTime dt)
        {
            return (dt.ToUniversalTime().Ticks - 621355968000000000) / 10000;
        }

        /// <summary>
        /// 判断字符串是否指定的时间格式
        /// </summary>
        /// <param name="datetime"></param>
        /// <param name="format"></param>
        /// <returns></returns>
        public static bool IsDatetimeFormat(string datetime, string format = "yyyy-MM-dd")
        {
            if (string.IsNullOrEmpty(datetime))
                return false;

            DateTime dt;
            IFormatProvider ifp = new CultureInfo("zh-CN", true);

            return DateTime.TryParseExact(datetime, format, ifp, DateTimeStyles.None, out dt);
        }

        /// <summary>
        /// DateTime转string:yyyy-MM-dd
        /// </summary>
        /// <param name="currdate"></param>
        /// <returns></returns>
        public static string ToYMD(this DateTime? currdate)
        {
            return currdate.Value.ToString("yyyy-MM-dd");
        }

        /// <summary>
        /// DateTime转string:yyyy/MM/dd
        /// </summary>
        /// <param name="currdate"></param>
        /// <returns></returns>
        public static string ToSlashYMD(this DateTime? currdate)
        {
            return currdate.Value.ToString("yyyy/MM/dd");
        }

        /// <summary>
        /// 返回两个日期的date部分是否一致（date+time 组成datetime）
        /// </summary>
        /// <param name="left"></param>
        /// <param name="right"></param>
        /// <returns></returns>
        public static bool HasTheSameDataParts(this DateTime left, DateTime right)
        {
            return left.Day == right.Day && left.Month == right.Month && left.Year == right.Year;
        }

        /// <summary>
        /// 两个datetime（年月日 时分秒）的比较 0-相等  ＜0-左小于右 >0 左大于右  
        /// </summary>
        /// <param name="left"></param>
        /// <returns></returns>
        public static int DateTimeCompare(this DateTime left, DateTime right)
        {
            return DateTime.Compare(left, right);
        }

        /// <summary>
        /// 两个date（年月日）的比较 0-相等  ＜0-左小于右 >0 左大于右 
        /// </summary>
        /// <param name="left"></param>
        /// <param name="right"></param>
        /// <returns></returns>
        public static int DateCompare(this DateTime left, DateTime right)
        {
            left = left.Date;
            right = right.Date;
            return DateTime.Compare(left, right);
        }

        //农历转公历
        public static DateTime LunarToSolar(this DateTime time)
        {
            ChineseLunisolarCalendar lunarCalendar;
            DateTime solar;
            int year, month, day;
            int leapMonth;

            lunarCalendar = new ChineseLunisolarCalendar();
            solar = time;
            year = solar.Year;
            month = solar.Month;
            day = Math.Min(solar.Day, lunarCalendar.GetDaysInMonth(year, month));
            leapMonth = lunarCalendar.GetLeapMonth(year);

            if (0 < leapMonth && leapMonth <= month)
            {
                ++month;
            }

            solar = lunarCalendar.ToDateTime(year, month, day, 0, 0, 0, 0);
            return solar;
        }

        //公历转农历
        public static DateTime SolarToLunar(this DateTime time)
        {
            ChineseLunisolarCalendar lunarCalendar;
            DateTime solar;
            int year, month, day;
            int leapMonth;

            lunarCalendar = new ChineseLunisolarCalendar();
            solar = time;
            year = lunarCalendar.GetYear(solar);
            month = lunarCalendar.GetMonth(solar);
            day = lunarCalendar.GetDayOfMonth(solar);
            leapMonth = lunarCalendar.GetLeapMonth(year);
            if (0 < leapMonth && leapMonth <= month)
            {
                --month;
            }
            solar = new DateTime(year, month, day);
            return solar;
        }

    }
}
