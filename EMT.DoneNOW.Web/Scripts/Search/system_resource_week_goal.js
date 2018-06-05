
function Edit() {
    window.open("../SysSetting/SysUserEdit.aspx?id=" + entityid, '340', 'left=0,top=0,location=no,status=no,width=900,height=750', false);
}

function SetWeek() {
    window.open('../SysSetting/AdjustResourceGoal?resId=' + entityid, '_blank', 'left=0,top=0,location=no,status=no,width=400,height=450', false);
}